function log_mmse(noisyfile,enhancedfile)

%
%  This function implements logMMSE algorithm [1].
% 
%  Usage:  logmmse(noisyFile, outputFile)
%           
%         noisyfile - noisy speech file in .wav format
%         enhancedfile - enhanced output file in .wav format
%  
%
%  References:
%   [1] Ephraim, Y. and Malah, D. (1985). Speech enhancement using a minimum 
%       mean-square error log-spectral amplitude estimator. IEEE Trans. Acoust., 
%       Speech, Signal Process., ASSP-23(2), 443-445.
%   

%-------------------------------------------------------------------------



[x, fs]= audioread(noisyfile);	%nsdata is a column vector

% =============== Initialize variables ===============

len_frame=floor(20*fs/1000); % Frame size in samples
if rem(len_frame,2)==1, len_frame=len_frame+1; end;
over=50; % window overlap in percent of frame size
len1=floor(len_frame*over/100);
len2=len_frame-len1; % update rate in samples


win=hanning(len_frame);  % define window
win = win*len2/sum(win);  % normalize window for equal level output 


% Noise magnitude calculations - assuming that the first 6 frames is
% noise/silen_framece 

NFFT=2*len_frame;
noise_sum=zeros(NFFT,1);
j=1;
for m=1:6
    noise_sum=noise_sum+abs(fft(win.*x(j:j+len_frame-1),NFFT));
    j=j+len_frame;
end
noise_mu=noise_sum/6;
noise_mu2=noise_mu.^2;

%--- allocate memory and initialize various variables



x_old=zeros(len1,1);
Nframes=floor(length(x)/len2)-floor(len_frame/len2);
x_enh=zeros(Nframes*len2,1);


%===============================  Start Processing =======================================================
%
k=1;
aa=0.98;
mu=0.98;
eta=0.15; 

ksi_min=10^(-25/10);

for n=1:Nframes

    input_sign=win.*x(k:k+len_frame-1);

    spec=fft(input_sign,NFFT);
    mag=abs(spec); % compute the magnitude
    sig2=mag.^2;

    gammak=min(sig2./noise_mu2,40);  % limit post SNR to avoid overflows
    if n==1
        ksi=aa+(1-aa)*max(gammak-1,0);
    else
        ksi=aa*Xk_prev./noise_mu2 + (1-aa)*max(gammak-1,0);     % a priori SNR
        ksi=max(ksi_min,ksi);  % limit ksi to -25 dB
    end

    log_sigma_k= gammak.* ksi./ (1+ ksi)- log(1+ ksi);    
    vad_decision= sum(log_sigma_k)/ len_frame;    
    if (vad_decision< eta) 
        % noise only frame found
        noise_mu2= mu* noise_mu2+ (1- mu)* sig2;
    end
    % ===end of vad===

    A=ksi./(1+ksi);  % Log-MMSE estimator
    vk=A.*gammak;
    ei_vk=0.5*expint(vk);
    hw=A.*exp(ei_vk);

    mag=mag.*hw;
    Xk_prev=mag.^2;

    xi_w= ifft( hw .* spec,NFFT);
    xi_w= real( xi_w);

    x_enh(k:k+ len2-1)= x_old+ xi_w(1:len1);
    x_old= xi_w(len1+ 1: len_frame);

    k=k+len2;
    
end

audiowrite(enhancedfile,x_enh,fs);