function output=demodulation_c(input,fc,fs)
%���
t=(1:length(input))';
y=2*input.*cos(2*pi*fc*t/fs);
[b,a] = butter(5,fc*2/fs); %5�װ�����˹��ͨ�˲�
output = filter(b,a,y);