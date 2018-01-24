function output=demodulation_s(input,fc,fs)
%����sin(2*pi*fc*t)
%input ����Ľ����ź�
%output ����ź�
N=length(input);%��Ԫ�ĸ���
y=zeros(N,1);
for i=1:N
    y(i)=input(i)*2*sin(2*pi*fc*i/fs);
end
% for i=1:N
%     x(i)=input(i)*cos(2*pi*fc*i/fs);
% end
% output=x+y;
[b,a]=butter(5,fc*2/fs);
output=filter(b,a,y);