function output=modulation_s(input,fc,fs)
%����sin(2*pi*fc*t)
%input ����Ļ����ź�
%output ����ź�
N=length(input);%��Ԫ�ĸ���
output=zeros(N,1);
for i=1:N
    output(i)=input(i)*sin(2*pi*fc*i/fs);
end
