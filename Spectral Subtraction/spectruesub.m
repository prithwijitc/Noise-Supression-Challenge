function [spectruesub_enspeech] = spectruesub(testsignal)
% Spectral Subtraction Function
% testsignal is a noisy speech signal
% spectruesub_enspeech is the signal after spectral subtraction
testsignal=testsignal';
%------------------------------PARAMETER DEFINITION----------------------------------
frame_len=256; % frame length
step_len=0.5*frame_len; % The step size when dividing the frame, which is equivalent to 50% overlap
wav_length=length(testsignal);
R = step_len;
L = frame_len; 
f = (wav_length-mod(wav_length,frame_len))/frame_len;
k = 2*f-1; % frame number
h = sqrt(1/101.3434)*hamming(256)'; % The reason why the Hanning window is multiplied by 
% the coefficient is to make it compound the conditional requirements
testsignal = testsignal(1:f*L);  % Noisy speech is length-aligned with clean speech
% signal= signal(1:f*L);
win = zeros(1,f*L); % set initial value
spectruesub_enspeech = zeros(1,f*L);       
%--------------------------------FRAMING------------------------------------
for r = 1:k 
    y = testsignal(1+(r-1)*R:L+(r-1)*R); % Value for half overlap between noisy speech frames
    y = y.*h; % Windowing each frame obtained 
    w = fft(y); % Fourier transform for each frame
    Y(1+(r-1)*L:r*L) = w(1:L); % put the Fourier transform value in Y
end
%---------------------------------ESTIMATED NOISE---------------------------------
   NOISE= stationary_noise_evaluate(Y,L,k); % Noise Minimum Tracking Algorithm
%-------------------------------Æ×¼õ·¨-------------------------------------
for     t = 1:k     
         X = abs(Y).^2;   
         S = X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L); % Noisy speech power spectrum minus noise power spectrum
         S = sqrt(S);
         A = Y(1+(t-1)*L:t*L)./abs(Y(1+(t-1)*L:t*L)); % phase with noise in speech
         S = S.*A; % Because the human ear does not perceive the phase clearly, the phase information of the noisy speech is used for recovery.
         s = ifft(S);   
         s = real(s); % take the real part
         spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2) = spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2)+s; % Concatenate and Add in the Real Domain
         win(1+(t-1)*L/2:L+(t-1)*L/2) = win(1+(t-1)*L/2:L+(t-1)*L/2)+h; % window stacking
end
spectruesub_enspeech = spectruesub_enspeech./win; % Remove the gain-enhanced speech caused by windowing
spectruesub_enspeech=spectruesub_enspeech';
end
