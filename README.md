# ECE6255: Noise Supression Challenge

This is the repository for ECE6255 Term Project: Noise Suppression for Speech Signals.

Submitted by: [Aanish Nair](mailto:anair319@gatech.edu), [Ningyuan Yang](mailto:nyang65@gatech.edu), [Prithwijit Chowdhury](mailto:pchowdhury6@gatech.edu) and [Sumedh Ravi](mailto:sravi71@gatech.edu).

## 1. Spectral Subtraction 

### Step1: Setup Directory

Make sure that you have the ```main.m``` and ```spectralSubtraction.m``` files in the same directory. 
Open ```MATLAB``` and make sure that you are in a working directory that has both the files in the same place. 

### Step2: Running the script

Make sure you change the file paths to the clean and noisy speech files that you intend to use. 
You can also include the path to where you want the reconstructed speech to be saved. 
Run the script ```main.m``` by clicking the 'Run' button or by typing in 'main' in the command window. 

## 2. MCRA

## 3. NSNet2

### Step1: Checkpoint download

Download the [.onnx](check-point/nsnet2-20ms-baseline.onnx) checkpoint from the ```check-point``` directory and store it in your ```$CHECKPOINT DIRECTORY$```.

### Step2: Running the Baseline [GPU required]

Install ```requirements```

```sh
pip install -r requirements.txt
```
Replace ```$CHECKPOINT DIRECTORY$``` , ```$NOISY .WAV FILE$``` and ```$OUTPUT DIRECTORY$``` in ```run.py``` with the location of your model checkpoint, noisy ```.wav``` file and output folder to store the filter audio file respectively.

Run on GPU

```sh
python3 run.py
```

### Alternative 

Run the ``` run.ipynb ``` file on Google Colabs if you don't have local GPU access. Make sure to upload the ```.onnx``` checkpoint to drive and mount

___

### Audio Files

The clean and the noisy audio files are stored in ```audio_samples``` 

