function output=pam_8(input)
%input 输入信号
%output 输出信号
%星座图采用gray码
L=length(input)/3;
output=zeros(L,1);
k=3;
gray=[0,1,3,2,6,7,5,4]; %格雷码表
for i=1:L
    x=4*input(k*i-2)+2*input(k*i-1)+input(k*i);
    output(i)=find(gray==x)*2-1-8;
end
figure
plot(real(output),imag(output),'b.','Markersize',10);
title('8PAM星座图')