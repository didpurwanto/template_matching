function [T]=Otsu(height)
%%--denoise---
[~,sizeH]=size(height);
x=1;
for i=1:sizeH
    if height(i)>=20 && height(i)<=500
        Seq(x)=height(i);
        x=x+1;
    end
end
N=max(Seq);
nbins = N; 
[x,h] = hist(Seq(:),nbins);
% calculate probabilities
p = x./sum(x);
% initialisation
om1 = 0; 
om2 = 1; 
mu1 = 0; 
mu2 = mode(height(:));
for t = 1:nbins,
    om1(t) = sum(p(1:t));
    om2(t) = sum(p(t+1:nbins));
    mu1(t) = sum(p(1:t).*[1:t])./om1(t);
    mu2(t) = sum(p(t+1:nbins).*[t+1:nbins])./om2(t);
end
 sigma=om1.*om2.*((mu1- mu2).^2);
 idx = find(sigma == max(sigma));
 tolerance=15;


 T=fix((max(h(idx))+min(h(idx)))/2);
 
%  if T-70 > 10
%     T=T-tolerance;
%  else if T-70 < -10
%          T=T+tolerance;
%      end
%  end
 
T=70; 
% %  %%--Threshold-----
%  T = h(id);
end

