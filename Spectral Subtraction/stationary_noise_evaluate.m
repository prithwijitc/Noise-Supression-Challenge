function  NOISE= stationary_noise_evaluate(Y,L,k);  % define subfunction
% Calculation of noise power spectral density p
%-----------------------Calculation of Rough Noise Power Spectral Density p-------------------------
for b = 1:L % The outer loop starts, b represents the frequency component, here we exhaust all the frequency components
    p = [0.15*abs(Y(b)).^2,zeros(1,k)]; 
    a = 0.85; 
    for  d = 1:k-1
         p(d+1) = a*p(d)+(1-a)*abs(Y(b+d*L)).^2;
    end
%-----------------------Estimation of noise variance actmin----------------------------
    for  e = 1:k-95
         actmin(e) = min(p(e:95+e));
    end
    for  l = k-94:k
         m(l-(k-95)) = min(p(l:k)); 
    end
    actmin = [actmin(1:k-95),m(1:95)];  
    c(1+(b-1)*k:b*k) = actmin(1:k); 
end %  At the end of the outer loop, a specific frequency component is calculated from the beginning to the end of the outer loop.
   for t = 1:k
         for  j = 1:L
              d(j) = c(t+(j-1)*k);
         end 
       n(1+(t-1)*L:t*L) = d(1:L);  
   end
NOISE =n;
   

   

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
