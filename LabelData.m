clc;clear all;
test_sample=[97];
reg=0;reg2=0;Accuracy=[];
nData=size(test_sample,2);
testData = {} ;
testlabel = {} ;
for i=1:nData
sf1=sprintf('./Features/knn%d.txt',test_sample(i));
sf2=sprintf('./Features/geo%d.txt',test_sample(i));
F1=importdata(sf1);
F2=importdata(sf2);
Feature=[F1;F2];
 testData{1,i} =  Feature ;
end
%---------------show image result----------------------
Pic=1;
% for Pic=1:nData
pic=sprintf('./dataset/%d.jpg',test_sample(Pic));
a=imread(pic);
imshow(a)
hold on;
sf=sprintf('./Detection/obj%d.txt',test_sample(Pic));
st=sprintf('./Detection/text%d.txt',test_sample(Pic));
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
[objsize,~]=size(objdata);
[tsize,~]=size(textdata);
btext=textdata(:,1:2);
Cobj=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
for i=1:objnum
    rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
%     pause
end
for i=1:textnum
    rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',3);
%     pause
end
%%%%%%%%%%%%%%%%%%%%---------------------------------------------------------
x=testData{1,Pic};
feaReg=[];fEReg=[];
zw = x;
[z1,z2]=getNEfeatures(zw);
z=z1+z2;
c2=1;
node_num=sqrt(size(z,1));
zT=zeros(node_num,node_num);
yGT=zeros(node_num,node_num);
for j=1:node_num
    t=1;
    for i=((node_num*c2)-node_num)+1:node_num*c2
        zT(j,t)=z(i,1);
        t=t+1;
    end
    c2=c2+1;
end
%%%%%------GT to check performance-----------
%------------y Label assignment-------------
%-----------------------------------------------
str=size(zT,1);
for i=1:str
    for j=1:str
        z_(i,j)=exp(-zT(i,j));
    end
end
assignment=[]; 
Rand_assignment=[];
[assignment, cost] = assignmentoptimal(z_);
Rand_assignment=randperm(node_num);
Ymatch_Mat=zeros(node_num,node_num);
for i=1:node_num
    Ymatch_Mat(i,assignment(i))=1;
end
q=1;
for i=1:node_num
    for j=1:node_num
        Ymatch(q,1)=Ymatch_Mat(i,j);
        q=q+1;
    end
end

%--------------------------------------------------------

for i=1:objnum
    draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,0,0,0)
%     pause
end

% %%%%%-----save Label----------
m=1;
A=[];
site=sprintf('./Labels/L%d.txt',test_sample(Pic));
for i=1:objnum
    for j=1:objnum
A(j,i)=Ymatch_Mat(i,j);
fid = fopen(site, 'w');
fprintf(fid, '%f \n', A );
fclose(fid);
    end
end
% saveas( h , [ 'test' num2str( test_sample(Pic)) , '.jpg' ] )



