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

____
## RESULTS
Each method was applied to the noisy signals present in the ```audio_samples/noisy``` directory and pass into the ```STOI_scorer.py``` against the clean version present in ```audio_samples/clean``` directory to calculate the below-mentioned scores.
### NSNet2

#### Table: The STOI score for the NSNet2 model on female speech with different additive noise

| **SNR value** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.854522925     | 0.785587317      | 0.810069588       |
| 5             | 0.911464025     | 0.886194233      | 0.895671794       |
| 10            | 0.950381398     | 0.945235574      | 0.946084761       |
| 15            | 0.973417992     | 0.97344783       | 0.973501638       |
| 20            | 0.986519376     | 0.986543351      | 0.987445381       |

#### Table: The STOI score for the NSNet2 model on male speech with different additive noise

| **SNR value** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.803318612     | 0.747798258      | 0.769623583       |
| 5             | 0.867076369     | 0.844080284      | 0.858208708       |
| 10            | 0.912214369     | 0.905727745      | 0.910814637       |
| 15            | 0.941520555     | 0.940993113      | 0.942007813       |
| 20            | 0.959001587     | 0.960383994      | 0.960543711       |


