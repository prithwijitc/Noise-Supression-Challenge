import soundfile as sf
from pystoi import stoi


clean, fs = sf.read('/content/drive/MyDrive/audio_samples/clean/male.wav')
denoised, fs = sf.read('/content/audio_samples/male_white_5_nsnet2-20ms-baseline.wav')

#making both audio files of the same length

if len(denoised) > len(clean):
  denoised = denoised[0:len(clean)]
else:
    clean = clean[0:len(denoised)]

# Clean and den should have the same length, and be 1D
d = stoi(clean, denoised, fs, extended=False)
print(d) #display the value of the STOI score