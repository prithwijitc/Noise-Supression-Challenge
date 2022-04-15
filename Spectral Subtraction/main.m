clc; clear all; close all;

% Clean speech path
clean_speech_path = append(pwd, '$PATH_TO_CLEAN_AUDIO$');

% Noisy speech path
noisy_speech_path = append(pwd, '$PATH_TO_NOISY_AUDIO$');

% Load clean speech
[clean, fs_clean] = audioread(clean_speech_path);

% Load noisy speech
[noisy, fs_noisy] = audioread(noisy_speech_path);

% Obtain noise suppressed speech using spectral subtraction
reconstructed_signal = spectralSubtraction(noisy, fs_noisy);

clean_speech = audioplayer(clean, fs_clean);
noisy_speech = audioplayer(noisy, fs_noisy);
reconstructed_speech = audioplayer(reconstructed_signal, fs_noisy);

%-----------Playing audio samples-------------

fprintf('Playing clean audio...\n');
playblocking(clean_speech);

fprintf('Playing noisy audio...\n');
playblocking(noisy_speech);

fprintf('Playing reconstructed audio...\n');
playblocking(reconstructed_speech);

%-------------------------------------

path = append(pwd, '$PATH_TO_RECONSTRUCTED_AUDIO$');
audiowrite(path, reconstructed_signal, fs_noisy);
message = append('File written to: ', path);
disp(message);