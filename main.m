clear all;clc;
numiteration = 300;
numData=numiteration;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Training and Testing setting
load training
load testing

% %%%---- Training Data--------
% %%%~~~Input the training data number you want~~~~~
% %%%-------Testing Data-------
% test_sample=[21 47 48 287 290 293];
% pattern_L=[4 8 6 8 8 8];
% test_sample=[21];
% pattern_L=[4];

%%%%%%%%%%%%  Direction 1   -------------------------------------
% test_sample=[16 17 18 90 91 92 93 94 96  262 263 264 265 266 267 268 269 270 271 272 273 274 275];
% pattern_L=[22 22 22 22 22 22 22 22 22 22  22 22 22 22 22 22 22 22 22 22 22 22 22 ];
%%%%%%%%%%%%  Direction 2   -------------------------------------
% test_sample=[105 39 40 33 36 139 49 287 289 26 27 51 53 54 58 59 60 12 99 219 230];
% pattern_L=[1 2 2 3 4 7 8 8 8 11 11 12 12 12 13 14 14 16 16 16 16];
%%%%%%%%%%%%  Direction 3   -------------------------------------
% test_sample=[87 88 89 9 25 67 65 69 68 70 100 76 167 180 274 4 7 8 9 10 13 14 18 19 254];
% pattern_L=[10 10 10 15 17 18 19 19 20 20 23 24 10 10 22 9 15 15 15 15 18 18 23 23 19]

%%%%%%%%%%%%%%%%%%%%%%%%%%
Ntest=size(test_sample,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
disp(['Select the mode:(Input 1~6)']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
disp(['1:Detection']);
disp(['2:Feature extraction']);
disp(['3:Learning our models']);
disp(['4:Inference']);
disp(['5:Other approaches']);
disp(['6:K-fold cross validation (Our approach)']);
disp(['7:K-fold cross validation (Two phase)']);
disp(['8:K-fold cross validation (LAP)']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
Modenum=input('Select mode¡G'); 
if Modenum==5
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);   
disp(['Select the approach:']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
disp(['1:KNNs']);
disp(['2:Greedy method']);
disp(['3:Shape matching']);
disp(['4:Two phase']);
disp(['5:LAP Inference']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
Other=input('Select the approach:');
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
end
%% Detection
if Modenum==1
tic    
for picnum= 1:75 %1:numiteration
%load data    
pic=sprintf('./dataset/%d.jpg',picnum);
I=imread(pic);
I2=rgb2gray(I);
%--------------------------------------------
% imshow(I2);
% LBP
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
% connected component labeling
%--------------------------------------------
[Ilabel num] = bwlabel(LBP);
% disp(num);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 num]);
%---------------------------------------------
%%% show LBP result
% imshow(LBP);
% hold on;
% show connected component labeling finding the bounding boxes result (including noise and not classify objs and texts)
% for cnt = 1:num
%     rectangle('position',Ibox(:,cnt),'edgecolor','r','LineWidth',3);
% end
%------------------------------------------
height=Ibox(4,:);
length=Ibox(3,:);
A=max(height.*length);
i=1;j=1;
obj=[];text=[];
%%%--------Otsu's method find threshold-----
[T]=Otsu(height);
%%------------------------------------------
% Total area = 1500*1050
% Max bounding box area = 29160
% define noise is bounding box is small, area less than 20*20 (pixels) 
for cnt = 1:num
    if Ibox(3,cnt)<=20 || Ibox(4,cnt)<=20 || Ibox(3,cnt)>=1000 || Ibox(4,cnt)>=1000
        Ibox(:,cnt)=1;
    end
    if Ibox(:,cnt)~=1
    %show all bounding box
%     rectangle('position',Ibox(:,cnt),'edgecolor','r','LineWidth',3);
    end
    % classify objs and texts with threshold
%     T=70;
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
%%% -------------Show Detection result---------------------------
% % Blue = objects
% % Red = words
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = figure();
imshow(I);
hold on;
[objnum,~]=size(obj);
for i=1:objnum
    rectangle('position',[obj(i,1),obj(i,2),obj(i,3),obj(i,4)],'edgecolor','b','LineWidth',4);
end
[textnum,~]=size(text);
for i=1:textnum
    rectangle('position',[text(i,1),text(i,2),text(i,3),text(i,4)],'edgecolor','r','LineWidth',4);
end
saveas( h , [ 'DetectionResult' num2str(picnum) , '.jpg' ] );
close all
%% ------------SAVE DATA-------------------------------
%%%-------------Clear data-----------------------------
site=sprintf('./Detection/obj%d.txt',picnum);
fid = fopen(site, 'w');
fclose(fid);
%%--------------Save-------------------------------------
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
% %%%-------------Clear data-----------------------------
site=sprintf('./Detection/text%d.txt',picnum);
fid = fopen(site, 'w');
fclose(fid);
%%--------------Save-------------------------------------
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
% ------------Finish Detection--------------
disp(['Finish....... '  num2str(picnum)  '/numiteration.....' num2str(objnum) ' ' num2str(textnum)]) 
% disp(['Finish....... '  num2str(picnum)  '/numiteration']) 
end
toc
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
disp(['Complete detection!'])
disp(['The bounding boxes of objects and words are saved in the "Detection". '])
disp(['Next run "feature extraction" . '])
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
end
%% Feature extraction
if Modenum==2
tic
for picnum=1:numiteration
sf=sprintf('./Detection/obj%d.txt',picnum);
st=sprintf('./Detection/text%d.txt',picnum);
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
textdata2=textdata;
objdata2=objdata;
%% show obj  and text
% pic=sprintf('./dataset/%d.jpg',picnum);
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
%%%%%% Parameter sigma%%%%%%
sigma1=5;
sigma2=10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[knnindex,rbfdis,knn_sim]=knn(Cobj,CtextN,sigma1);
[shape_sim]=shape(Cobj,CtextN,sigma2);
[vote2]=TwoLevel(picnum);
[vT]=mv(picnum);
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

%--------------------------------------------------------
%%%%%% Parameter K
K=objnum;
KNN_sim=zeros(objnum,objnum);
Kshape_sim=zeros(objnum,objnum);
for i=1:objnum
    for j=1:K
        KNN_sim(i,knnindex(i,j))=knn_sim(i,j);
        Kshape_sim(i,knnindex(i,j))=shape_sim(i,j);
    end
end
% KNN_sim
%%------------------------------------------------------------
%% save txt

% %%%%----save F1 KNN----------
a=[];
site=sprintf('./Features/knn%d.txt',picnum);
for i=1:objnum
    for j=1:objnum
% a(j,i)=fV(i,j);
a(j,i)=KNN_sim(i,j);
fid = fopen(site, 'w');
fprintf(fid, '%f \n', a );
fclose(fid);
    end
end

% % %%%%%-----save F2 Geo----------
m=1;
A=[];
site=sprintf('./Features/geo%d.txt',picnum);
for i=1:objnum
    for j=1:objnum
% A(j,i)=fE(i,j);
A(j,i)=Kshape_sim(i,j);
fid = fopen(site, 'w');
fprintf(fid, '%f \n', A );
fclose(fid);
    end
end


disp(['Finish....... '  num2str(picnum)  '/' num2str(numData) ]) 
end
toc
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
disp(['Complete Feature extraction!'])
disp(['The corresponding relation between objects and words are saved in the "Features". '])
disp(['Next run "Learning" . '])
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
end
%% Learning graph matching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % During training, the program will sometimes report warnings that the slack of the most violated constraint is smaller than the slack of the working set. 
% % This is due to SVMstruct using approximate inference during constraint generation and is expected behavior.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%---Train object-word association model---
if Modenum==3
tic
for modelnum=1:24
    train_sample=eval(['model',num2str(modelnum)]);
    ssvm_train(train_sample,modelnum);
end
traindata=[model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 model14 model15 model16 model17 model18 model19 model20 model21 model22 model23 model24];
trainLabel=[];
for i=1:24
    A(1:size(eval(['model' num2str(i)]),2))=i;
    trainLabel=[trainLabel A];
    A=0;
end
%%%--Train template matching model-----
Train_multiclassSVM(traindata,trainLabel);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
disp(['Complete learning our model!'])
disp(['Next run "Inference" . '])
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'])
toc
end
%% Inference
if Modenum==4

Ntest=size(test_sample,2);
BD_initialTestRel(test_sample);
tic
Template_Match(test_sample,pattern_L);
[Assignment,PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
Assignment_reg=Assignment;
Pr = load('./Data/predictions');
Pm = Pr(:,1);
Predicts_reg = Pm;
A=[];
eq_score=0;
% Iterations 
for iter=1:5
    eq_score=0;
    Template_Match(test_sample,pattern_L);
    Pr = load('./Data/predictions');
    Pm = Pr(:,1);
    [Assignment,PLA,MLA,CM,Lt]=infer_matching(test_sample,pattern_L);
    for i=1:Ntest
        if Assignment_reg{i,1}~=Assignment{i,1}
            Assignment_reg=Assignment;
        else
            eq_score=eq_score+1;
        end
    end
    if sum(Predicts_reg==Pm)~=Ntest 
        Predicts_reg = Pm;
    else if sum(Predicts_reg==Pm)==Ntest && eq_score==Ntest
        break;
        end
    end
end

    %% ---------------show image result----------------------
% h = figure( 1 ) ;   
% for Pic=1:Ntest
% pic=sprintf('./dataset/%d.jpg',test_sample(Pic));
% a=imread(pic);
% imshow(a);
% hold on;
% sf=sprintf('./Detection/obj%d.txt',test_sample(Pic));
% st=sprintf('./Detection/text%d.txt',test_sample(Pic));
% objdata=importdata(sf);
% textdata=importdata(st);
% objnum=size(objdata,1);
% textnum=size(textdata,1);
% [objsize,~]=size(objdata);
% [tsize,~]=size(textdata);
% btext=textdata(:,1:2);
% Cobj=[];
% %center of obj
% Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
% Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',2);
% %     pause
% end
% assignment=Assignment{Pic};
% Ltag=Lt{Pic};
% for i=1:objnum
%     if assignment(i)==Ltag(i)
%         r=0;g=0;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     else
%         r=1;g=1;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     end
% end
% saveas( h , [ './result/SSVM/SSVM' num2str( test_sample(Pic)) , '.jpg' ] )
% end
%% Show result

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;

disp(['PLA is: '  num2str(PLA) '%']) ;
disp(['MLA is: '  num2str(MLA) '%']) ;

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;

CM;
% %----Show Confusuin Matrix
% h = figure( 1 ) ;
% num_class=12;
% Row=0;
% 
% Confusion_matrix=CM;
% for i=1:num_class
%     for j=1:num_class
%         Row=Row+Confusion_matrix(i,j);
%     end
%     num_in_class(1,i)=Row;
%     Row=0;
% end
% 
% for i=1:num_class
%     confusion_matrix(i,:)=Confusion_matrix(i,:)/num_in_class(i)*100;
% end
% 
% name_class(1,1) = {'Template 1'};
% name_class(2,1) = {'Template 2'};
% name_class(3,1) = {'Template 3'};
% name_class(4,1) = {'Template 4'};
% name_class(5,1) = {'Template 5'};
% name_class(6,1) = {'Template 6'};
% name_class(7,1) = {'Template 7'};
% name_class(8,1) = {'Template 8'};
% name_class(9,1) = {'Template 9'};
% name_class(10,1) = {'Template 10'};
% name_class(11,1) = {'Template 11'};
% name_class(12,1) = {'Template 12'};
% confusion_matrix=roundn(confusion_matrix,-2)
% draw_cm(confusion_matrix,name_class,num_class)
% 
% saveas( h , [ './result/confusion_matrix/CM'  , '.jpg' ] )


toc
end
%% Other methods
%% -------General method----KNNs---------------
%-------Nearest Neighbor----
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Modenum==5 && Other==1
    tic
Score=0;Err=0;Er=[];MSet=[];MsSet=[];
disp(['Computing .........']) ;
Accuracy=[];
nData=size(test_sample,2);
testData = {} ;
testlabel = {} ;   
for i=1:Ntest
sf1=sprintf('./Features/knn%d.txt',test_sample(i));
l=sprintf('./Labels/L%d.txt',test_sample(i));
F1=importdata(sf1);
l=importdata(l);
Label=[l];
patterns{1,i} =  F1 ;
%  testData{1,i} =  Feature ;
 testLabel{1,i}   = Label ;
end
[Accuracy,Match_Level_ACC]=greedyKNN(patterns,Ntest,test_sample);
Avg_accuracy2=Accuracy;


disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['--------------- KNNs result: -------------------']) ;
disp(['Page level accuracy (PLA): '  num2str(Avg_accuracy2*100) '%']) ;
disp(['Match level accuracy (MLA): '  num2str(Match_Level_ACC*100) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
toc
end
%% -------without learning----Greedy----------
%%%-------1. Greedy method-----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Modenum==5 && Other==2
    tic
    disp(['Computing .........']) ;
Accuracy=[];
nData=size(test_sample,2);
testData = {} ;
testlabel = {} ;   
for i=1:Ntest
sf1=sprintf('./Features/knn%d.txt',test_sample(i));
sf2=sprintf('./Features/geo%d.txt',test_sample(i));
l=sprintf('./Labels/L%d.txt',test_sample(i));
F1=importdata(sf1);
F2=importdata(sf2);
l=importdata(l);
Feature=[F1;F2];
Label=[l;l];
patterns{1,i} =  Feature ;
 testData{1,i} =  Feature ;
 testLabel{1,i}   = Label ;
end
[Accuracy,Match_Level_ACC]=greedy(patterns,Ntest,test_sample);
Avg_accuracy2=Accuracy;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['----------- Greedy method result: --------------']) ;
disp(['Page level accuracy (PLA): '  num2str(Avg_accuracy2*100) '%']) ;
disp(['Match level accuracy (MLA): '  num2str(Match_Level_ACC*100) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
toc
end
%% ------------------Shape-----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Modenum==5 && Other==3
tic;
[PLA,MLA]=Shape_matching(test_sample);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['----------- Shape relation result: -------------']) ;
disp(['Page level accuracy (PLA): '  num2str(PLA*100) '%']) ;
disp(['Match level accuracy (MLA): '  num2str(MLA*100) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
toc;
end
%% ------------------Two phase-----------------------
if Modenum==5 && Other==4
    tic;
disp(['Computing .........']) ;
[modelID]=PatternReg(test_sample,pattern_L);
Accuracy=[];
nData=size(test_sample,2);
testData = {} ;
testlabel = {} ;
for i=1:nData
sf1=sprintf('./Features/knn%d.txt',test_sample(i));
sf2=sprintf('./Features/geo%d.txt',test_sample(i));
l=sprintf('./Labels/L%d.txt',test_sample(i));
F1=importdata(sf1);
F2=importdata(sf2);
l=importdata(l);
Feature=[F1;F2];
Label=[l;l];
 testData{1,i} =  Feature ;
 testLabel{1,i}   = Label ;
end

Sc=0;
best_Ymatch_S=[];
testL=[];predict=[];
Sum_score=0;
Err=0;
T=0;
Ms=0;
Er=[];MsSet=[];MSet=[];
for Pic=1:nData
% h = figure( 1 ) ;
As=[]; selans=[];SUM_F=[];Score_set=[];
Ym=[]; %Y matching result
clf
% %%---------------------------------------------------------
% %compute argmax y
    for modelsel=1:24
    W=[];
    load(['./model/model' ,num2str(modelsel)]);
    x=testData{1,Pic};
    y=testLabel{1,Pic};
    if size(x,1)~=size(W,1)
        continue;
    end
    selans=[selans;modelsel];
    end
    Score=[];
    a=size(selans,1);
    ans=[];
    for i=1:a
        if sum(modelID(Pic)==selans)==1
            ans=modelID(Pic);
        else  
        s=randperm(a,1);    
        ans=selans(s);
        end
    end
    load(['./model/model' ,num2str(ans)]);
    [Ymatch,yGT,Ymatch_Mat,assignment,match_score,msize,match] = match2(x,W,y);
    MsSet=[MsSet match];
    MSet=[MSet msize];
    Sum_score=Sum_score+match_score;
    T=T+1;
    if match_score==1
        Ms=Ms+1;
    end
%     %% ---------------show image result----------------------
%     L=sprintf('./Labels/L%d.txt',test_sample(Pic));
%     y=importdata(L);
%     %------------y Label assignment-------------
%     node_num=msize;
% Ltag=[];Y=1;
% for c3=1:node_num
%     for j=((node_num*c3)-node_num)+1:node_num*c3
%         if y(j)==1
%             Ltag(Y)=rem(j,node_num);
%             if rem(j,node_num)==0
%                 Ltag(Y)=node_num;
%             end
%                 Y=Y+1;
%         end
%     end
% end
% %-----------------------------------------------
% %%-------------------------------------------------
% pic=sprintf('./dataset/%d.jpg',test_sample(Pic));
% a=imread(pic);
% imshow(a)
% hold on;
% sf=sprintf('./Detection/obj%d.txt',test_sample(Pic));
% st=sprintf('./Detection/text%d.txt',test_sample(Pic));
% objdata=importdata(sf);
% textdata=importdata(st);
% objnum=size(objdata,1);
% textnum=size(textdata,1);
% [objsize,~]=size(objdata);
% [tsize,~]=size(textdata);
% btext=textdata(:,1:2);
% Cobj=[];
% %center of obj
% Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
% Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',2);
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
% saveas( h , [ './result/2phase/2phase' num2str( test_sample(Pic)) , '.jpg' ] )
end
Ntest=size(MsSet,2);
Correct_Match=sum(MsSet(1:Ntest));
Total_Match=sum(MSet(1:Ntest));
Match_Level_ACC=Correct_Match/Total_Match;
Avg_accuracy1=Sum_score/nData;
Avg_accuracy2=Ms/nData;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['-------------- Two phase result: ---------------']) ;
disp(['Page level accuracy (PLA): '  num2str(Avg_accuracy2*100) '%']) ;
disp(['Match level accuracy (MLA): '  num2str(Match_Level_ACC*100) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
toc
end
%% ------------------LAP inference-----------------------
if Modenum==5 && Other==5
tic
Ntest=size(test_sample,2);
BD_initialTestRel(test_sample);
Template_Match(test_sample,pattern_L)
[Assignment,PLA,MLA,CM]=infer_matching_LAP(test_sample,pattern_L);
Assignment_reg=Assignment;
Pr = load('./Data/predictions');
Pm = Pr(:,1);
Predicts_reg = Pm;
for iter=1:5
    eq_score=0;
    Template_Match(test_sample,pattern_L)
    Pr = load('./Data/predictions');
    Pm = Pr(:,1);
    [Assignment,PLA,MLA,CM,Lt]=infer_matching_LAP(test_sample,pattern_L);
    for i=1:Ntest
        if Assignment_reg{i,1}~=Assignment{i,1}
            Assignment_reg=Assignment;
        else
            eq_score=eq_score+1;
        end
    end
    if sum(Predicts_reg==Pm)~=Ntest 
        Predicts_reg = Pm;
    else if sum(Predicts_reg==Pm)==Ntest && eq_score==Ntest
        break;
        end
    end
end
% %     %% ---------------show image result----------------------
% h = figure( 1 ) ;   
% for Pic=1:Ntest
% pic=sprintf('./dataset/%d.jpg',test_sample(Pic));
% a=imread(pic);
% imshow(a);
% hold on;
% sf=sprintf('./Detection/obj%d.txt',test_sample(Pic));
% st=sprintf('./Detection/text%d.txt',test_sample(Pic));
% objdata=importdata(sf);
% textdata=importdata(st);
% objnum=size(objdata,1);
% textnum=size(textdata,1);
% [objsize,~]=size(objdata);
% [tsize,~]=size(textdata);
% btext=textdata(:,1:2);
% Cobj=[];
% %center of obj
% Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
% Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',2);
% %     pause
% end
% assignment=Assignment{Pic};
% Ltag=Lt{Pic};
% for i=1:objnum
%     if assignment(i)==Ltag(i)
%         r=0;g=0;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     else
%         r=1;g=1;b=0;
%         draw_arrow(Cobj(i,:),btext(assignment(i),:),.1,r,g,b)
%     end
% end
% saveas( h , [ './result/LAP/LAP' num2str( test_sample(Pic)) , '.jpg' ] )
% end
% [PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
%% Show result
% h = figure( 1 ) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;

disp(['PLA is: '  num2str(PLA) '%']) ;
disp(['MLA is: '  num2str(MLA) '%']) ;

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
% 
% CM;
% %----Confusuin Matrix
% num_class=12;
% Row=0;
% 
% Confusion_matrix=CM;
% for i=1:num_class
%     for j=1:num_class
%         Row=Row+Confusion_matrix(i,j);
%     end
%     num_in_class(1,i)=Row;
%     Row=0;
% end
% 
% for i=1:num_class
%     confusion_matrix(i,:)=Confusion_matrix(i,:)/num_in_class(i)*100;
% end
% 
% 
% name_class(1,1) = {'Template 1'};
% name_class(2,1) = {'Template 2'};
% name_class(3,1) = {'Template 3'};
% name_class(4,1) = {'Template 4'};
% name_class(5,1) = {'Template 5'};
% name_class(6,1) = {'Template 6'};
% name_class(7,1) = {'Template 7'};
% name_class(8,1) = {'Template 8'};
% name_class(9,1) = {'Template 9'};
% name_class(10,1) = {'Template 10'};
% name_class(11,1) = {'Template 11'};
% name_class(12,1) = {'Template 12'};
% confusion_matrix=roundn(confusion_matrix,-2)
% draw_cm(confusion_matrix,name_class,num_class)
% 
% saveas( h , [ './result/confusion_matrix/CM'  , '.jpg' ] )
toc
end
%% Cross validation
%Our approach
if Modenum==6
 CrossValaid  
end
%% Cross validation
%Two phase
if Modenum==7
 cross2   
end
%% Cross validation
%LAP
if Modenum==8
 cross
end