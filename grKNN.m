function [assignment]=grKNN(patterns,nData,test_sample)
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

assignment;

%% Relative position
sf=sprintf('./Detection/obj%d.txt',test_sample(num));
st=sprintf('./Detection/text%d.txt',test_sample(num));
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
pic=sprintf('./dataset/%d.jpg',test_sample(num));
a=imread(pic);
% imshow(a)
Cobj=[];Ctext=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
%center of text
Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);

M=Cobj;
N=[];
for i=1:objnum
t=Ctext(assignment(i),:);
N=[N;t];
end
[ra]=compute_angle(M,N);
rp=ra;

[sizeY,sizeX,~]=size(a);
C(1,1)=0.5*sizeX;
C(1,2)=0.5*sizeY;

%calculate angles
M(:,1)=C(1,1)*ones(objnum,1);
M(:,2)=C(1,2)*ones(objnum,1);
N=Cobj;
[ra]=compute_angle(M,N);

% vote
B=[];
% ra
% rp
B=[ra rp];


for i=1:objnum
    bin(i)=(B(i,1)-1)*8+B(i,2);
end
dim=8*8;
vTest=zeros(1,dim);
for i=1
    numb=1;
for x=1:dim
    for j=1:textnum
        if bin(1,j)==numb
            t=numb;
            vTest(i,t)=vTest(i,t)+1;
        end
    end
    numb=numb+1;
end
end


%%%%------save postion vote----------
m=1;
B=[];
site=sprintf('./Features/testRel%d.txt',test_sample(num));
for i=1:objnum*2
B=vTest;
fid = fopen(site, 'w');
fprintf(fid, '%f \n', B );
fclose(fid);
end




 end

end