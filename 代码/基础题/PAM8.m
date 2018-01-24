%%
%8PAM
clear,clc
N=1000002;%0,1随机信号的个数
s=randi([0,1],N,1);%产生4000个随机信号
%%
%数字调制
pam_s=pam_8(s);
%%
%成型滤波
rolloff = 0.25;%滚降系数
span = 8; %滤波器跨度
sps = 40;%每个符号的采样个数
b = rcosdesign(rolloff, span, sps); %升余弦滤波器
x_pam = upfirdn(pam_s, b, sps); %成型滤波
%%
%调制到载频
fc=1;
fs=10;
xpam_m=modulation_c(x_pam,fc,fs);
%%
%通过AWGN信道
EbNo=40;
snr= EbNo + 10*log10(3) - 10*log10(sps);
% inoise=randn(length(xpam_m),1).*sqrt(0.5*sum(xpam_m.*xpam_m)/length(xpam_m)*10.^(-snr/10)); 
% r_pam=xpam_m+inoise;
r_pam=awgn(xpam_m,snr,'measured');
%%
% 解调
rpam_d=demodulation_c(r_pam,fc,fs);
%%
%匹配滤波
match_p = upfirdn(rpam_d, b, 1, sps);
%%
%数字解调
re_pam=depam_8(match_p,span);
%%
%统计误码率
ber=sum(abs(re_pam-s))/length(re_pam);
%%
%8PAM结果
% figure
% stem(1:N,s)
% %title('原始信号序列')
% xlabel('时间')
% ylabel('码字')
% figure
% stem(1:length(pam_s),pam_s)
% xlabel('时间')
% ylabel('幅度')
% %title('8PAM调制后的编码')
% figure
% plot(1:length(x_pam),x_pam)
% hold on
% plot(1:length(xpam_m),xpam_m)
% legend('成形滤波','调制到载波')
% xlabel('时间')
% ylabel('幅度')
figure
plot(1:length(xpam_m),abs(fft(xpam_m)));
%title('8PAM发送信号频谱')
% figure
% plot(1:length(r_pam),r_pam);
% xlabel('时间')
% ylabel('幅度')
%title('接收信号')
% figure
% plot(1:length(rpam_d),rpam_d);
% xlabel('时间')
% ylabel('幅度')
% title('解调出的信号')
% figure;
% stem(span+1:length(match_p)-span,match_p(span+1:length(match_p)-span))
% xlabel('时间')
% ylabel('幅度')
%title('匹配滤波输出')
% figure
% subplot(2,1,1)
% stem(1:N,s)
% title('原始序列')
% subplot(2,1,2)
% stem(1:length(re_pam),re_pam);
% xlabel('时间')
% ylabel('码字')
% title('抽样判决后的序列')
% title('result')
