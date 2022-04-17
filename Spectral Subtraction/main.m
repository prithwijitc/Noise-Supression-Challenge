[y, fs]=audioread('$ABSOLUTE_PATH_TO_NOISY_WAV$');
[spectruesub_enspeech] = spectruesub(y);
audiowrite('$ABSOLUTE_PATH_TO_STORE_FILTERED_WAV$',spectruesub_enspeech,fs);