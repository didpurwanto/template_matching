function [vote]=positionvote(picnum)
% picnum=26;
sf=sprintf('./Detection/obj%d.txt',picnum);
st=sprintf('./Detection/text%d.txt',picnum);
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
pic=sprintf('./dataset/%d.jpg',picnum);
a=imread(pic);
% imshow(a)
Cobj=[];Ctext=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
%center of text
Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);
CtextN=[];knnindex=[];knn_sim=[];
CtextN=Ctext;
K=1;
% [IDX,C] = kmeans(Cobj,K);
[sizeY,sizeX,~]=size(a);
C(1,1)=0.5*sizeX;
C(1,2)=0.5*sizeY;

%% Obj
%calculate angles
r=0;x=1;
angle=zeros(objnum,1);
for j=1
    r=r+1;
    for i=1:objnum
        A=C(j,1)-Cobj(i,1);
        B=C(j,2)-Cobj(i,2);
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
deg=45;
for i=1:objnum
        if(angle(i,1)>0 && angle(i,1)<=45)
            ra(i,1)=1;
        end
        if(angle(i,1)>45 && angle(i,1)<=90)
            ra(i,1)=2;
        end
        if(angle(i,1)>90 && angle(i,1)<=135)
            ra(i,1)=3;
        end
        if(angle(i,1)>135 && angle(i,1)<=180)
            ra(i,1)=4;
        end
        if(angle(i,1)>180 && angle(i,1)<=225)
            ra(i,1)=5;
        end
        if(angle(i,1)>225 && angle(i,1)<=270)
            ra(i,1)=6;
        end
        if(angle(i,1)>270 && angle(i,1)<=315)
            ra(i,1)=7;
        end
        if(angle(i,1)>315 && angle(i,1)<=360)
            ra(i,1)=8;
        end
end
% vote
v=zeros(1,8);
ra=ra';
for i=1
    numb=1;
for x=1:8
    for j=1:objnum
        if ra(i,j)==numb
            t=numb;
            v(i,t)=v(i,t)+1;
        end
    end
    numb=numb+1;
end
end

%% Words
%calculate angles
r=0;x=1;
angleT=zeros(textnum,1);
for j=1
    r=r+1;
    for i=1:textnum
        A=C(j,1)-Ctext(i,1);
        B=C(j,2)-Ctext(i,2);
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
deg=45;
for i=1:objnum
        if(angleT(i,1)>0 && angleT(i,1)<=45)
            raT(i,1)=1;
        end
        if(angleT(i,1)>45 && angleT(i,1)<=90)
            raT(i,1)=2;
        end
        if(angleT(i,1)>90 && angleT(i,1)<=135)
            raT(i,1)=3;
        end
        if(angleT(i,1)>135 && angleT(i,1)<=180)
            raT(i,1)=4;
        end
        if(angleT(i,1)>180 && angleT(i,1)<=225)
            raT(i,1)=5;
        end
        if(angleT(i,1)>225 && angleT(i,1)<=270)
            raT(i,1)=6;
        end
        if(angleT(i,1)>270 && angleT(i,1)<=315)
            raT(i,1)=7;
        end
        if(angleT(i,1)>315 && angleT(i,1)<=360)
            raT(i,1)=8;
        end
end
% vote
vT=zeros(1,8);
raT=raT';
for i=1
    numb=1;
for x=1:8
    for j=1:objnum
        if raT(i,j)==numb
            t=numb;
            vT(i,t)=vT(i,t)+1;
        end
    end
    numb=numb+1;
end
end
vote=[v vT];
end