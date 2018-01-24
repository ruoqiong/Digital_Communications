function [r,l]=psk_8(input)
%input �����ź�
%r ����źŵ�ʵ��
%l ����źŵ��鲿
%����ͼ����gray��
L=length(input)/3;
r=zeros(L,1);
l=zeros(L,1);
k=3;
gray=[0,1,3,2,6,7,5,4]; %�������
for i=1:L
    x=4*input(k*i-2)+2*input(k*i-1)+input(k*i);
    a=(find(gray==x)-1)*2*pi/8; %��λ��
    r(i)=7*cos(a);
    l(i)=7*sin(a);
end
figure
plot(r,l,'b.','Markersize',10)
title('8PSK����ͼ')