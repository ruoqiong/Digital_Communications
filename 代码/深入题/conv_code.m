function output=conv_code(input)
%卷积码生成(2,2,3)
%input 编码器输入
%output 编码器输出
input=input';
data_len=length(input);
g=[1 0 1 1;
    1 1 0 1;
    1 0 1 0];
sk=[0,0,0,0];
seq_cov=zeros(data_len/4*3,3);
k=1;
for i=1:4:data_len%每4个bit为一组
    sk=[input(i:i+1),sk(1:2)];
    seq_cov(k,:)=g*sk';
    sk=[input(i+2:i+3),input(i:i+1)];
    seq_cov(k+1,:)=g*sk';
    sk=[[0 0],input(i+2:i+3)];%后接两个0，保证回到初始状态
    seq_cov(k+2,:)=g*sk';
    k=k+3;
end
seq=mod(reshape(seq_cov',1,[]),2);
output=seq';