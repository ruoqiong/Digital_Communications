function output=depsk_8(r_s,i_s)
%r_s:实部
%i_s:虚部
figure
plot(r_s,i_s,'b.','Markersize',10)
title('8PSK接收星座图')
z=r_s+1i*i_s;
N=length(z);
k=3;
output=zeros(k*N,1);
y=zeros(N,1);
gray=[7,5,4,0,1,3,2,6]; %格雷码表
b1=[0 1 0 1 0 1 0 1];
b2=[0 0 1 1 0 0 1 1];
b3=[0 0 0 0 1 1 1 1];
for i=1:N
    p=round(4*angle(z(i))/pi)+4;
    if p==0
        p=8;
    end
    y(i)=gray(p);
    output(i*k-2)=b3(y(i)+1);
    output(i*k-1)=b2(y(i)+1);
    output(i*k)=b1(y(i)+1);
end