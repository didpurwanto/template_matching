clc;clear all;
for picnum=1:300
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

[sizeY,sizeX,~]=size(a);
C(1,1)=0.5*sizeX;
C(1,2)=0.5*sizeY;
%------------y Label assignment-------------

l=sprintf('./Labels/L%d.txt',picnum);
l=importdata(l);
nodenum=sqrt(size(l,1));
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
%--------------------------------------------
%-----------Relative position----------------
% RP=[];
% for i=1:objnum
%     rp=Cobj(i,:)-Ctext(Ltag(i),:);
%     RP=[RP;rp];
% end
M=Cobj;
N=[];
for i=1:objnum
t=Ctext(Ltag(i),:);
N=[N;t];
end
%calculate the orientation of image-text
[ra]=compute_angle(M,N);
rp=ra;

k=1;
c=0; % number of relative position
for j=1:objnum
    position(k,:)=M(j,:)-N(j,:);
    k=k+1;
    c=c+1;
end
%calculate distance
for i=1:c
    distance(i,1)=sqrt((position(i,1)^2)+(position(i,2)^2));
end



%% Obj
%calculate angles
M(:,1)=C(1,1)*ones(objnum,1);
M(:,2)=C(1,2)*ones(objnum,1);
N=Cobj;
[ra]=compute_angle(M,N);
% Calcuate Distance
k=1;
c=0; % number of relative position
for j=1:objnum
    pos(k,:)=C(1,:)-Cobj(j,:);
    k=k+1;
    c=c+1;
end
%calculate distance
for i=1:c
    d(i,1)=sqrt((pos(i,1)^2)+(pos(i,2)^2));
end
% Two Level
R=350;
rd=[];
for i=1:objnum
    if(d(i,1)<=R)
        rd(i,1)=1;
    else
        rd(i,1)=2;
    end
end
rel=[];
rel=ra+(rd-1)*8;


% vote
B=[];
% ra
% rp
B=[rel rp];


for i=1:objnum
    bin(i)=(B(i,1)-1)*8+B(i,2);
end
dim=2*8*8;
vT=zeros(1,dim);
for i=1
    numb=1;
for x=1:dim
    for j=1:objnum
        if bin(1,j)==numb
            t=numb;
            vT(i,t)=vT(i,t)+distance(j,1);
        end
    end
    numb=numb+1;
end
end

%normalize
vT=normr(vT);

%%%%------save postion vote----------
m=1;
B=[];
site=sprintf('./Features/Rel%d.txt',picnum);
for i=1:objnum*2
B=vT;
fid = fopen(site, 'w');
fprintf(fid, '%f \n', B );
fclose(fid);
end

end




