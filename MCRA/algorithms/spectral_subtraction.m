function spectral_subtraction(noisyfile,enhancedfile)

%  Implements the basic power spectral subtraction algorithm [1].
% 
%  Usage:  spectral_subtraction(noisyFile, outputFile)
%           
%         noisyfile - noisy speech file in .wav format
%         enhancedfile - enhanced output file in .wav format
%
%   First 5 frames are used for estimation of power spectral density(psd) of noise estimation, and 
%   then a simple VAD algorithm is used for updating it.
%   
%  Reference:
%   [1] Berouti, M., Schwartz, M., and Makhoul, J. (1979). Enhancement of speech 
%       corrupted by acoustic noise. Proc. IEEE Int. Conf. Acoust., Speech, 
%       Signal Processing, 208-211.
% 
%%------------------------------------------------------------------------


[x,fs]=audioread(noisyfile);


% =============== Initialize variables ===============
%

len_frame=floor(20*fs/1000); % Frame size in samples
if rem(len_frame,2)==1, len_frame=len_frame+1; end;
over=50; % window overlap in  of frame size
len1=floor(len_frame*over/100);
len2=len_frame-len1; 


Thres=3; % VAD threshold in dB SNR_segm 
alpha=2.0; % power exponent
FLOOR=0.002;
G=0.9; % gain

win=hanning(len_frame);  % define window
winGain=len2/sum(win); % normalization gain for overlap+add with 50% overlap

% Noise magnitude calculations - assuming that the first 5 frames is noise/silence
%
NFFT=2*2^nextpow2(len_frame);
noise_sum=zeros(NFFT,1);
j=1;
for k=1:5
   noise_sum=noise_sum+abs(fft(win.*x(j:j+len_frame-1),NFFT));
   j=j+len_frame;
end
noise_mu=noise_sum/5;

%--- allocate memory and initialize various variables
   
k=1;
img=sqrt(-1);
x_old=zeros(len1,1);
Nframes=floor(length(x)/len2)-1;
x_enh=zeros(Nframes*len2,1);

%===============================  Start Processing ==================================
%
for n=1:Nframes 
   
   input_sign=win.*x(k:k+len_frame-1);     %Windowing  
   spec=fft(input_sign,NFFT);     %compute fourier transform of a frame
   mag=abs(spec); % compute the magnitude
   
   %save the noisy phase information 
   theta=angle(spec);  
   
   SNR_segm=10*log10(norm(mag,2)^2/norm(noise_mu,2)^2);
   
   if alpha==1.0
      beta=berouti1(SNR_segm);
   else
     beta=berouti(SNR_segm);
  end
   
   
   %&&&&&&&&&
   sub_speech=mag.^alpha - beta*noise_mu.^alpha;
   diffw = sub_speech-FLOOR*noise_mu.^alpha;
   
   % FLOOR negative components
   z=find(diffw <0);  
   if~isempty(z)
      sub_speech(z)=FLOOR*noise_mu(z).^alpha;
   end
   
   
   % --- implement a simple VAD detector --------------
   %
   if (SNR_segm < Thres)   % Update noise spectrum
      noise_temp = G*noise_mu.^alpha+(1-G)*mag.^alpha;   
      noise_mu=noise_temp.^(1/alpha);   % new noise spectrum
   end
   
   
   sub_speech(NFFT/2+2:NFFT)=flipud(sub_speech(2:NFFT/2));  % to ensure conjugate symmetry for real reconstruction
  
   x_phase=(sub_speech.^(1/alpha)).*(cos(theta)+img*(sin(theta)));
  
   
   % take the IFFT 
   xi=real(ifft(x_phase));
       
   % --- Overlap and add ---------------
   x_enh(k:k+len2-1)=x_old+xi(1:len1);
   x_old=xi(1+len1:len_frame);
  
  

 k=k+len2;
end
%========================================================================================



audiowrite(enhancedfile,winGain*x_enh,fs);


%--------------------------------------------------------------------------

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