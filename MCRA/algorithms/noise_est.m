function parameters = noise_est(noisy_ps,approach,parameters)
switch lower(approach)
    case 'imcra'
        parameters = improved_mcra_est(noisy_ps,parameters);
    case 'adaptive'
        parameters = adaptive_estimation(noisy_ps,parameters);
end
return;