function [spectruesub_enspeech] = spectruesub(testsignal)
% 谱减法函数
% testsignal为带噪语音信号
% spectruesub_enspeech为谱减法处理后信号
testsignal=testsignal';
%-------------------------------参数定义---------------------------------
frame_len=256; %帧长
step_len=0.5*frame_len; %分帧时的步长，相当于重叠50%
wav_length=length(testsignal);
R = step_len;
L = frame_len; 
f = (wav_length-mod(wav_length,frame_len))/frame_len;
k = 2*f-1; % 帧数
h = sqrt(1/101.3434)*hamming(256)'; % 汉宁窗乘以系数的原因是使其复合条件要求；
testsignal = testsignal(1:f*L);  % 带噪语音与纯净语音长度对齐
% signal= signal(1:f*L);
win = zeros(1,f*L); % 设定初始值；
spectruesub_enspeech = zeros(1,f*L);       
%-------------------------------分帧-------------------------------------
for r = 1:k 
    y = testsignal(1+(r-1)*R:L+(r-1)*R); % 对带噪语音帧间重叠一半取值；
    y = y.*h; % 对取得的每一帧都加窗处理；
    w = fft(y); % 对每一帧都作傅里叶变换；
    Y(1+(r-1)*L:r*L) = w(1:L); % 把傅里叶变换值放在Y中；
end
%-------------------------------估计噪声-----------------------------------
   NOISE= stationary_noise_evaluate(Y,L,k); %噪声最小值跟踪算法
%-------------------------------谱减法-------------------------------------
for     t = 1:k     
         X = abs(Y).^2;   
         S = X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L); % 含噪语音功率谱减去噪声功率谱；
         S = sqrt(S);
         A = Y(1+(t-1)*L:t*L)./abs(Y(1+(t-1)*L:t*L)); % 带噪于语音的相位；
         S = S.*A; % 因为人耳对相位的感觉不明显，所以恢复时用的是带噪语音的相位信息；
         s = ifft(S);   
         s = real(s); % 取实部；
         spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2) = spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2)+s; % 在实域叠接相加；
         win(1+(t-1)*L/2:L+(t-1)*L/2) = win(1+(t-1)*L/2:L+(t-1)*L/2)+h; % 窗的叠接相加；
end
spectruesub_enspeech = spectruesub_enspeech./win; % 去除加窗引起的增益得到增强的语音；
spectruesub_enspeech=spectruesub_enspeech';
end