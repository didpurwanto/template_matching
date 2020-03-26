function [shape_sim]=shape(Cobj,CtextN,sigma)
% shape context
% object------------------------------------------------
% angle 0~360 right-up-left-down
% angle(x,1)=mod((360+atand(((textNode(i,2)-Cobj(j,2)))/(textNode(i,1)-Cobj(j,1)))),360);
objnum=size(Cobj,1);
tsize=size(CtextN,1);
r=0;x=1;
[c2,~]=size(CtextN);
loop=c2-1;
angle=zeros(objnum*(objnum-1),1);
for j=1:objnum
    r=r+1;
    for i=1:objnum
        if i~=j
        A=Cobj(j,1)-Cobj(i,1);
        B=Cobj(j,2)-Cobj(i,2);
        if A>0 && B>0
            angle(x,1)=90+atand(A/B);
            x=x+1;
        else if A<0 && B>0
                angle(x,1)=90+atand(A/B);
                x=x+1;
            else if A<0 && B<0
                    angle(x,1)=270+atand(A/B);
                    x=x+1;
                else if A>0 && B<0
                        angle(x,1)=270+atand(A/B);
                        x=x+1;
                    else if A>0 && B==0
                            angle(x,1)=0;
                            x=x+1;
                        else if A<0 && B==0
                                angle(x,1)=180;
                                x=x+1;
                            else if A==0 && B>0
                                    angle(x,1)=90;
                                    x=x+1;
                                else if A==0 && B<0
                                        angle(x,1)=270;
                                        x=x+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        end
    end
end
%arrange angles
c2=1;
on=objnum-1;
ang=zeros(objnum,on);
for j=1:objnum
    t=1;
    for i=((on*c2)-on)+1:on*c2
        ang(j,t)=angle(i,1);
        t=t+1;
    end
    c2=c2+1;
end
%% Text
% %angT=angles between texts and texts

% angle 0~360 right-up-left-down
% angle(x,1)=mod((360+atand(((textNode(i,2)-Cobj(j,2)))/(textNode(i,1)-Cobj(j,1)))),360);
r=0;x=1;
angleT=zeros(tsize*(tsize-1),1);
for j=1:tsize
    r=r+1;
    for i=1:tsize
        if i~=j
        A=CtextN(j,1)-CtextN(i,1);
        B=CtextN(j,2)-CtextN(i,2);
        if A>0 && B>0
            angleT(x,1)=90+atand(A/B);
            x=x+1;
        else if A<0 && B>0
                angleT(x,1)=90+atand(A/B);
                x=x+1;
            else if A<0 && B<0
                    angleT(x,1)=270+atand(A/B);
                    x=x+1;
                else if A>0 && B<0
                        angleT(x,1)=270+atand(A/B);
                        x=x+1;
                    else if A>0 && B==0
                            angleT(x,1)=0;
                            x=x+1;
                        else if A<0 && B==0
                                angleT(x,1)=180;
                                x=x+1;
                            else if A==0 && B>0
                                    angleT(x,1)=90;
                                    x=x+1;
                                else if A==0 && B<0
                                        angleT(x,1)=270;
                                        x=x+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        end
    end
end

%arrange angles
C2=1;
tn=tsize-1;
angT=zeros(tsize,tn);
for j=1:tsize
    t=1;
    for i=((tn*C2)-tn)+1:tn*C2
        angT(j,t)=angleT(i,1);
        t=t+1;
    end
    C2=C2+1;
end
for i=1:tsize
    for j=1:tsize-1
        if ang(i,j)>=345 && ang(i,j)<=360
            ang(i,j)=0;
        end
        if angT(i,j)>=350 && angT(i,j)<=360
            angT(i,j)=0;
        end
    end
end
%% obj-text distance 
[c2,~]=size(CtextN);
k=1;
knum=c2; %knn k number
objsize=size(Cobj,1);
textvote=zeros(knum*objsize,2);
indexvote=zeros(knum*objsize,1);
R=zeros(tsize,1);
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

%% matching
sang=[];
sangT=[];
for i=1:objnum
    sang(i,:)=sort(ang(i,:));
    sangT(i,:)=sort(angT(i,:));
end
m=1;
% sigma=10;
D=zeros(objnum,tsize);
for i=1:objnum
    for j=1:tsize
        x(j,1:objnum-1)=abs(sang(i,:)-sangT(knnindex(i,j),:));
        D(i,j)=sum(x(j,:));
    end  
end

thr=[];
for i=1:objnum
    thr(i)=min(D(i,:))-(0.01*min(D(i,:)));
end
r=1;
shape_sim=zeros(objnum,tsize);
for i=1:objnum
    for j=1:objnum
        shape_sim(i,j)=exp(-abs(D(i,j)-thr(i))/(2*sigma^2));
    end
    r=r+1;
end

end