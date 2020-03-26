clc;clear all;close all;
tic
for picnum=1
sf=sprintf('./Detection/obj%d.txt',picnum);
st=sprintf('./Detection/text%d.txt',picnum);
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
textdata2=textdata;
objdata2=objdata;
%% show obj  and text
% pic=sprintf('D:/HW/data/%d.jpg',picnum);
% a=imread(pic);
% imshow(a)
% hold on;
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',2);
% %     pause
% end
%% Object
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
knum=objnum;
[knnindex,rbfdis,knn_sim]=knn(Cobj,CtextN);
[shape_sim]=shape(Cobj,CtextN);
[vote]=positionvote(picnum);
fVReg=knn_sim;
fEReg=shape_sim;
fV=[];fE=[];
for i=1:objsize
    for j=1:objsize
         [~,ind]=sort(knnindex(i,:));
         fV(i,j)=fVReg(i,ind(j));
         fE(i,j)=fEReg(i,ind(j));
    end
end

% zT=fV+fE;
% str=size(zT,1);
% for i=1:str
%     for j=1:str
%         z_(i,j)=exp(-zT(i,j));
%     end
% end
% [assignment, cost] = assignmentoptimal(z_);
% assignment
%%------------------------------------------------------------
%% save txt
% % 
% % %%%%----save F1 KNN----------
% a=[];
% site=sprintf('D:/HW/SVM_textbookDATA/knn%d.txt',picnum);
% for i=1:objnum
%     for j=1:objnum
% a(j,i)=fV(i,j);
% fid = fopen(site, 'w');
% fprintf(fid, '%f \n', a );
% fclose(fid);
%     end
% end
% 
% % %%%%%-----save F2 Geo----------
% m=1;
% A=[];
% site=sprintf('D:/HW/SVM_textbookDATA/geo%d.txt',picnum);
% for i=1:objnum
%     for j=1:objnum
% A(j,i)=fE(i,j);
% fid = fopen(site, 'w');
% fprintf(fid, '%f \n', A );
% fclose(fid);
%     end
% end
%%%%%------save F3 postion vote----------
m=1;
B=[];
site=sprintf('D:/HW/SVM_textbookDATA/vote%d.txt',picnum);
for i=1:objnum*2
B=vote;
fid = fopen(site, 'w');
fprintf(fid, '%f \n', B );
fclose(fid);
end

disp(['Finish....... '  num2str(picnum)  '/100.....'  num2str(objnum)]) 
end
toc