function [Accuracy,Match_Level_ACC]=greedyKNN(patterns,nData,test_sample)
%%------find possible matching matrix {y}------------------
Yset=[];Score=0;Err=0;Hloss=0;Er=[];MsSet=[];MSet=[];
 for num=1:nData
E=0;
x=patterns{1,num};
nodenum = sqrt(size(x,1));
NN=x(1:size(x,1));
c2=1;
on=nodenum;
zmat=zeros(nodenum,on);

z=NN;
for j=1:nodenum
    t=1;
    for i=((on*c2)-on)+1:on*c2
        zmat(j,t)=z(i,1);
        t=t+1;
    end
    c2=c2+1;
end
yReg=zeros(nodenum,on);
assignment=[];
z_index=[];
for i=1:nodenum
    [~,I]=max(zmat(i,:));
    yReg(i,I)=1;
    assignment=[assignment I];
    [~,pos]=sort(zmat(i,:));
    z_index=[z_index;pos];
end

% %------------revise-----------
[v,index]=sort(assignment);
x=1;y=1;F=1;
for i=1:nodenum-1
    if v(i)==v(i+1)
        x=i;
        P(F)=index(x);
        F=F+1;
        y=i+1;
        P(F)=index(y);
        F=F+1;
    end
end
x=1;
need=[];
for i=1:nodenum
    c=0;
    for j=1:nodenum
        if assignment(j)~=i
            c=c+1;
        end
    end
    if c==nodenum
        need(x)=i;
        x=x+1;
        c=0;
    end
end


if y>1
[~,sizeP]=size(P);
end
% P
% Ltag
cont=0;
n=1;
for i=1:nodenum
    for j=1:nodenum
        if v(j)~=i
            cont=cont+1;
        end
    end
    if cont==nodenum
        R=i;
        for a=1:sizeP
            if P(a)==R
%                 Ltag(i)=i;
            end
        end
    end
    cont=0;
end
x=1;
need=[];
for i=1:nodenum
    c=0;
    for j=1:nodenum
        if assignment(j)~=i
            c=c+1;
        end
    end
    if c==nodenum
        need(x)=i;
        x=x+1;
        c=0;
    end
end
[~,det]=size(need);


% assignment
% score

for iter=1:100
    if det>=1
        [~,sn]=size(need);
        [~,sp]=size(P);
        score=zeros(sp,sn);
        for i=1:sp
            for j=1:nodenum
                for k=1:sn
                    if z_index(P(i),j)==need(k)
                        score(i,k)=zmat(P(i),need(k));
                    end
                end
            end
        end
        [~,indexScore]=sort(score,'descend');
        for i=1:sn  
            for j=1:sp
                assignment(1,P(1,indexScore(1,i)))=need(i);
            end
        end

        %update P
        [v,index]=sort(assignment);
        x=1;y=1;F=1;P=[];
        for i=1:nodenum-1
            if v(i)==v(i+1)
            x=i;
            P(F)=index(x);
            F=F+1;
            y=i+1;
            P(F)=index(y);
            F=F+1;
            end
        end
        
        %Update need
        x=1;
        need=[];
        for i=1:nodenum
        c=0;
            for j=1:nodenum
                if assignment(j)~=i
                c=c+1;
                end
            end
            if c==nodenum
            need(x)=i;
            x=x+1;
            c=0;
            end
        end
       [~,det]=size(need);
    end
end

%%---assignment trans to label------------
Ymatch_Mat=zeros(nodenum,nodenum);
Ymatch=[];
for i=1:nodenum
    Ymatch_Mat(i,assignment(i))=1;
end
q=1;
for i=1:nodenum
    for j=1:nodenum
        Ymatch(q,1)=Ymatch_Mat(i,j);
        q=q+1;
    end
end
Ymatch=[Ymatch;Ymatch];
Yset=[Yset;Ymatch];

%%---------------accuracy of greedy method----------------------
l=sprintf('./Labels/L%d.txt',test_sample(num));
l=importdata(l);
Ltag=[];Y=1;
for c3=1:nodenum
    for j=((nodenum*c3)-nodenum)+1:nodenum*c3
        if l(j)==1
            Ltag(Y)=rem(j,nodenum);
            if rem(j,nodenum)==0
                Ltag(Y)=nodenum;
            end
                Y=Y+1;
        end
    end
end
assignment=assignment;
Ltag=Ltag;
A=0;
if assignment==Ltag
    A=1;
end
Score=Score+A;
sizeA=size(assignment,2);
Ms=0;
for i=1:sizeA
    if assignment(i)~=Ltag(i)
        E=E+1;
    end
    if assignment(i)==Ltag(i)
        Ms=Ms+1;
    end
end
MsSet=[MsSet Ms];
MSet=[MSet sizeA];
Error=E/sizeA;
Err=Err+Error;
Er=[Er Error];



% %% show obj  and text
% sf=sprintf('./Detection/obj%d.txt',test_sample(num));
% st=sprintf('./Detection/text%d.txt',test_sample(num));
% objdata=importdata(sf);
% textdata=importdata(st);
% objnum=size(objdata,1);
% textnum=size(textdata,1);
% textdata2=textdata;
% objdata2=objdata;
% %-------------- build features------------------ 
% %ang=angles between objs and objs
% [objsize,~]=size(objdata);
% [tsize,~]=size(textdata);
% Cobj=[];Ctext=[];
% %center of obj
% Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
% Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
% %center of text
% Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
% Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);
% CtextN=[];
% CtextN=Ctext;
% btext=textdata(:,1:2);
% 
% %%%
% pic=sprintf('./dataset/%d.jpg',test_sample(num));
% a=imread(pic);
% imshow(a)
% hold on;
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',3);
% %     pause
% end
% for i=1:objnum
%     if assignment(i)==Ltag(i)
%         r=0;g=0;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     else
%         r=1;g=1;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     end
% end
% h = figure( 1 ) ;
%  saveas( h , [ './result/Knn/Knn' num2str( test_sample(num)) , '.jpg' ] )

 end
Correct_Match=sum(MsSet(1:nData));
Total_Match=sum(MSet(1:nData));
Match_Level_ACC=Correct_Match/Total_Match;
Accuracy=Score/nData;
end