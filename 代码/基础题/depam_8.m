function output=depam_8(input,span)
%input 输入信号
%output 输出信号
%星座图采用gray码
figure
plot(input,zeros(1,length(input)),'b.','Markersize',10)
title('8PAM接收星座图')
L=length(input)-2*span; %输入序列有用长度
Input=input(1+span:L+span);
y=zeros(L,1);
k=3;
gray=[0,1,3,2,6,7,5,4]; %格雷码表
b1=[0 1 0 1 0 1 0 1];
b2=[0 0 1 1 0 0 1 1];
b3=[0 0 0 0 1 1 1 1];
output=zeros(L*k,1);
for i=1:L
    N=ceil(Input(i)/2)+4;
    if N>8
        N=8;
    end
    if N<1
        N=1;
    end
    y(i)=gray(N);
    output(i*k-2)=b3(y(i)+1);
    output(i*k-1)=b2(y(i)+1);
    output(i*k)=b1(y(i)+1);
end