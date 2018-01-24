function output=hard_decode(input)
%维特比硬判决 
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
    hm(1)=pdist([decode_vit(:,j)';0 0 0 0 0 0 0 0 0],'hamming')*9;
    hm(2)=pdist([decode_vit(:,j)';0 0 0 0 1 0 1 1 0],'hamming')*9;
    hm(3)=pdist([decode_vit(:,j)';0 0 0 1 1 1 1 0 1],'hamming')*9;
    hm(4)=pdist([decode_vit(:,j)';0 0 0 1 0 1 0 1 1],'hamming')*9;
    hm(5)=pdist([decode_vit(:,j)';0 1 0 1 1 0 0 0 0],'hamming')*9;
    hm(6)=pdist([decode_vit(:,j)';0 1 0 1 0 0 1 1 0],'hamming')*9;
    hm(7)=pdist([decode_vit(:,j)';0 1 0 0 0 1 1 0 1],'hamming')*9;
    hm(8)=pdist([decode_vit(:,j)';0 1 0 0 1 1 0 1 1],'hamming')*9;
    hm(9)=pdist([decode_vit(:,j)';1 1 1 1 0 1 0 0 0],'hamming')*9;
    hm(10)=pdist([decode_vit(:,j)';1 1 1 1 1 1 1 1 0],'hamming')*9;
    hm(11)=pdist([decode_vit(:,j)';1 1 1 0 1 0 1 0 1],'hamming')*9;
    hm(12)=pdist([decode_vit(:,j)';1 1 1 0 0 0 0 1 1],'hamming')*9;
    hm(13)=pdist([decode_vit(:,j)';1 0 1 0 1 1 0 0 0],'hamming')*9;
    hm(14)=pdist([decode_vit(:,j)';1 0 1 0 0 1 1 1 0],'hamming')*9;
    hm(15)=pdist([decode_vit(:,j)';1 0 1 1 0 0 1 0 1],'hamming')*9;
    hm(16)=pdist([decode_vit(:,j)';1 0 1 1 1 0 0 1 1],'hamming')*9;
    [~,dec_hard(j)]=min(hm);
end
decode_r=zeros(1,data_len*4/9);
for i=1:data_len/9
    decode_r(1,4*i-3:4*i)=map(dec_hard(i),:);
end
output=decode_r';
