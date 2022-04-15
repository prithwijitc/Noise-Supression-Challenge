# ECE6255: Noise Supression Challenge

This is the repository for ECE6255 Term Project: Noise Suppression for Speech Signals.

Submitted by: [Aanish Naair](anair319@gatech.edu), [Ningyuan Yang](nyang65@gatech.edu), [Prithwijit Chowdhury](pchowdhury6@gatech.edu) and [Sumedh Ravi](sravi71@gatech.edu).

## 1. Spectral Subtraction 

## 2. MCRA

## 3. NSNet2

### Step1: Checkpoint download

Download the [.onnx](check-point/nsnet2-20ms-baseline.onnx) checkpoint from the ```check-point``` directory and store it in your ```$CHECKPOINT DIRECTORY$```.

### Step2: Running the Baseline [GPU required]

Install ```requirements```

```sh
pip install -r requirements.txt
```
Replace ```$CHECKPOINT DIRECTORY$``` , ```$NOISY .WAV FILE$``` and ```$OUTPUT DIRECTORY$``` in ```run.py``` with the location of your model checkpoint, noise .wav file and output folder to store the filter audio file respectively.

Run on GPU

```sh
python3 run.py
```

### Alternative 

Run the ``` run.ipynb ``` file on Google Colabs if you don't have local GPU access. Make sure to upload the ```.onnx``` checkpoint to drive and mount

## Audio FIles

The clean and the noisy audio files are stored in ```audio_samples``` 

