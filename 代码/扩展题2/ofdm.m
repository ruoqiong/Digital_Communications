close all
clear
clc
nbitpersym  = 100;   % OFDM符号对应比特数
nsym        = 5*10^4*10; % 符号速率
len_fft     = 128;   % fft变换块大小

sub_car     = 100;   % 子载波个数

EbNo        = 0:2:12;
EsNo= EbNo + 10*log10(100/128)+ 10*log10(100/160); 
snr= EsNo - 10*log10(128/160); 
% 生成0、1序列
t_data=randi([0,1],nbitpersym*nsym,1);
% 2psk调制
M = modem.pskmod(2); 
mod_data = modulate(M,t_data);
% 串并转换
par_data = reshape(mod_data,nbitpersym,nsym).';
% 插入导频
pilot_ins_data=[zeros(nsym,14) par_data(:,[1:nbitpersym/2]) zeros(nsym,1) par_data(:,[nbitpersym/2+1:nbitpersym]) zeros(nsym,13)] ;
% IFFT变换
IFFT_data = (128/sqrt(100))*ifft(fftshift(pilot_ins_data.')).';
IFFT_data_2 = (128/sqrt(100))*ifft(fftshift(par_data.')).';
% 加入循环前缀
cylic_add_data = [IFFT_data(:,[97:128]) IFFT_data].';
% 并串转换
ser_data = reshape(cylic_add_data,160*nsym,1);
% 通过3径瑞利信道
d=[1e-4 3e-4 5e-4]; a=[0.3 0.4 0.5];
h=rayleighchan(1/1000,0,d,a);

changain1=filter(h,ones(nsym*160,1));
a=max(max(abs(changain1)));
changain1=changain1./a;

chan_data = changain1.*ser_data;
no_of_error=[];
ratio=[];

%根据不同的信噪比，解调接收并计算误比特率BER
for ii=1:length(snr)
    
% 通过awgn信道
chan_awgn = awgn(chan_data,snr(ii),'measured'); 
% 理想信道估计
chan_awgn =a* chan_awgn./changain1; 
% 串并转换
ser_to_para = reshape(chan_awgn,160,nsym).'; 
% 去除循环前缀
cyclic_pre_rem = ser_to_para(:,[33:160]);   
% FFT变换
FFT_recdata =(sqrt(100)/128)*fftshift(fft(cyclic_pre_rem.')).';    
% 去除导频
rem_pilot = FFT_recdata (:,[14+[1:nbitpersym/2] 15+[nbitpersym/2+1:nbitpersym] ]); 
% 并串转换
ser_data_1 = reshape(rem_pilot.',nbitpersym*nsym,1);  
% 2PSK调制
z=modem.pskdemod(2); 
demod_Data = demodulate(z,ser_data_1);  
% 计算误比特率
[no_of_error(ii),ratio(ii)]=biterr(t_data,demod_Data) ; 

end

semilogy(EbNo,ratio,'b-o');
hold on;


EbN0Lin = 10.^(EbNo/10);
theoryBer = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));
semilogy(EbNo,theoryBer,'r-^');
legend('simulated','theoritical')
grid on

xlabel('EbNo');
ylabel('BER')
title('Bit error probability curve for BPSK using OFDM');

