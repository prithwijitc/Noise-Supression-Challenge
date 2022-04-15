# 6255 Noise Supression Challenge


## Spectral Subtraction 

## MCRA

## NSNet2

### Step1: Checkpoint download

Download the ``` .onnx ``` checkpoint from the ```check-point``` directory and store it in your ```$CHECKPOINT DIRECTORY$```.

### Step3 Running the Baseline [GPU required]

Install ```requirements```

```sh
pip install -r requirements.txt
```
Replace ```$CHECKPOINT DIRECTORY$``` , ```$NOISY .WAV FILE$``` and ```$OUTPUT DIRECTORY$``` in ```run.py``` with the location of your model checkpoint, noise .wav file and output folder to store the filter audio file respectively.

Run on GPU

```sh
python3 run.py
```


Run the ``` run.ipynb ``` file on Google Colabs if you don't have local GPU access

## Audio FIles (DATASET)

The clean and the noisy audio files are stored here: 
```sh
$ADD DRIVE LINK TO AUDIO ZIP FILES$
```
