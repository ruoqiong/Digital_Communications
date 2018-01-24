%8PAM
clear,clc
N=10000002;%0,1����źŵĸ���
s=randi([0,1],N,1);%����4000������ź�
%%
%���ֵ���
pam_s=pam_8(s);
[rpsk_s,ipsk_s]=psk_8(s);%�ֱ����ʵ���鲿
%%
%�����˲�
rolloff = 0.25;%����ϵ��
span = 8; %�˲������
sps = 40;%ÿ�����ŵĲ�������
b = rcosdesign(rolloff, span, sps); %�������˲���
x_pam = upfirdn(pam_s, b, sps); %�����˲�
rx_psk = upfirdn(rpsk_s, b, sps); %ʵ�������˲�
ix_psk = upfirdn(ipsk_s, b, sps); %ʵ�������˲�
xpsk_m=rx_psk+1i*ix_psk;
%%
%�ź�ͨ��awgn�ŵ�
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
    %ƥ���˲�
    match_p = upfirdn(r_pam, b, 1, sps);
    R_s=upfirdn(r_psk, b,1,sps);
    r_s=R_s(span+1:length(R_s)-span);
    I_s=upfirdn(i_psk, b,1,sps);
    i_s=I_s(span+1:length(I_s)-span);
    %���ֽ��
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