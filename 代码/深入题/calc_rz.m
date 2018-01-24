function output=calc_rz(input)
N=length(input);
k=3;
for i=1:N/3
    output(i)=4*input(k*i-2)+2*input(k*i-1)+input(k*i);
end