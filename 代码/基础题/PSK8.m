%%
%8PSK
clear,clc
N=120;%0,1随机信号的个数
s=randi([0,1],N,1);%产生4000个随机信号
%%
%数字调制
[rpsk_s,ipsk_s]=psk_8(s);%分别输出实部虚部
%%
%成型滤波
rolloff = 0.25;%滚降系数
span = 8; %滤波器跨度
sps = 40;%每个符号的采样个数
b = rcosdesign(rolloff, span, sps); %升余弦滤波器
rx_psk = upfirdn(rpsk_s, b, sps); %实部成型滤波
ix_psk = upfirdn(ipsk_s, b, sps); %实部成型滤波
%%
%调制到载频
fc=1;
fs=10;
rxpsk_m=modulation_c(rx_psk,fc,fs);
ixpsk_m=modulation_s(ix_psk,fc,fs);
xpsk_m=rxpsk_m+ixpsk_m;
%%
%信号通过awgn信道
EbNo=20;
snr= EbNo + 10*log10(3) - 10*log10(sps);
rx=awgn(xpsk_m,snr,'measured');
%%
%接收信号解调
r_psk=demodulation_c(rx,fc,fs);
i_psk=demodulation_s(rx,fc,fs);
%%
%匹配滤波
R_s=upfirdn(r_psk, b,1,sps);
r_s=R_s(span+1:length(R_s)-span);
I_s=upfirdn(i_psk, b,1,sps);
i_s=I_s(span+1:length(I_s)-span);
%%
%判决
re_psk=depsk_8(r_s,i_s);
%%
%统计误码率
ber=sum(abs(re_psk-s))/length(re_psk);
%%
% 8PSK结果
figure
stem(1:N,s)
title('原始信号序列')
figure
stem(1:length(rpsk_s),rpsk_s)
title('8PSK的实部')
figure
plot(1:length(rx_psk),rx_psk)
title('实部成形滤波')
figure
plot(1:length(rxpsk_m),rxpsk_m)
title('实部调制到载波')
figure
stem(1:length(ipsk_s),ipsk_s)
title('8PSK的虚部')
figure
plot(1:length(ix_psk),ix_psk)
title('虚部成形滤波')
figure
plot(1:length(ixpsk_m),ixpsk_m)
title('虚部调制到载波')
figure
plot(1:length(xpsk_m),xpsk_m);
title('8PSK发送信号')
figure
plot(1:length(xpsk_m),abs(fft(xpsk_m)));
title('8PSK发送信号频谱')
figure
subplot(2,1,1)
plot(1:length(r_psk),r_psk)
title('实部信号解调')
subplot(2,1,2)
plot(1:length(i_psk),i_psk)
title('虚部信号解调')
figure
subplot(2,1,1)
stem(1:length(r_s),r_s)
title('匹配滤波实部输出')
subplot(2,1,2)
stem(1:length(i_s),i_s)
title('匹配滤波虚部输出')
figure
stem(1:length(re_psk),re_psk);
title('result')