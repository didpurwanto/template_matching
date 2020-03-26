clear all;close all;clc;
tic
for picnum=1
pic=sprintf('./dataset/%d.jpg',picnum);
I=imread(pic);
I2=rgb2gray(I);
%--------------------------------------------
% imshow(I2);
%LBP
m=size(I2,1);
n=size(I2,2);
for i=2:m-1
    for j=2:n-1
        J0=I2(i,j);
        I3(i-1,j-1)=I2(i-1,j-1)>J0;
        I3(i-1,j)=I2(i-1,j)>J0;
        I3(i-1,j+1)=I2(i-1,j+1)>J0; 
        I3(i,j+1)=I2(i,j+1)>J0;
        I3(i+1,j+1)=I2(i+1,j+1)>J0; 
        I3(i+1,j)=I2(i+1,j)>J0; 
        I3(i+1,j-1)=I2(i+1,j-1)>J0; 
        I3(i,j-1)=I2(i,j-1)>J0;
        LBP(i,j)=I3(i-1,j-1)*2^7+I3(i-1,j)*2^6+I3(i-1,j+1)*2^5+I3(i,j+1)*2^4+I3(i+1,j+1)*2^3+I3(i+1,j)*2^2+I3(i+1,j-1)*2^1+I3(i,j-1)*2^0;
    end
end
%--------------------------------------------
[Ilabel num] = bwlabel(LBP);
% disp(num);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 num]);

% imshow(LBP);
% hold on;
% for cnt = 1:num
%     rectangle('position',Ibox(:,cnt),'edgecolor','r','LineWidth',3);
% end
height=Ibox(4,:);
length=Ibox(3,:);
A=max(height.*length);

i=1;j=1;
obj=[];text=[];
%%---Otsu's method find threshold-----
[T]=Otsu(height);
%%-------------------------------------
% Total area = 1500*1050
% Max bounding box area = 29160
% define noise is bounding box is small, area less than 20*20 (pixels) 
for cnt = 1:num
    if Ibox(3,cnt)<=20 || Ibox(4,cnt)<=20
        Ibox(:,cnt)=1;
    end
    if Ibox(:,cnt)~=1
    %show all bounding box
%     rectangle('position',Ibox(:,cnt),'edgecolor','r','LineWidth',3);
    end
    
    if Ibox(4,cnt)>=T 
        obj(i,1)=Ibox(1,cnt);
        obj(i,2)=Ibox(2,cnt);
        obj(i,3)=Ibox(3,cnt);
        obj(i,4)=Ibox(4,cnt);
        i=i+1;
    else if Ibox(:,cnt)~=1
        text(j,1)=Ibox(1,cnt);
        text(j,2)=Ibox(2,cnt);
        text(j,3)=Ibox(3,cnt);
        text(j,4)=Ibox(4,cnt);
        j=j+1;
        end
    end
end




%% show object
imshow(I);
hold on;
[objnum,~]=size(obj);
for i=1:objnum
    rectangle('position',[obj(i,1),obj(i,2),obj(i,3),obj(i,4)],'edgecolor','b','LineWidth',3);
%     pause
end
[textnum,~]=size(text);
for i=1:textnum
    rectangle('position',[text(i,1),text(i,2),text(i,3),text(i,4)],'edgecolor','r','LineWidth',3);
%     pause
end

%% SAVE DATA
object=sprintf('./Detection/obj%d.txt',picnum);
[objnum,~]=size(obj);
for i=1:objnum
    for j=1:4       
fid = fopen(object, 'a');
if j~=4
    fprintf(fid, '%f ', obj(i,j) );
else
    fprintf(fid, '%f\n', obj(i,j) );
end
    fclose(fid);
    end
end

texts=sprintf('./Detection/text%d.txt',picnum);
[textnum,~]=size(text);
for i=1:textnum
    for j=1:4       
fid = fopen(texts, 'a');
if j~=4
    fprintf(fid, '%f ', text(i,j) );
else
    fprintf(fid, '%f\n', text(i,j) );
end
    fclose(fid);
    end
end

disp(['Finish....... '  num2str(picnum)  '/210.....'  num2str(objnum) ' ' num2str(textnum)]) 

end
% %PCA
% [eigenVector,score,eigenvalue,tsquare] = princomp(LBP); 
% transMatrix = eigenVector(:,1:300);
% matrix = LBP * transMatrix;
toc
