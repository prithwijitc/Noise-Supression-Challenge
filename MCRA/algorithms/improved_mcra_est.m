function parameters = improved_mcra_est(noisy_psd,parameters)


n = parameters.n;
len = parameters.len;
gamma0 = parameters.gamma0;
psi0 = parameters.psi0;
alpha = parameters.alpha;
beta = parameters.beta;
b = parameters.b;
U = parameters.U;
V = parameters.V;
Bmin = parameters.Bmin;
gamma = parameters.gamma;
gamma1 = parameters.gamma1;
GH1 = parameters.GH1;
Sf = parameters.Sf;
Smin = parameters.Smin;
S = parameters.S;
S_tild = parameters.S_tild;
Sf_tild = parameters.Sf_tild;
Smin_tild = parameters.Smin_tild;
Smin_sw = parameters.Smin_sw;
Smin_sw_tild = parameters.Smin_sw_tild;
stored_min = parameters.stored_min;
stored_min_tild = parameters.stored_min_tild;
u1 = parameters.u1;
u2 = parameters.u2;
j = parameters.j;
alpha_d = parameters.alpha_d;
alpha_s = parameters.alpha_s;

noise_cap = parameters.noise_ps;
noise_tild = parameters.noise_tild;


gamma_old=gamma;
gamma=noisy_psd./noise_cap;                                     %to compute a posteriori SNR
eps_cap=alpha*(GH1.^2).*gamma_old+(1-alpha)*max(gamma-1,0);     %to compute a priori SNR
v=gamma.*eps_cap./(1+eps_cap);
exp_int=expint(v); %ei(v);
GH1=eps_cap.*exp(.5*exp_int)./(1+eps_cap);                      %to compute the value of GH1
Sf(1)=noisy_psd(1);Sf(end)=noisy_psd(end);
for f=2:len-1
    Sf(f)=sum(b.*[noisy_psd(f-1); noisy_psd(f); noisy_psd(f+1)]);
end

S=alpha_s*S+(1-alpha_s)*Sf;                                    %for computing S(k,l)
Smin=min(Smin,S);Smin_sw=min(Smin_sw,S);
gamma_min=noisy_psd./(Bmin*Smin);
psi=S./(Bmin*Smin);                                            %to compute gamma_min  and Psi
I=zeros(len,1);
index=find(gamma_min<gamma0 & psi<psi0);
I(index)=1;                                                    %compute I(k,l) 
for f=2:len-1
    if (I(f-1)+I(f)+I(f+1))==0
        Sf_tild(f)=S_tild(f);
    else
        Sf_tild(f)=sum(b.*[I(f-1); I(f); I(f+1)].*[noisy_psd(f-1); noisy_psd(f); noisy_psd(f+1)])/sum(b.*[I(f-1); I(f); I(f+1)]); 
    end                                                         %for updating Sf_tild
end
if I(1)==0        
    Sf_tild(1)=S_tild(1);
    Sf_tild(end)=S_tild(end);
else
    Sf_tild(1)=noisy_psd(1);
    Sf_tild(end)=noisy_psd(end);
end

S_tild=alpha_s*S_tild+(1-alpha_s)*Sf_tild;                        %for updating S_tild
Smin_tild=min(Smin_tild,S_tild);Smin_sw_tild=min(Smin_sw_tild,S_tild);
gamma_min_tild=noisy_psd./(Bmin*Smin_tild);
psi_tild=S./(Bmin*Smin_tild);                                     
q=zeros(len,1);                                                   %to find a priori speech absence probability  
index=find(gamma_min_tild<=1 & psi_tild<psi0);
index1=setdiff([1:len],index);
if (~isempty(index))
    q(index)=1;
end
index=find(gamma_min_tild>1 & gamma_min_tild<gamma1 & psi_tild<psi0);
if (~isempty(index))
    q(index)=(gamma1-gamma_min_tild(index))/(gamma1-1);             
end
%        p=1./(1+((q./(1-q)).*(1+eps_cap).*exp(-v)));
p=zeros(len,1);
if (~isempty(index1))
    temp1 = q(index1)./(1-q(index1));
    temp2 = 1 + eps_cap(index1);
    temp3 = exp(-v(index1));
    p(index1) = (1 + temp1.*temp2.*temp3).^-1;
end
%             p(index1)=1./(1+((q(index1)./(1-q(index1))).*(1+eps_cap(index1)).*exp(-v(index1))));    %to find conditional speech presence probability
alpha_d_tild=alpha_d+(1-alpha_d)*p;                                 %to update the time and frequency dependent smoothing factor
noise_tild=alpha_d_tild.*noise_tild+(1-alpha_d_tild).*noisy_psd;    %to update noise estimate 
noise_cap=beta*noise_tild;                                          %to update noise estimate for correction factor
j=j+1;
if j==V
   
    stored_min(:,u1)=Smin_sw;
    u1=u1+1;if u1==U+1; u1=1;end
    Smin=min(stored_min,[],2);
    Smin_sw=S;
    stored_min_tild(:,u2)=Smin_sw_tild;
    u2=u2+1;if u2==U+1; u2=1;end
    Smin_tild=min(stored_min_tild,[],2);
    Smin_sw_tild=S_tild;
    j=0;
end
ix=find(p>1 | q>1 | p<0 | q<0);
if (~isempty(ix))
    keyboard;
end
noise_ps = noise_cap;

parameters.n = n+1;
parameters.gamma = gamma;
parameters.GH1 = GH1;
parameters.Sf = Sf;
parameters.Smin = Smin;
parameters.S = S;
parameters.S_tild = S_tild;
parameters.Smin_tild = Smin_tild;
parameters.Smin_sw = Smin_sw;
parameters.Smin_sw_tild = Smin_sw_tild;
parameters.stored_min = stored_min;
parameters.stored_min_tild = stored_min_tild;
parameters.u1 = u1;
parameters.u2 = u2;
parameters.j = j;
parameters.noise_tild=noise_tild;
parameters.noise_ps = noise_ps;