function [knnindex,rbfdis,knn_sim]=knn(Cobj,CtextN,sigma)
%% obj-text distance (KNN result)
[c2,~]=size(CtextN);
objsize=size(CtextN,1);
tsize=objsize;
k=1;
knum=c2; %knn k number
textvote=zeros(knum*objsize,2);
indexvote=zeros(knum*objsize,1);
for i=1:objsize
    for j=1:tsize
        R(j,1)=sqrt((Cobj(i,1)-CtextN(j,1))^2+(Cobj(i,2)-CtextN(j,2))^2); %distance
    end
    [~,index]=sort(R);
    for x=1:knum % last min k distance
        textvote(k,:)=CtextN(index(x,1),:);
        indexvote(k,:)=index(x,1);
        k=k+1;
    end
end
%arrange the knn index
I=1;
tn=tsize;
for j=1:tsize
    t=1;
    for i=((tn*I)-tn)+1:tn*I
        knnindex(j,t)=indexvote(i,1);
        t=t+1;
    end
    I=I+1;
end

c3=1;
[objnum,~]=size(Cobj);Rfn=[];
for i=1:objnum
    for j=((knum*c3)-knum)+1:knum*c3
        Rfn(j,1)=abs(sqrt((Cobj(i,1)-textvote(j,1))^2+(Cobj(i,2)-textvote(j,2))^2)); %distance
    end
    c3=c3+1;
end
a=[];
for i=1:objnum
     [~,indexNode]=sort(Rfn(((knum*i)-knum)+1:knum*i));
     a=[a;indexNode];
end
t=1;
for i=1:objnum
    for j=((knum*i)-knum)+1:knum*i
    b(t)=a(j)+(knum*(i-1));
    t=t+1;
    end
end
b=b';
for i=1:knum*objnum
    textNode(i,:)=textvote(b(i),:);
end
[v,~]=size(textNode);
% compute obj-text distance(one obj to knum texts)
cc=1;
[objnum,~]=size(Cobj);
for i=1:objnum
    for j=((knum*cc)-knum)+1:knum*cc
        dFN(j,1)=sqrt((Cobj(i,1)-textNode(j,1))^2+(Cobj(i,2)-textNode(j,2))^2);
        Xr(j,1)=textNode(j,1)-Cobj(i,1);
        Yr(j,1)=textNode(j,2)-Cobj(i,2);
    end
    cc=cc+1;
end
XYr=[Xr Yr];
r=0;
distance=zeros(objnum,knum);
for j=1:objnum
    r=r+1;
    n=1;
    for i=((knum*r)-knum)+1:knum*r
        distance(j,n)=dFN(i,1);
        n=n+1;
    end
end
% [FNsize,~]=size(dFN);
dFN=abs(dFN);
% sigma=10;
for i=1:objnum
    thr(i)=min(distance(i,:))-(0.01*min(distance(i,:)));
end
r=1;
for i=1:objnum
    for j=((knum*r)-knum)+1:knum*r
        rbfdis(j)=exp(-abs(dFN(j)-thr(i))/(2*sigma^2));
    end
    r=r+1;
end
rbfdis=rbfdis';
c2=1;
on=objnum;
knn_sim=zeros(objnum,on);
for j=1:objnum
    t=1;
    for i=((on*c2)-on)+1:on*c2
        knn_sim(j,t)=rbfdis(i,1);
        t=t+1;
    end
    c2=c2+1;
end
end