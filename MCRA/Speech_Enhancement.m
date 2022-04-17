% Main file of Speech Enhancement

clc
close all
spec_sub_noise('female_fact_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_fact_0.wav')
spec_sub_noise('female_fact_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_fact_5.wav')
spec_sub_noise('female_fact_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_fact_10.wav')
spec_sub_noise('female_fact_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_fact_15.wav')
spec_sub_noise('female_fact_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_fact_20.wav')

spec_sub_noise('female_babb_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_babb_0.wav')
spec_sub_noise('female_babb_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_babb_5.wav')
spec_sub_noise('female_babb_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_babb_10.wav')
spec_sub_noise('female_babb_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_babb_15.wav')
spec_sub_noise('female_babb_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_babb_20.wav')

spec_sub_noise('female_white_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_white_0.wav')
spec_sub_noise('female_white_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_white_5.wav')
spec_sub_noise('female_white_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_white_10.wav')
spec_sub_noise('female_white_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_white_15.wav')
spec_sub_noise('female_white_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/female_white_20.wav')

spec_sub_noise('male_fact_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_fact_0.wav')
spec_sub_noise('male_fact_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_fact_5.wav')
spec_sub_noise('male_fact_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_fact_10.wav')
spec_sub_noise('male_fact_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_fact_15.wav')
spec_sub_noise('male_fact_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_fact_20.wav')

spec_sub_noise('male_babb_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_babb_0.wav')
spec_sub_noise('male_babb_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_babb_5.wav')
spec_sub_noise('male_babb_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_babb_10.wav')
spec_sub_noise('male_babb_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_babb_15.wav')
spec_sub_noise('male_babb_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_babb_20.wav')

spec_sub_noise('male_white_0.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_white_0.wav')
spec_sub_noise('male_white_5.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_white_5.wav')
spec_sub_noise('male_white_10.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_white_10.wav')
spec_sub_noise('male_white_15.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_white_15.wav')
spec_sub_noise('male_white_20.wav','i_mcra','C:/Users/21316/Desktop/audio_samples/denoised/male_white_20.wav')

%     spectral_subtraction(filepath{i,1},save_path); % spectral substraction method
%     spec_sub_noise(filepath{i,1},'adpative',save_path) % 'adaptive' method for noise estimation along with spectral subtraction
%     log_mmse(filepath{i,1},save_path) % for log mmse algorithm
%     wiener_aprior(filepath{i,1},save_path) % Wiener filtering algorithm based on a priori SNR estimation
%     improved_mcra_est(filepath{i,1},'i_mcra',save_path) % improved Minimum controlled recursive average algorithm 


