clear;
x = [0 5 10 15 20];

% female speech, odd number is noisy,even number is denoised
f1=[0.7760 0.8555 0.9195 0.9627 0.9855];
f2=[0.7896 0.8704 0.9314 0.9637 0.9860];
f3=[0.7295 0.8337 0.9113 0.9588 0.9830];
f4=[0.7300 0.8423 0.9179 0.9620 0.9843];
f5=[0.7180 0.8286 0.9113 0.9604 0.9847];
f6=[0.7225 0.8409 0.9196 0.9638 0.9855];

delta1=f2-f1;  % white noise
delta2=f4-f3;  % babble noise
delta3=f6-f5;  % factory noise

m1=[0.7340 0.8116 0.8740 0.9195 0.9496];
m2=[0.7258 0.8162 0.8807 0.9245 0.9525];
m3=[0.6646 0.7774 0.8654 0.9211 0.9519];
m4=[0.6505 0.7791 0.8703 0.9248 0.9535];
m5=[0.6666 0.7767 0.8615 0.9171 0.9494];
m6=[0.6541 0.7778 0.8664 0.9206 0.9508];

delta4=m2-m1;
delta5=m4-m3;
delta6=m6-m5;

% figure(1);
% plot(x, delta1, 'k:s', x, delta2, 'b:o', x, delta3, 'm:d', 'LineWidth',2);
% set(gca,'xtick',0:5:20);
% xlabel('SNR(dB)');
% ylabel('STOI Gain');
% axis([0, 20, 0, 0.02]);
% grid minor;
% 
% figure(2);
% plot(x, delta4, 'k:s', x, delta5, 'b:o', x, delta6, 'm:d', 'LineWidth',2);
% set(gca,'xtick',0:5:20);
% xlabel('SNR(dB)');
% ylabel('STOI Gain');
% axis([0, 20, -0.015, 0.015]);
% grid minor;

SP1=[0.7760 0.8555 0.9195 0.9627 0.9855];
SP2=[0.7827 0.8628 0.9250 0.9654 0.9860];
SP3=[0.7295 0.8337 0.9113 0.9588 0.9830];
SP4=[0.7258 0.8362 0.9143 0.9605 0.9834];
SP5=[0.7180 0.8286 0.9113 0.9604 0.9847];
SP6=[0.7206 0.830 0.9150 0.9621 0.9848];

NSN1=[0.7760 0.8555 0.9195 0.9627 0.9855];
NSN2=[0.8545 0.9115 0.9504 0.9735 0.9865];
NSN3=[0.7295 0.8337 0.9113 0.9588 0.9830];
NSN4=[0.7856 0.8862 0.9452 0.9734 0.9865];
NSN5=[0.7180 0.8286 0.9113 0.9604 0.9847];
NSN6=[0.8101 0.8957 0.9461 0.9735 0.9874];

delta_SP1=SP2-SP1; % White noise
delta_SP2=SP4-SP3; % Babble noise
delta_SP3=SP6-SP5; % Factory noise

delta_NSN1=NSN2-NSN1; % White noise
delta_NSN2=NSN4-NSN3; % Babble noise
delta_NSN3=NSN6-NSN5; % Factory noise

figure(3);
plot(x, delta_SP1, 'k:s', x, delta1, 'b:o', x, delta_NSN1, 'm:d', 'LineWidth',2);
set(gca,'xtick',0:5:20);
xlabel('SNR(dB)');
ylabel('STOI Gain');
axis([0, 20, 0, 0.10]);
grid minor;

figure(4);
plot(x, delta_SP2, 'k:s', x, delta2, 'b:o', x, delta_NSN2, 'm:d', 'LineWidth',2);
set(gca,'xtick',0:5:20);
xlabel('SNR(dB)');
ylabel('STOI Gain');
axis([0, 20, -0.01, 0.10]);
grid minor;

figure(5);
plot(x, delta_SP3, 'k:s', x, delta3, 'b:o', x, delta_NSN3, 'm:d', 'LineWidth',2);
set(gca,'xtick',0:5:20);
xlabel('SNR(dB)');
ylabel('STOI Gain');
axis([0, 20, 0, 0.10]);
grid minor;
