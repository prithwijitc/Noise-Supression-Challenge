clc; clear all; close all;

[y, fs]=audioread('$ABSOLUTE_PATH_TO_NOISY_WAV$');
[spectruesub_enspeech] = spectruesub(y);
audiowrite('$ABSOLUTE_PATH_TO_STORE_FILTERED_WAV$',spectruesub_enspeech,fs);


fprintf("Playing Noisy Speech\n");
clean_speech = audioplayer(y(1:100000), fs);
playblocking(clean_speech);

fprintf("Playing Reconstructed Speech\n");
reconstructed_speech = audioplayer(spectruesub_enspeech(1:100000), fs);
playblocking(reconstructed_speech);
