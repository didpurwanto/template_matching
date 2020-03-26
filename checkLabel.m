%%--Double check Label 
test_sample=[152];
l=sprintf('./Labels/L%d.txt',test_sample(1));
l=importdata(l);
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
%%%%%------GT to check performance-----------
%------------y Label assignment-------------
node_num=objnum;
Ltag=[];Y=1;
for c3=1:node_num
    for j=((node_num*c3)-node_num)+1:node_num*c3
        if l(j)==1
            Ltag(Y)=rem(j,node_num);
            if rem(j,node_num)==0
                Ltag(Y)=node_num;
            end
                Y=Y+1;
        end
    end
end
Ltag
for i=1:objnum
    draw_arrow(Cobj(i,:),btext(Ltag(i),:),.1,0,0,0)
    pause
end