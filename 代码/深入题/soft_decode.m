function output=soft_decode(input)
%维特比软判决
%input 输入
%output 输出
decode=input';
data_len=length(decode);
decode_vit=reshape(decode,9,[]);
map=[0,0,0,0,;
     0,0,0,1;
     0,0,1,0;
     0,0,1,1;
     0,1,0,0;
     0,1,0,1;
     0,1,1,0;
     0,1,1,1;
     1,0,0,0;
     1,0,0,1;
     1,0,1,0;
     1,0,1,1;
     1,1,0,0;
     1,1,0,1;
     1,1,1,0;
     1,1,1,1];
for j=1:fix(data_len/9)
    cm(1)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 0 0 0 0 0 0 0 0])])*9;
    cm(2)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 0 0 0 1 0 1 1 0])])*9;
    cm(3)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 0 0 1 1 1 1 0 1])])*9;
    cm(4)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 0 0 1 0 1 0 1 1])])*9;
    cm(5)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 1 0 1 1 0 0 0 0])])*9;
    cm(6)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 1 0 1 0 0 1 1 0])])*9;
    cm(7)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 1 0 0 0 1 1 0 1])])*9;
    cm(8)=pdist([calc_rz(decode_vit(:,j));calc_rz([0 1 0 0 1 1 0 1 1])])*9;
    cm(9)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 1 1 1 0 1 0 0 0])])*9;
    cm(10)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 1 1 1 1 1 1 1 0])])*9;
    cm(11)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 1 1 0 1 0 1 0 1])])*9;
    cm(12)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 1 1 0 0 0 0 1 1])])*9;
    cm(13)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 0 1 0 1 1 0 0 0])])*9;
    cm(14)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 0 1 0 0 1 1 1 0])])*9;
    cm(15)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 0 1 1 0 0 1 0 1])])*9;
    cm(16)=pdist([calc_rz(decode_vit(:,j));calc_rz([1 0 1 1 1 0 0 1 1])])*9;
    [~,dec_soft(j)]=min(cm);
end
decode_r=zeros(1,data_len*4/9);
for i=1:data_len/9
    decode_r(1,4*i-3:4*i)=map(dec_soft(i),:);
end
output=decode_r';