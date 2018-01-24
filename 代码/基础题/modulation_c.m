function output=modulation_c(input,fc,fs)
%乘上cos(2*pi*fc*t)
%input 输入的基带信号
%output 输出信号
N=length(input);%码元的个数
output=zeros(N,1);
for i=1:N
    output(i)=input(i)*cos(2*pi*fc*i/fs);
end
