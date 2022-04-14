clc
clear all
close all
[y,Fs] = audioread('STOI_py/female_white_0.wav');
subplot(4,1,1)
plot(y)
title('noisy signal')
xlabel('Sample Number')
ylabel('Amplitude')
%sound(y, Fs);
spec_sub_noise('STOI_py/female_white_0.wav', 'i_mcra', 'trying_1.wav');
[x,Fs1] = audioread('trying_1.wav');
spectral_subtraction('STOI_py/female_white_0.wav', 'trying_2.wav');
[x1,Fs2] = audioread('trying_2.wav');
[y_new, Fs] = audioread ('STOI_py/female.wav');
y1 = y(1:length(x));
y_new1 = y_new(1:length(x));
%sound(y_new, Fs);
subplot(4,1,2)
plot(y_new)
title('original signal')
xlabel('Sample Number')
ylabel('Amplitude')
subplot(4,1,3)
plot(x)
title('MCRA FILTERED signal')
xlabel('Sample Number')
ylabel('Amplitude')
subplot(4,1,4)
plot(x1)
title('spectral sub signal')
xlabel('Sample Number')
ylabel('Amplitude')
[z,fs] = audioread ('female_white_0_nsnet2.wav');
z = z(1:length(y_new));
subplot(4,1,4)
plot(z)
title('deep NSNet2')
xlabel('Sample Number')
ylabel('Amplitude')
%d_ac = stoi(y_new1, y1, Fs)
%d = stoi(y_new1, x, Fs)
%d1 = stoi(y_new1, x1, Fs)
d_new = stoi(y_new, z, fs)
