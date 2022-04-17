function parameters = init_params(noisy_psd,approach)
len_val = length(noisy_psd);
switch lower(approach)
    case 'i_mcra'
        alpha_d_val=0.85;
        alpha_s_val=0.9;
        U_val=8;V_val=15;
        Bmin_val=1.66;gamma0_val=4.6;gamma1_val=3;
        psi0_val=1.67;alpha_val=0.92;beta_val=1.47;
        j_val=0;
        b_val=hanning(3);
        B_val=sum(b_val);
        b_val=b_val/B_val;
        Sf_val=zeros(len_val,1);Sf_tild_val=zeros(len_val,1);
        Sf_val(1) = noisy_psd(1);
        for f=2:len_val-1
            Sf_val(f)=sum(b_val.*[noisy_psd(f-1);noisy_psd(f);noisy_psd(f+1)]);
        end
        Sf_val(len_val)=noisy_psd(len_val);
        Sf_tild_val = zeros(len_val,1);
        parameters = struct('n',2,'len',len_val,'noise_ps',noisy_psd,'noise_tild',noisy_psd,'gamma',ones(len_val,1),'Sf',Sf_val,...
            'Smin',Sf_val,'S',Sf_val,'S_tild',Sf_val,'GH1',ones(len_val,1),'Smin_tild',Sf_val,'Smin_sw',Sf_val,'Smin_sw_tild',Sf_val,...
            'stored_min',max(noisy_psd)*ones(len_val,U_val),'stored_min_tild',max(noisy_psd)*ones(len_val,U_val),'u1',1,'u2',1,'j',2,...
            'alpha_d',0.85,'alpha_s',0.9,'U',8,'V',15,'Bmin',1.66,'gamma0',4.6,'gamma1',3,'psi0',1.67,'alpha',0.92,'beta',1.47,...
            'b',b_val,'Sf_tild',Sf_tild_val);
   
    case 'adaptive'
        parameters = struct('n',2,'len',len_val,'as',0.85,'beta',1.5,'omin',1.5,'noise_ps',noisy_psd,'P',noisy_psd);
   
    otherwise
            error('approach can not be implemented (not available).');
end