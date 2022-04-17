function parameters = adaptive_estimation(noisy_psd,parameters)


n = parameters.n;
len = parameters.len;
as = parameters.as;
beta = parameters.beta;
omin = parameters.omin;

noise_ps = parameters.noise_ps;
P = parameters.P;

P=as*P+(1-as)*noisy_psd; 
index=find(P<beta*noise_ps);
noise_ps(index)=as*noise_ps(index)+(1-as)*P(index); % noise psd

% modifying parameters
parameters.P = P;
parameters.noise_ps = noise_ps;
