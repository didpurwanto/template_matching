%%% 將x拆成前後兩部分
function [Nf Ef]=getNEfeatures(x)
s=size(x,1);
for i=1:s/2
    Nf(i)=x(i);
end
c=1;
for i=s/2+1:s
    Ef(c)=x(i);
    c=c+1;
end
Nf=Nf';
Ef=Ef';