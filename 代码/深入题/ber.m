%8PAM
clear,clc
N=1200000;%0,1����źŵĸ���
s=randi([0,1],N,1);%����4000������ź�
s_s=conv_code(s);
subplot(2,1,1)
stem(1:length(s),s)
title('ԭʼ����')
xlabel('ʱ��')
ylabel('����')
subplot(2,1,2)
stem(1:length(s_s),s_s)
xlabel('ʱ��')
ylabel('����')
title('�������������')
%%
%���ֵ���
[rpsk_s,ipsk_s]=psk_8(s_s);%�ֱ����ʵ���鲿
%%
%�����˲�
rolloff = 0.25;%����ϵ��
span = 8; %�˲������
sps = 40;%ÿ�����ŵĲ�������
b = rcosdesign(rolloff, span, sps); %�������˲���
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
    rx=awgn(xpsk_m,snr,'measured');
    r_psk=real(rx);
    i_psk=imag(rx);
    %%
    %ƥ���˲�
    R_s=upfirdn(r_psk, b,1,sps);
    r_s=R_s(span+1:length(R_s)-span);
    I_s=upfirdn(i_psk, b,1,sps);
    i_s=I_s(span+1:length(I_s)-span);
    %���ֽ��
    re_psk=depsk_8(r_s,i_s);
    r_r=hard_decode(re_psk);
    ber_psk_n(i)=sum(abs(r_r-s))/length(r_r);
    i=i+1;
end
load('ber.mat')
EbNo=0:3:24;
semilogy(EbNo,ber_psk,'r-^',EbNo,ber_psk_n,'b-o',EbNo,ber_psk_r,'m-*')
grid on
legend('��ʹ�þ�����8PSK','ʹ�þ����ά�ر�Ӳ�о���8PSK','ʹ�þ����ά�ر����о���8PSK')