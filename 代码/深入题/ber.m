%8PAM
clear,clc
N=1200000;%0,1随机信号的个数
s=randi([0,1],N,1);%产生4000个随机信号
s_s=conv_code(s);
subplot(2,1,1)
stem(1:length(s),s)
title('原始序列')
xlabel('时间')
ylabel('码字')
subplot(2,1,2)
stem(1:length(s_s),s_s)
xlabel('时间')
ylabel('码字')
title('卷积编码后的序列')
%%
%数字调制
[rpsk_s,ipsk_s]=psk_8(s_s);%分别输出实部虚部
%%
%成型滤波
rolloff = 0.25;%滚降系数
span = 8; %滤波器跨度
sps = 40;%每个符号的采样个数
b = rcosdesign(rolloff, span, sps); %升余弦滤波器
rx_psk = upfirdn(rpsk_s, b, sps); %实部成型滤波
ix_psk = upfirdn(ipsk_s, b, sps); %实部成型滤波
xpsk_m=rx_psk+1i*ix_psk;
%%
%信号通过awgn信道
i=1;
c=1;
for EbNo=0:3:24
    c
    c=c+1;
    snr= EbNo + 10*log10(3) - 10*log10(sps);
    rx=awgn(xpsk_m,snr,'measured');
    r_psk=real(rx);
    i_psk=imag(rx);
    %%
    %匹配滤波
    R_s=upfirdn(r_psk, b,1,sps);
    r_s=R_s(span+1:length(R_s)-span);
    I_s=upfirdn(i_psk, b,1,sps);
    i_s=I_s(span+1:length(I_s)-span);
    %数字解调
    re_psk=depsk_8(r_s,i_s);
    r_r=hard_decode(re_psk);
    ber_psk_n(i)=sum(abs(r_r-s))/length(r_r);
    i=i+1;
end
load('ber.mat')
EbNo=0:3:24;
semilogy(EbNo,ber_psk,'r-^',EbNo,ber_psk_n,'b-o',EbNo,ber_psk_r,'m-*')
grid on
legend('不使用卷积码的8PSK','使用卷积码维特比硬判决的8PSK','使用卷积码维特比软判决的8PSK')