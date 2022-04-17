function wiener_aprior(noisyfile,enhancedfile)

%
%  Implements the Wiener filtering algorithm based on a priori SNR estimation [1].
% 
%  Usage:  wiener_aprior(noisyfile, outputFile)
%           
%         noisyfile - noisy speech file in .wav format
%         enhancedile - enhanced output file in .wav format
%
%  References:
%   [1] Scalart, P. and Filho, J. (1996). Speech enhancement based on a priori 
%       signal to noise estimation. Proc. IEEE Int. Conf. Acoust. , Speech, Signal 
%       Processing, 629-632.
%
%-------------------------------------------------------------------------



[x, fs]= audioread(noisyfile);
x= x; 
% column vector x

% set parameter values
mu= 0.98; % smoothing factor in noise spectrum update
a= 0.98; % smoothing factor in priori update
eta= 0.15; % VAD threshold

len_frame=floor(20*fs/1000); % Frame size in samples
hamming_win= hamming( len_frame); % hamming window
U= ( hamming_win'* hamming_win)/ len_frame; % normalization factor

% first 120 ms is noise only (assuming 6 frames)
len_120ms= fs/ 1000* 120;
first_120ms= x( 1: len_120ms);

% =============now use Welch's method to estimate power spectrum with
% Hamming window and 50% overlap
n_subband_frames= floor( len_120ms/ (len_frame/ 2))- 1;  % 50% overlap
noise_psd= zeros( len_frame, 1);
n_start= 1; 
for j= 1: n_subband_frames
    noise= first_120ms( n_start: n_start+ len_frame- 1);
    noise= noise.* hamming_win;
    noise_fft= fft( noise, len_frame);
    noise_psd= noise_psd+ ( abs( noise_fft).^ 2)/ (len_frame* U);
    n_start= n_start+ len_frame/ 2; 
end
noise_psd= noise_psd/ n_subband_frames;
%==============

% number of noisy speech frames 
len1= len_frame/ 2; % with 50% overlap
nframes= floor( length( x)/ len1)- 1; 
n_start= 1; 

for j= 1: nframes
    noisy= x( n_start: n_start+ len_frame- 1);
    noisy= noisy.* hamming_win;
    noisy_fft= fft( noisy, len_frame);
    noisy_ps= ( abs( noisy_fft).^ 2)/ (len_frame* U);
    
    % ============ voice activity detection
    if (j== 1) % initialize posteri
        posteri= noisy_ps./ noise_psd;
        posteri_prime= posteri- 1; 
        posteri_prime( find( posteri_prime< 0))= 0;
        priori= a+ (1-a)* posteri_prime;
    else
        posteri= noisy_ps./ noise_psd;
        posteri_prime= posteri- 1;
        posteri_prime( find( posteri_prime< 0))= 0;
        priori= a* (G_prev.^ 2).* posteri_prev+ ...
            (1-a)* posteri_prime;
    end

    log_sigma_k= posteri.* priori./ (1+ priori)- log(1+ priori);    
    vad(j)= sum( log_sigma_k)/ len_frame;    
    if (vad(j)< eta) 
        % noise only frame found
        noise_psd= mu* noise_psd+ (1- mu)* noisy_ps;
        vad( n_start: n_start+ len_frame- 1)= 0;
    else
        vad( n_start: n_start+ len_frame- 1)= 1;
    end
    % ===end of vad===
    
    G= sqrt( priori./ (1+ priori)); % gain function
   
    enhanced= ifft( noisy_fft.* G, len_frame);
        
    if (j== 1)
        enhanced_speech( n_start: n_start+ len_frame/2- 1)= ...
            enhanced( 1: len_frame/2);
    else
        enhanced_speech( n_start: n_start+ len_frame/2- 1)= ...
            overlap+ enhanced( 1: len_frame/2);  
    end
    
    overlap= enhanced( len_frame/ 2+ 1: len_frame);
    n_start= n_start+ len_frame/ 2; 
    
    G_prev= G; 
    posteri_prev= posteri;
    
end

enhanced_speech( n_start: n_start+ len_frame/2- 1)= overlap; 

% wavwrite( enhanced_speech, fs, nbits, enhancedfile);
audiowrite(enhancedfile,enhanced_speech,fs);