function noisy = add_noise(signal,noise,SNR)
% TO add determinated noise to a signal.
% SNR is signal-to-noise ratio in dB.
len=size(signal,1);
NOISE=noise(1:len);
NOISE=NOISE-mean(NOISE);
signal_power=1/len*sum(signal.*signal);
noise_variance=signal_power/(10^(SNR/10));
NOISE=sqrt(noise_variance)/std(NOISE)*NOISE;
noisy=signal+NOISE;
end
