%%
%8PAM
clear,clc
N=1000002;%0,1����źŵĸ���
s=randi([0,1],N,1);%����4000������ź�
%%
%���ֵ���
pam_s=pam_8(s);
%%
%�����˲�
rolloff = 0.25;%����ϵ��
span = 8; %�˲������
sps = 40;%ÿ�����ŵĲ�������
b = rcosdesign(rolloff, span, sps); %�������˲���
x_pam = upfirdn(pam_s, b, sps); %�����˲�
%%
%���Ƶ���Ƶ
fc=1;
fs=10;
xpam_m=modulation_c(x_pam,fc,fs);
%%
%ͨ��AWGN�ŵ�
EbNo=40;
snr= EbNo + 10*log10(3) - 10*log10(sps);
% inoise=randn(length(xpam_m),1).*sqrt(0.5*sum(xpam_m.*xpam_m)/length(xpam_m)*10.^(-snr/10)); 
% r_pam=xpam_m+inoise;
r_pam=awgn(xpam_m,snr,'measured');
%%
% ���
rpam_d=demodulation_c(r_pam,fc,fs);
%%
%ƥ���˲�
match_p = upfirdn(rpam_d, b, 1, sps);
%%
%���ֽ��
re_pam=depam_8(match_p,span);
%%
%ͳ��������
ber=sum(abs(re_pam-s))/length(re_pam);
%%
%8PAM���
% figure
% stem(1:N,s)
% %title('ԭʼ�ź�����')
% xlabel('ʱ��')
% ylabel('����')
% figure
% stem(1:length(pam_s),pam_s)
% xlabel('ʱ��')
% ylabel('����')
% %title('8PAM���ƺ�ı���')
% figure
% plot(1:length(x_pam),x_pam)
% hold on
% plot(1:length(xpam_m),xpam_m)
% legend('�����˲�','���Ƶ��ز�')
% xlabel('ʱ��')
% ylabel('����')
figure
plot(1:length(xpam_m),abs(fft(xpam_m)));
%title('8PAM�����ź�Ƶ��')
% figure
% plot(1:length(r_pam),r_pam);
% xlabel('ʱ��')
% ylabel('����')
%title('�����ź�')
% figure
% plot(1:length(rpam_d),rpam_d);
% xlabel('ʱ��')
% ylabel('����')
% title('��������ź�')
% figure;
% stem(span+1:length(match_p)-span,match_p(span+1:length(match_p)-span))
% xlabel('ʱ��')
% ylabel('����')
%title('ƥ���˲����')
% figure
% subplot(2,1,1)
% stem(1:N,s)
% title('ԭʼ����')
% subplot(2,1,2)
% stem(1:length(re_pam),re_pam);
% xlabel('ʱ��')
% ylabel('����')
% title('�����о��������')
% title('result')
