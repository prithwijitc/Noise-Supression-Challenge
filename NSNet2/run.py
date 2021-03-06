import numpy as np
import soundfile as sf
from pathlib import Path
from scipy.signal import blackman, blackmanharris
import argparse
import numpy as np
import soundfile as sf
from pathlib import Path
import onnxruntime as ort
import torch
import scipy
import scipy.signal

def calcFeat(Spec, cfg):
    """compute spectral features"""

    if cfg['feattype'] == "MagSpec":
        inpFeat = np.abs(Spec)

    elif cfg['feattype'] == "LogPow":
        pmin = 10**(-12)
        powSpec = np.abs(Spec)**2
        inpFeat = np.log10(np.maximum(powSpec, pmin))

    else:
        ValueError('Feature not implemented.')
    
    return inpFeat


def calcSpec(y, params, channel=None):
    """compute complex spectrum from audio file"""

    fs = int(params["fs"])

    if channel is not None and (len(y.shape)>1):
        # use only single channel
        sig = sig[:,channel]

    # STFT parameters
    N_win = int(float(params["winlen"])*fs)
    if 'nfft' in params:
        N_fft = int(params['nfft'])
    else:
        N_fft = int(float(params['winlen'])*fs)
    N_hop = int(N_win * float(params["hopfrac"]))
    win = np.sqrt(np.hanning(N_win))

    Y = stft(y, N_fft, win, N_hop)

    return Y


def spec2sig(Spec, params):
    """convert spectrum to time signal"""

    # STFT parameters
    fs = int(params["fs"])
    N_win = int(float(params["winlen"])*fs)
    if 'nfft' in params:
        N_fft = int(params['nfft'])
    else:
        N_fft = int(float(params['winlen'])*fs)
    N_hop = int(N_win * float(params["hopfrac"]))
    win = np.sqrt(np.hanning(N_win))

    x = istft(Spec, N_fft, win, N_hop)

    return x


# STFT
def stft(x, N_fft, win, N_hop, nodelay=True):
	"""
	short-time Fourier transform
		x 			time domain signal [samples x channels]
		N_fft 		FFT size (samples)
		win 		window,  len(win) <= N_fft
		N_hop 		hop size (samples)
		nodelay 	[True,False]: do not introduce delay (visible windowing effects in first frames)
	"""
	# get lengths
	if x.ndim == 1:
		x = x[:,np.newaxis]
	Nx = x.shape[0]
	M = x.shape[1]
	specsize = int(N_fft/2+1)
	N_win = len(win)
	N_frames = int(np.ceil( (Nx+N_win-N_hop)/N_hop ))
	Nx = N_frames*N_hop # padded length
	x = np.vstack([x, np.zeros((Nx-len(x),M))])
	
	# init
	X_spec = np.zeros((specsize,N_frames,M), dtype=complex)
	win_M = np.outer(win,np.ones((1,M)))
	x_frame = np.zeros((N_win,M))
	for nn in range(0,N_frames):
		idx = int(nn*N_hop)
		x_frame = np.vstack((x_frame[N_hop:,:], x[idx:idx+N_hop,:]))
		x_win = win_M * x_frame
		X = np.fft.rfft(x_win, N_fft, axis=0)
		X_spec[:,nn,:] = X

	if nodelay:
		delay = int(N_win/N_hop - 1)
		X_spec = X_spec[:,delay:,:]

	if M==1:
		X_spec = np.squeeze(X_spec)
	
	return X_spec


def istft(X, N_fft, win, N_hop):
	# get lengths
	specsize = X.shape[0]
	N_frames = X.shape[1]
	if X.ndim < 3:
		X = X[:,:,np.newaxis]
	M = X.shape[2]
	N_win = len(win)
	
	# init
	Nx = N_hop*(N_frames-1) + N_win
	win_M = np.outer(win,np.ones((1,M)))
	x = np.zeros((Nx,M))
	
	for nn in range(0,N_frames):
		X_frame = np.squeeze(X[:,nn,:])
		x_win = np.fft.irfft(X_frame, N_fft, axis=0)
		x_win = x_win.reshape(N_fft,M)
		x_win = win_M * x_win[0:N_win,:]
		idx1 = int(nn*N_hop); idx2 = int(idx1+N_win)
		x[idx1:idx2,:] = x_win + x[idx1:idx2,:]
	
	if M==1:
		x = np.squeeze(x)
	
	return x

class NSnet2Enhancer(object):
    """NSnet2 enhancer class."""

    def __init__(self, modelfile, cfg=None):
        """Instantiate NSnet2 given a trained model path."""
        self.cfg = cfg
        self.frameShift = float(self.cfg['winlen'])* float(self.cfg["hopfrac"])
        self.fs = int(self.cfg['fs'])
        self.mingain = 10**(self.cfg['mingain']/20)
        self.N_win = int(float(self.cfg['winlen']) * self.fs)
        if 'nfft' in cfg:
            self.N_fft = int(self.cfg['nfft'])
        else:
            self.N_fft = self.N_win
        self.N_hop = int(self.N_fft * float(cfg["hopfrac"]))
        
        """load onnx model"""
        self.ort = ort.InferenceSession(modelfile)
        self.dtype = np.float32
        self.win = np.sqrt(scipy.signal.windows.hann(self.N_win, sym=False))
        self.win_buf = torch.from_numpy(self.win).float()        
        L = len(self.win)
        awin = np.zeros_like(self.win)
        for k in range(0, self.N_hop):
            idx = range(k, L, self.N_hop)
            H = self.win[idx]
            awin[idx] = np.linalg.pinv(H[:,np.newaxis])
        self.awin = torch.from_numpy(awin).float()

    def enhance(self, x):
        """Obtain the estimated filter"""
        onnx_inputs = {self.ort.get_inputs()[0].name: x.astype(self.dtype)}
        out = self.ort.run(None, onnx_inputs)[0][0]
        return out

    def enhance_48khz(self, x):
        """Run model on single sequence"""
        if len(x.shape) < 2:
            x = torch.from_numpy(np.expand_dims(x, 0)).float()
        else:
            x = x.transpose()
        # x: [channels, samples]

        sig_framed = torch.nn.functional.conv1d(x.unsqueeze(1), weight=torch.diag(self.win_buf).unsqueeze(1), stride=self.N_hop).permute(0,2,1).contiguous()
        spec = torch.fft.rfft(sig_framed, n=self.N_fft)
        spec = torch.stack((spec.real, spec.imag), dim=-1)
        feat = torch.log10(torch.sum(spec**2, dim=-1).clamp_min(1e-12))
        onnx_inputs = {self.ort.get_inputs()[0].name: feat.numpy().astype(self.dtype)}
        out = self.ort.run(None, onnx_inputs)[0]
        out = torch.from_numpy(out).float()
        out_spec = out.unsqueeze(3) * spec
        out_spec_restacked = torch.complex(out_spec[:,:,:,0], out_spec[:,:,:,1]).contiguous()
        x_framed = torch.fft.irfft(out_spec_restacked, n=self.N_fft)[:,:,0:self.N_win]
        # overlapp-add using conv_transpose
        sig = torch.nn.functional.conv_transpose1d(x_framed.permute(0,2,1), weight=torch.diag(self.awin).unsqueeze(1), stride=self.N_hop).squeeze(1).contiguous()
        return sig[0]

    def __call__(self, sigIn, inFs):
        """Enhance a single Audio signal."""
        assert inFs in (16000, 48000), "Inconsistent sampling rate!"

        if inFs == 48000:
            return self.enhance_48khz(sigIn)

        inputSpec = calcSpec(sigIn, self.cfg)
        inputFeature = calcFeat(inputSpec, self.cfg)
        # shape: [batch x time x freq]
        inputFeature = np.expand_dims(np.transpose(inputFeature), axis=0)

        # Obtain network output
        out = self.enhance(inputFeature)
        
        # limit suppression gain
        Gain = np.transpose(out)
        Gain = np.clip(Gain, a_min=self.mingain, a_max=1.0)
        outSpec = inputSpec * Gain

        # go back to time domain
        sigOut = spec2sig(outSpec, self.cfg)

        return sigOut

#!/usr/bin/env python3
import argparse
import numpy as np
import soundfile as sf
from pathlib import Path
#import NSnet2Enhancer

"""
    Inference script for NSnet2 baseline.
"""

def main(model,input,output,fs):
    # check input path
    inPath = Path(input).resolve()
    assert inPath.exists()

    cfg = {
            'winlen'   : 0.02,
            'hopfrac'  : 0.5,
            'fs'       : fs,
            'mingain'  : -80,
            'feattype' : 'LogPow',
            'nfft'     : 320
        }

    if fs == 48000:
        cfg['nfft'] = 1024

    # Create the enhancer
    enhancer = NSnet2Enhancer(modelfile=model, cfg=cfg)

    # get modelname
    modelname = Path(model).stem

    if inPath.is_file() and inPath.suffix == '.wav':
        # input is single .wav file
        sigIn, fs = sf.read(str(inPath))
        if len(sigIn.shape) > 1:
            sigIn = sigIn[:,0]

        outSig = enhancer(sigIn, fs)

        outname = './{:s}_{:s}.wav'.format(inPath.stem, modelname)
        if output:
            # write in given dir
            outdir = Path(output)
            outdir.mkdir(exist_ok=True)
            outpath = outdir.joinpath(outname)
        else:
            # write in current work dir
            outpath = Path(outname)

        print('Writing output to:', str(outpath))
        sf.write(outpath.resolve(), outSig, fs)

    elif inPath.is_dir():
        # input is directory
        if output:
            # full provided path
            outdir = Path(output).resolve()
        else:
            outdir = inPath.parent.joinpath(modelname).resolve()

        outdir.mkdir(parents=True, exist_ok=True)
        print('Writing output to:', str(outdir))

        fpaths = list(inPath.glob('*.wav'))

        for ii, path in enumerate(fpaths):
            print(f"Processing file [{ii+1}/{len(fpaths)}]")
            print(path)

            sigIn, fs = sf.read(str(path))

            if len(sigIn.shape) > 1:
                sigIn = sigIn[:,0]

            outSig = enhancer(sigIn, fs)
            outSig1 = np.convolve(sigIn, outSig)
            outpath = outdir / path.name
            outpath = str(outpath)
            sf.write(outpath, outSig1, fs)

    else:
        raise ValueError("Invalid input path.")

model = '$CHECKPOINT DIRECTORY$'
input = '$NOISY .WAV FILE$'
output = '$OUTPUT DIRECTORY$'


fs = 16000
main(model,input,output,fs)
