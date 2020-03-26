function [vote]=shapecontext(picnum)
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
[sizeY,sizeX,~]=size(a);
blocksizeX=sizeX/4;
blocksizeY=sizeY/4;
% define origin point of shape context
shape_orgpt=zeros(9,2);
shape_orgpt(1,1)=blocksizeX;shape_orgpt(1,2)=blocksizeY;
shape_orgpt(2,1)=blocksizeX*2;shape_orgpt(2,2)=blocksizeY;
shape_orgpt(3,1)=blocksizeX*3;shape_orgpt(3,2)=blocksizeY;
shape_orgpt(4,1)=blocksizeX;shape_orgpt(4,2)=blocksizeY*2;
shape_orgpt(5,1)=blocksizeX*2;shape_orgpt(5,2)=blocksizeY*2;
shape_orgpt(6,1)=blocksizeX*3;shape_orgpt(6,2)=blocksizeY*2;
shape_orgpt(7,1)=blocksizeX;shape_orgpt(7,2)=blocksizeY*3;
shape_orgpt(8,1)=blocksizeX*2;shape_orgpt(8,2)=blocksizeY*3;
shape_orgpt(9,1)=blocksizeX*3;shape_orgpt(9,2)=blocksizeY*3;
%-------------- build features------------------ 
%ang=angles between objs and objs
[objsize,~]=size(objdata);
[tsize,~]=size(textdata);
Cobj=[];Ctext=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
%center of text
Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);
CtextN=[];knnindex=[];knn_sim=[];
CtextN=Ctext;
%% Obj
%relative position between point 1~9 and objposition
k=1;
c=0; % number of relative position
for i=1:9
    for j=1:objnum
        position(k,:)=shape_orgpt(i,:)-Cobj(j,:);
        k=k+1;
        c=c+1;
    end
end
%calculate distance
for i=1:c
    distance(i,1)=sqrt((position(i,1)^2)+(position(i,2)^2));
end
%asign distances for 9 points
c1=1;
for j=1:9
    t=1;
    for i=((objnum*c1)-objnum)+1:objnum*c1
        dis(j,t)=distance(i,1);
        t=t+1;
    end
    c1=c1+1;
end
%calculate angles
r=0;x=1;
angle=zeros(objnum*(objnum-1),1);
for j=1:9
    r=r+1;
    for i=1:objnum
        A=shape_orgpt(j,1)-Cobj(i,1);
        B=shape_orgpt(j,2)-Cobj(i,2);
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
%asign angles for 9 points
c2=1;
for j=1:9
    t=1;
    for i=((objnum*c2)-objnum)+1:objnum*c2
        ang(j,t)=angle(i,1);
        t=t+1;
    end
    c2=c2+1;
end
% vote (8*8=64 bins)
% define angle=45 degree
% define r=100~800
deg=45;
for i=1:9
    for j=1:objnum
        if(ang(i,j)>0 && ang(i,j)<=45)
            ra(i,j)=1;
        end
        if(ang(i,j)>45 && ang(i,j)<=90)
            ra(i,j)=2;
        end
        if(ang(i,j)>90 && ang(i,j)<=135)
            ra(i,j)=3;
        end
        if(ang(i,j)>135 && ang(i,j)<=180)
            ra(i,j)=4;
        end
        if(ang(i,j)>180 && ang(i,j)<=225)
            ra(i,j)=5;
        end
        if(ang(i,j)>225 && ang(i,j)<=270)
            ra(i,j)=6;
        end
        if(ang(i,j)>270 && ang(i,j)<=315)
            ra(i,j)=7;
        end
        if(ang(i,j)>315 && ang(i,j)<=360)
            ra(i,j)=8;
        end
    end
end
for i=1:9
    for j=1:objnum
        if(dis(i,j)<=100)
            rd(i,j)=1;
        end
        if(dis(i,j)>100 && dis(i,j)<=250)
            rd(i,j)=2;
        end
        if(dis(i,j)>250 && dis(i,j)<=400)
            rd(i,j)=3;
        end
        if(dis(i,j)>400 && dis(i,j)<=550)
            rd(i,j)=4;
        end
        if(dis(i,j)>550 && dis(i,j)<=700)
            rd(i,j)=5;
        end
        if(dis(i,j)>700 && dis(i,j)<=850)
            rd(i,j)=6;
        end
        if(dis(i,j)>850 && dis(i,j)<=1000)
            rd(i,j)=7;
        end
        if(dis(i,j)>1000 && dis(i,j)<=10000)
            rd(i,j)=8;
        end
    end
end
% determine the area of shape context
% 8->360/45
for i=1:9
    for j=1:objnum
        bin(i,j)=((8*(rd(i,j)-1))+rd(i,j))+ra(i,j);
    end
end
% vote
v=zeros(9,64);
for i=1:9
    numb=1;
for x=1:64
    for j=1:objnum
        if bin(i,j)==numb
            t=numb;
            v(i,t)=v(i,t)+1;
        end
    end
    numb=numb+1;
end
end
% cascade face
c3=1;
for i=1:9
    for j=1:64
        vote(1,c3)=v(i,j);
        c3=c3+1;
    end
end
%% Text
%relative position between point 1~9 and faceposition
K=1;
C=0; % number of relative position
for i=1:9
    for j=1:textnum
        positionT(K,:)=shape_orgpt(i,:)-Ctext(j,:);
        K=K+1;
        C=C+1;
    end
end
%calculate distance
for i=1:C
    distanceT(i,1)=sqrt((positionT(i,1)^2)+(positionT(i,2)^2));
end
%asign distances for 9 points
C1=1;
for j=1:9
    t=1;
    for i=((textnum*C1)-textnum)+1:textnum*C1
        disT(j,t)=distanceT(i,1);
        t=t+1;
    end
    C1=C1+1;
end
%calculate angles
r=0;x=1;
angleT=zeros(objnum*(objnum-1),1);
for j=1:9
    r=r+1;
    for i=1:objnum
        A=shape_orgpt(j,1)-Cobj(i,1);
        B=shape_orgpt(j,2)-Cobj(i,2);
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
%asign angles for 9 points
C2=1;
for j=1:9
    t=1;
    for i=((textnum*C2)-textnum)+1:textnum*C2
        angT(j,t)=angleT(i,1);
        t=t+1;
    end
    C2=C2+1;
end
% vote (8*8=64 bins)
% define angle=45 degree
% define r=100~800
deg=45;
for i=1:9
    for j=1:textnum
        if(angT(i,j)>0 && angT(i,j)<=45)
            raT(i,j)=1;
        end
        if(angT(i,j)>45 && angT(i,j)<=90)
            raT(i,j)=2;
        end
        if(angT(i,j)>90 && angT(i,j)<=135)
            raT(i,j)=3;
        end
        if(angT(i,j)>135 && angT(i,j)<=180)
            raT(i,j)=4;
        end
        if(angT(i,j)>180 && angT(i,j)<=225)
            raT(i,j)=5;
        end
        if(angT(i,j)>225 && angT(i,j)<=270)
            raT(i,j)=6;
        end
        if(angT(i,j)>270 && angT(i,j)<=315)
            raT(i,j)=7;
        end
        if(angT(i,j)>315 && angT(i,j)<=360)
            raT(i,j)=8;
        end
    end
end
for i=1:9
    for j=1:textnum
        if(disT(i,j)<=100)
            rdT(i,j)=1;
        end
        if(disT(i,j)>100 && disT(i,j)<=250)
            rdT(i,j)=2;
        end
        if(disT(i,j)>250 && disT(i,j)<=400)
            rdT(i,j)=3;
        end
        if(disT(i,j)>400 && disT(i,j)<=550)
            rdT(i,j)=4;
        end
        if(disT(i,j)>550 && disT(i,j)<=700)
            rdT(i,j)=5;
        end
        if(disT(i,j)>700 && disT(i,j)<=850)
            rdT(i,j)=6;
        end
        if(disT(i,j)>850 && disT(i,j)<=1000)
            rdT(i,j)=7;
        end
        if(disT(i,j)>1000 && disT(i,j)<=10000)
            rdT(i,j)=8;
        end
    end
end
% determine the area of shape context
% 8->360/45
for i=1:9
    for j=1:textnum
        binT(i,j)=((8*(rdT(i,j)-1))+rdT(i,j))+raT(i,j);
    end
end
% vote
v=zeros(9,64);
for i=1:9
    numb=1;
for x=1:64
    for j=1:textnum
        if binT(i,j)==numb
            t=numb;
            v(i,t)=v(i,t)+1;
        end
    end
    numb=numb+1;
end
end
% cascade
C3=1;
for i=1:9
    for j=1:64
        voteT(1,C3)=v(i,j);
        C3=C3+1;
    end
end

vote=vote+voteT;

% xlabel('Cascade of nBins')
% ylabel('Number of faces and texts')

end

%% Plot picture
% for i=1:9
%     plot(shape_orgpt(i,1),shape_orgpt(i,2),'.','Markersize',50,'color',[1 0 0])
% end
% w=70;h=70; %face size
% for i=1:objnum
%     rectangle('position',[facedata(i,1),facedata(i,2),w,h],'edgecolor','b','LineWidth',2);
% %     pause
% end
% plot(blocksizeX,blocksizeY);
% w=20;h=20; %face size
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),w,h],'edgecolor','b','LineWidth',2);
% %     pause
% end