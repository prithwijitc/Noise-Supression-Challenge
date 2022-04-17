function [spectruesub_enspeech] = spectruesub(testsignal)
% �׼�������
% testsignalΪ���������ź�
% spectruesub_enspeechΪ�׼���������ź�
testsignal=testsignal';
%-------------------------------��������---------------------------------
frame_len=256; %֡��
step_len=0.5*frame_len; %��֡ʱ�Ĳ������൱���ص�50%
wav_length=length(testsignal);
R = step_len;
L = frame_len; 
f = (wav_length-mod(wav_length,frame_len))/frame_len;
k = 2*f-1; % ֡��
h = sqrt(1/101.3434)*hamming(256)'; % ����������ϵ����ԭ����ʹ�临������Ҫ��
testsignal = testsignal(1:f*L);  % ���������봿���������ȶ���
% signal= signal(1:f*L);
win = zeros(1,f*L); % �趨��ʼֵ��
spectruesub_enspeech = zeros(1,f*L);       
%-------------------------------��֡-------------------------------------
for r = 1:k 
    y = testsignal(1+(r-1)*R:L+(r-1)*R); % �Դ�������֡���ص�һ��ȡֵ��
    y = y.*h; % ��ȡ�õ�ÿһ֡���Ӵ�����
    w = fft(y); % ��ÿһ֡��������Ҷ�任��
    Y(1+(r-1)*L:r*L) = w(1:L); % �Ѹ���Ҷ�任ֵ����Y�У�
end
%-------------------------------��������-----------------------------------
   NOISE= stationary_noise_evaluate(Y,L,k); %������Сֵ�����㷨
%-------------------------------�׼���-------------------------------------
for     t = 1:k     
         X = abs(Y).^2;   
         S = X(1+(t-1)*L:t*L)-NOISE(1+(t-1)*L:t*L); % �������������׼�ȥ���������ף�
         S = sqrt(S);
         A = Y(1+(t-1)*L:t*L)./abs(Y(1+(t-1)*L:t*L)); % ��������������λ��
         S = S.*A; % ��Ϊ�˶�����λ�ĸо������ԣ����Իָ�ʱ�õ��Ǵ�����������λ��Ϣ��
         s = ifft(S);   
         s = real(s); % ȡʵ����
         spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2) = spectruesub_enspeech(1+(t-1)*L/2:L+(t-1)*L/2)+s; % ��ʵ�������ӣ�
         win(1+(t-1)*L/2:L+(t-1)*L/2) = win(1+(t-1)*L/2:L+(t-1)*L/2)+h; % ���ĵ�����ӣ�
end
spectruesub_enspeech = spectruesub_enspeech./win; % ȥ���Ӵ����������õ���ǿ��������
spectruesub_enspeech=spectruesub_enspeech';
end