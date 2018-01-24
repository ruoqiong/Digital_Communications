function output=pam_8(input)
%input �����ź�
%output ����ź�
%����ͼ����gray��
L=length(input)/3;
output=zeros(L,1);
k=3;
gray=[0,1,3,2,6,7,5,4]; %�������
for i=1:L
    x=4*input(k*i-2)+2*input(k*i-1)+input(k*i);
    output(i)=find(gray==x)*2-1-8;
end
figure
plot(real(output),imag(output),'b.','Markersize',10);
title('8PAM����ͼ')