%8PAM
clear,clc
N=10000002;%0,1随机信号的个数
s=randi([0,1],N,1);%产生4000个随机信号
%%
%数字调制
pam_s=pam_8(s);
[rpsk_s,ipsk_s]=psk_8(s);%分别输出实部虚部
%%
%成型滤波
rolloff = 0.25;%滚降系数
span = 8; %滤波器跨度
sps = 40;%每个符号的采样个数
b = rcosdesign(rolloff, span, sps); %升余弦滤波器
x_pam = upfirdn(pam_s, b, sps); %成型滤波
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
    r_pam=awgn(x_pam,snr,'measured');
    rx=awgn(xpsk_m,snr,'measured');
    r_psk=real(rx);
    i_psk=imag(rx);
    %%
    %匹配滤波
    match_p = upfirdn(r_pam, b, 1, sps);
    R_s=upfirdn(r_psk, b,1,sps);
    r_s=R_s(span+1:length(R_s)-span);
    I_s=upfirdn(i_psk, b,1,sps);
    i_s=I_s(span+1:length(I_s)-span);
    %数字解调
    re_pam=depam_8(match_p,span);
    re_psk=depsk_8(r_s,i_s);
    ber_pam(i)=sum(abs(re_pam-s))/length(re_pam);
    ber_psk(i)=sum(abs(re_psk-s))/length(re_psk);
    i=i+1;
end
EbNo=0:3:24;
semilogy(EbNo,ber_pam,'r^-',EbNo,ber_psk,'b-o')
grid on
legend('8PAM','8PSK')
axis([0,24,inf,inf])