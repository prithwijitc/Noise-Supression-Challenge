import soundfile as sf
from pystoi import stoi
import os 

# Get current working directory
cwd = os.getcwd()

# Clean speech path
clean_speech_path = cwd+'\\data\\clean\\female.wav'

# Denoised speech path
denoised_speech_path = cwd+'\\result\\reconstructed_signal.wav'

# Load clean speech
clean, fs = sf.read(clean_speech_path)

# Load denoised speech
denoised, fs = sf.read(denoised_speech_path)


# Handle uneven length of clean and denoised speech
if(len(clean) > len(denoised)):

    clean = clean[0:len(denoised)]

else:

    denoised = denoised[0:len(clean)]

# Calculate STOI
d = stoi(clean, denoised, fs, extended= False)
print("\tThe STOI is : {0}".format(d))