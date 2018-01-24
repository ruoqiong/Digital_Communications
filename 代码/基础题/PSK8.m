%%
%8PSK
clear,clc
N=120;%0,1����źŵĸ���
s=randi([0,1],N,1);%����4000������ź�
%%
%���ֵ���
[rpsk_s,ipsk_s]=psk_8(s);%�ֱ����ʵ���鲿
%%
%�����˲�
rolloff = 0.25;%����ϵ��
span = 8; %�˲������
sps = 40;%ÿ�����ŵĲ�������
b = rcosdesign(rolloff, span, sps); %�������˲���
rx_psk = upfirdn(rpsk_s, b, sps); %ʵ�������˲�
ix_psk = upfirdn(ipsk_s, b, sps); %ʵ�������˲�
%%
%���Ƶ���Ƶ
fc=1;
fs=10;
rxpsk_m=modulation_c(rx_psk,fc,fs);
ixpsk_m=modulation_s(ix_psk,fc,fs);
xpsk_m=rxpsk_m+ixpsk_m;
%%
%�ź�ͨ��awgn�ŵ�
EbNo=20;
snr= EbNo + 10*log10(3) - 10*log10(sps);
rx=awgn(xpsk_m,snr,'measured');
%%
%�����źŽ��
r_psk=demodulation_c(rx,fc,fs);
i_psk=demodulation_s(rx,fc,fs);
%%
%ƥ���˲�
R_s=upfirdn(r_psk, b,1,sps);
r_s=R_s(span+1:length(R_s)-span);
I_s=upfirdn(i_psk, b,1,sps);
i_s=I_s(span+1:length(I_s)-span);
%%
%�о�
re_psk=depsk_8(r_s,i_s);
%%
%ͳ��������
ber=sum(abs(re_psk-s))/length(re_psk);
%%
% 8PSK���
figure
stem(1:N,s)
title('ԭʼ�ź�����')
figure
stem(1:length(rpsk_s),rpsk_s)
title('8PSK��ʵ��')
figure
plot(1:length(rx_psk),rx_psk)
title('ʵ�������˲�')
figure
plot(1:length(rxpsk_m),rxpsk_m)
title('ʵ�����Ƶ��ز�')
figure
stem(1:length(ipsk_s),ipsk_s)
title('8PSK���鲿')
figure
plot(1:length(ix_psk),ix_psk)
title('�鲿�����˲�')
figure
plot(1:length(ixpsk_m),ixpsk_m)
title('�鲿���Ƶ��ز�')
figure
plot(1:length(xpsk_m),xpsk_m);
title('8PSK�����ź�')
figure
plot(1:length(xpsk_m),abs(fft(xpsk_m)));
title('8PSK�����ź�Ƶ��')
figure
subplot(2,1,1)
plot(1:length(r_psk),r_psk)
title('ʵ���źŽ��')
subplot(2,1,2)
plot(1:length(i_psk),i_psk)
title('�鲿�źŽ��')
figure
subplot(2,1,1)
stem(1:length(r_s),r_s)
title('ƥ���˲�ʵ�����')
subplot(2,1,2)
stem(1:length(i_s),i_s)
title('ƥ���˲��鲿���')
figure
stem(1:length(re_psk),re_psk);
title('result')