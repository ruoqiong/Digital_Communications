close all
clear
clc
nbitpersym  = 100;   % OFDM���Ŷ�Ӧ������
nsym        = 5*10^4*10; % ��������
len_fft     = 128;   % fft�任���С

sub_car     = 100;   % ���ز�����

EbNo        = 0:2:12;
EsNo= EbNo + 10*log10(100/128)+ 10*log10(100/160); 
snr= EsNo - 10*log10(128/160); 
% ����0��1����
t_data=randi([0,1],nbitpersym*nsym,1);
% 2psk����
M = modem.pskmod(2); 
mod_data = modulate(M,t_data);
% ����ת��
par_data = reshape(mod_data,nbitpersym,nsym).';
% ���뵼Ƶ
pilot_ins_data=[zeros(nsym,14) par_data(:,[1:nbitpersym/2]) zeros(nsym,1) par_data(:,[nbitpersym/2+1:nbitpersym]) zeros(nsym,13)] ;
% IFFT�任
IFFT_data = (128/sqrt(100))*ifft(fftshift(pilot_ins_data.')).';
IFFT_data_2 = (128/sqrt(100))*ifft(fftshift(par_data.')).';
% ����ѭ��ǰ׺
cylic_add_data = [IFFT_data(:,[97:128]) IFFT_data].';
% ����ת��
ser_data = reshape(cylic_add_data,160*nsym,1);
% ͨ��3�������ŵ�
d=[1e-4 3e-4 5e-4]; a=[0.3 0.4 0.5];
h=rayleighchan(1/1000,0,d,a);

changain1=filter(h,ones(nsym*160,1));
a=max(max(abs(changain1)));
changain1=changain1./a;

chan_data = changain1.*ser_data;
no_of_error=[];
ratio=[];

%���ݲ�ͬ������ȣ�������ղ������������BER
for ii=1:length(snr)
    
% ͨ��awgn�ŵ�
chan_awgn = awgn(chan_data,snr(ii),'measured'); 
% �����ŵ�����
chan_awgn =a* chan_awgn./changain1; 
% ����ת��
ser_to_para = reshape(chan_awgn,160,nsym).'; 
% ȥ��ѭ��ǰ׺
cyclic_pre_rem = ser_to_para(:,[33:160]);   
% FFT�任
FFT_recdata =(sqrt(100)/128)*fftshift(fft(cyclic_pre_rem.')).';    
% ȥ����Ƶ
rem_pilot = FFT_recdata (:,[14+[1:nbitpersym/2] 15+[nbitpersym/2+1:nbitpersym] ]); 
% ����ת��
ser_data_1 = reshape(rem_pilot.',nbitpersym*nsym,1);  
% 2PSK����
z=modem.pskdemod(2); 
demod_Data = demodulate(z,ser_data_1);  
% �����������
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

