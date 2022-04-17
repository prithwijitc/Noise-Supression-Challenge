function spec_sub_noise(noisy_file,approach,enhancedfile)
%
%
%  This function implements the spectral subtraction algorithm [1] with different
%  noise estimation algorithms specified by 'approach'.
%  
%
%  Usage:  spec_sub_noise(noisyFile, approach, outputFile)
%           
%         infile - noisy speech file in .wav format
%         outputFile - enhanced output file in .wav format
%         approach - noise estimation algorithm:
%                  'i_mcra'     = improved Minimum controlled recursive
%                               average algorithm (Cohen) [2] 
%                  'adaptive'    = weighted spectral average (Hirsch &
%                               Ehrilcher) [3]
%

%
%  References:
%   [1] Berouti, M., Schwartz, M., and Makhoul, J. (1979). Enhancement of speech 
%       corrupted by acoustic noise. Proc. IEEE Int. Conf. Acoust., Speech, 
%       Signal Processing, 208-211.
%   [2] Cohen, I. (2003). Noise spectrum estimation in adverse environments: 
%       Improved minima controlled recursive averaging. IEEE Transactions on Speech 
%       and Audio Processing, 11(5), 466-475.
%   [3] Hirsch, H. and Ehrlicher, C. (1995). Noise estimation techniques for robust 
%       speech recognition. Proc. IEEE Int. Conf. Acoust. , Speech, Signal 
%       Processing, 153-156.

%-------------------------------------------------------------------------


[x,fs]=audioread(noisy_file);


% =============== Initialize variables ===============
%

len_frame=floor(20*fs/1000); % Frame size in samples
if rem(len_frame,2)==1, len_frame=len_frame+1; end;
over=50; % window overlap in percent of frame size
len1=floor(len_frame*over/100);
len2=len_frame-len1; 


alpha=2.0; % power exponent
FLOOR=0.002;
win=hamming(len_frame);   % define window


%--- allocate memory and initialize various variables
   
k=1;
NFFT=2*len_frame;
img=sqrt(-1);
x_old=zeros(len1,1);
Nframes=floor(length(x)/len2)-1;
x_enh=zeros(Nframes*len2,1);

%===============================  Start Processing =======================================================
%
for n=1:Nframes 
   
   input_sign=win.*x(k:k+len_frame-1);     %Windowing  
   spec=fft(input_sign,NFFT);     %compute fourier transform of a frame
   sig=abs(spec); % compute the magnitude
   noisy_psd=sig.^2;
   
   % ----------------- estimate/update noise psd --------------
   if n == 1
         parameters = init_params(noisy_psd,approach);   
    else
        parameters = noise_est(noisy_psd,approach,parameters);
   end
    
   noise_ps = parameters.noise_ps;
   noise_mu=sqrt(noise_ps);  % magnitude spectrum
   % ---------------------------------------------------------
   
    %save the phase information for each frame.
    theta=angle(spec);  
   
   SNR_segm=10*log10(norm(sig,2)^2/norm(noise_mu,2)^2);
   
   if alpha==1.0
      beta=berouti1(SNR_segm);
   else
     beta=berouti(SNR_segm);
  end
   
   
   %&&&&&&&&&
   sub_speech=sig.^alpha - beta*noise_mu.^alpha;
   diffw = sub_speech-FLOOR*noise_mu.^alpha;
   
   % Floor negative components
   z=find(diffw <0);  
   if~isempty(z)
      sub_speech(z)=FLOOR*noise_mu(z).^alpha;
   end
   
    
   sub_speech(NFFT/2+2:NFFT)=flipud(sub_speech(2:NFFT/2));  % to ensure conjugate symmetry for real reconstruction
   %multiply the whole frame fft with the phase information
   x_phase=(sub_speech.^(1/alpha)).*(cos(theta)+img*(sin(theta)));
  
   
   % take the IFFT 
   xi=real(ifft(x_phase));         
 
  % --- Overlap and add ---------------
  % 
  x_enh(k:k+len2-1)=x_old+xi(1:len1);
  x_old=xi(1+len1:len_frame);
  
 k=k+len2;
end
%========================================================================================


audiowrite(enhancedfile,x_enh,fs);
%-------------------------------- E N D --------------------------------------
function a=berouti1(SNR)

if SNR>=-5.0 & SNR<=20
   a=3-SNR*2/20;
else
   
  if SNR<-5.0
   a=4;
  end

  if SNR>20
    a=1;
  end
  
end

function a=berouti(SNR)

if SNR>=-5.0 & SNR<=20
   a=4-SNR*3/20; 
else
   
  if SNR<-5.0
   a=5;
  end

  if SNR>20
    a=1;
  end
  
end