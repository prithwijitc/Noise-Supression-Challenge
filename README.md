# ECE6255: Noise Supression Challenge

This is the repository for ECE6255 Term Project: Noise Suppression for Speech Signals.

Submitted by: [Aanish Nair](mailto:anair319@gatech.edu), [Ningyuan Yang](mailto:nyang65@gatech.edu), [Prithwijit Chowdhury](mailto:pchowdhury6@gatech.edu) and [Sumedh Ravi](mailto:sravi71@gatech.edu).

## 1. Spectral Subtraction 

Code used can be found at : https://github.com/Gauri-Prajapati/Speech_Enhancement

### Step1: Setup Directory

Make sure that you have the ```main.m```, ```spectruesub.m``` and ```stationary_noise_evaluate.m``` files in the same directory. 

``` main.m ``` -> Used to run the algorithm

```spectruesub.m``` -> The spectral subtraction function

```stationary_noise_evaluate.m``` -> Calculate the noise power spectral density

Open ```MATLAB``` and make sure that you are in a working directory that has both the files in the same place. 

### Step2: Running the script

Make sure you change the file paths to the clean and noisy speech files that you intend to use. 

You can also include the path to where you want the reconstructed speech to be saved. 

Run the script ```main.m``` by clicking the 'Run' button or by typing in 'main' in the command window. 

## 2. MCRA

Code used can be found at : https://github.com/Gauri-Prajapati/Speech_Enhancement

### How to use codes in our folder

```Speech_Enhancement.m```: To perform noise suppression.

```\algorithms\improved_mcra_est.m```: The MRCA algorithm.

```add_noise.m```: To generate noisy speech audio files with different kinds of noise and different SNR.

```upsampling.ipynb```: To change the sampling rate of signals.

```plot_wave.m```: To plot waves of signals.

```plot_gain.m```: To generate plots of STOI gain in the report.

### Audio Files

The clean and the noisy audio files are stored in ```audio_samples```

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

The code for NSNet2 is forked from Microsofts repository for the [DNS Challenge](https://github.com/microsoft/DNS-Challenge).
___

### Audio Files

The clean and the noisy audio files are stored in ```audio_samples``` 

____
## STOI score
We used Short-Time Objective Intelligibility score (STOI) score as the evaluation metric to compare performance among different techniques. STOI denotes a correlation of short-time temporal envelopes between clean and separated speech, and has been shown to be positively correlated to human speech intelligibility score.

### Calculate your own STOI scores:
Once you have generated your filtered signal from your noise ```.wav``` file you can calculate your STOI score by passing your ```filtered signal``` and ```clean``` signal into the ```STOI_scorer.py``` file
```sh
clean, fs = sf.read('$CLEAN_WAV_FILE$')
denoised, fs = sf.read('$FILTERED_WAV_FILE$')
```
## RESULTS
Each method was applied to the noisy signals present in the ```audio_samples/noisy``` directory and passed into the ```STOI_scorer.py``` against the clean version present in ```audio_samples/clean``` directory to calculate the below-mentioned scores.
### Spectral Subtraction

#### Table 1: The STOI score for the Spectral Subtraction model on female speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.764395392     | 0.713892489      | 0.693418547       |
| 5             | 0.786096717     | 0.843549012      | 0.823020802       |
| 10            | 0.769182674     | 0.917590277      | 0.90786494        |
| 15            | 0.865750348     | 0.960017295      | 0.960974869       |
| 20            | 0.959871469     | 0.978716665      | 0.980476255       |

#### Table 2: The STOI score for the Spectral Subtraction model on male speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.728564718     | 0.629617858      | 0.598473262       |
| 5             | 0.732461151     | 0.763361273      | 0.735383703       |
| 10            | 0.769693403     | 0.862992213      | 0.844110818       |
| 15            | 0.84544193      | 0.913327423      | 0.898017772       |
| 20            | 0.93019754      | 0.948553703      | 0.943028037       |

### MCRA
#### Table 3: The STOI score for the MCRA algorithm on female speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.789572842     | 0.730013422      | 0.722507148       |
| 5             | 0.870410297     | 0.842261115      | 0.840886682       |
| 10            | 0.931425170     | 0.917922643      | 0.919574406       |
| 15            | 0.967322659     | 0.962099647      | 0.963756331       |
| 20            | 0.985977602     | 0.984296593      | 0.985493245       |

#### Table 4: The STOI score for the MCRA algorithm on male speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.725791143     | 0.650519418      | 0.654132316       |
| 5             | 0.816207934     | 0.779103948      | 0.777781786       |
| 10            | 0.880681926     | 0.870287679      | 0.866367288       |
| 15            | 0.924501503     | 0.924806368      | 0.920573518       |
| 20            | 0.952470337     | 0.953533491      | 0.950812644       |

### NSNet2

#### Table 5: The STOI score for the NSNet2 model on female speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.854522925     | 0.785587317      | 0.810069588       |
| 5             | 0.911464025     | 0.886194233      | 0.895671794       |
| 10            | 0.950381398     | 0.945235574      | 0.946084761       |
| 15            | 0.973417992     | 0.97344783       | 0.973501638       |
| 20            | 0.986519376     | 0.986543351      | 0.987445381       |

#### Table 6: The STOI score for the NSNet2 model on male speech with different additive noise

| **SNR value(in dB)** | **White Noise** | **Babble Noise** | **Factory Noise** |
|:-------------:|:---------------:|:----------------:|:-----------------:|
| 0             | 0.803318612     | 0.747798258      | 0.769623583       |
| 5             | 0.867076369     | 0.844080284      | 0.858208708       |
| 10            | 0.912214369     | 0.905727745      | 0.910814637       |
| 15            | 0.941520555     | 0.940993113      | 0.942007813       |
| 20            | 0.959001587     | 0.960383994      | 0.960543711       |

<img src="docs/tables-graphs/comparision of methods (STOI gain).png" width="500"> 
*Fig: STOI gain for denoised female speech with white noise using three methods
