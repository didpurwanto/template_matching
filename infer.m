clc;clear all;
% test_sample=[105 39 40 33 36 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 2 25 99 65 67 68 69 70 93 94 96 76 139 287 289 219 230 100  5  7];
% pattern_L=  [ 1  2  2  3  4  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 17 16 19 18 20 19 20 22 22 21 24  7   8   8  16   16  23 12 15];
% test_sample=[1 105 39 40 33 36 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 2 25 99 65 67 68 69 70 93 94 96 76 139 287 289 219 230 100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160];
% pattern_L=  [1 1  2  2  3  4  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 17 16 19 18 20 19 20 22 22 21 24  7   8   8  16   16  23 12 15 2  2  3  4   7  8  8  8  9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16   16  16  17  18  19  20  20  21  22  22  23 23  24 11 11];
%-----Test Data number------- 
% test_sample=[39 40 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 25 99 65 67 68 69 70 93 94 96 76 80 105 139 287 289 219 230];
% %----pattern label----------
%%%%%%%%%%%%  Direction 1   -------------------------------------
% test_sample=[16 17 90 91 92 93 94 96 97 262 263 264 265 266 267 268 269 270 271 272 273 274];
% pattern_L=[21 21 22 22 22 22 22 21 21 21 21 21 21 21 22 22 22 22 22 22 22 22];
%%%%%%%%%%%%  Direction 2   -------------------------------------
% test_sample=[105 39 40 33 36 139 49 287 289 26 27 51 53 54 58 59 60 12 99 219 230];
% pattern_L=[1 2 2 3 4 7 8 8 8 11 11 12 12 12 13 14 14 16 16 16 16];
%%%%%%%%%%%%  Direction 3   -------------------------------------
test_sample=[87 88 89 9 25 67 65 69 68 70 100 76 167 180 274];
pattern_L=[10 10 10 15 17 18 19 19 20 20 23 24 10 10 22];

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test_sample=[105 39 40 33 36 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 25 99 65 67 68 69 70 93 94 96 76 139 287 289 219 230 100 ];
% pattern_L=  [ 1  2  2  3  4  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 16 19 18 20 19 20 22 22 21 24  7   8   8  16   16  23 ];


% test_sample=[ 1 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218 219 220 221 235 241 250 69 256 257 262 268 269 19 275 281   ];
% pattern_L=  [ 1  2  2  3  4   7  8  8  8  9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16  16  16  16  17  18  19  19 20  20  21  22  22  23 23  24   ];


% test_sample=[ 35 106 107 34 37  134 141 142 143 148 149 167 168 169 159 160  185 186 187 194 202 203 208 209 223 224 225 226 236 244 252 253 258 259 263 270 271 276 277 283   ];
% pattern_L=  [ 1   2   2  3  4   7    8   8   8   9   9  10  10   10  11  11  12  12  12  13  14  14   15 15  16  16  16  16  17  18  19  19  20  20  21  22  22  23  23  24   ];


% test_sample=[ 297 108 109 114 121 134 287 289 44 150 151  173 174 175 161 162  188 189 190 198 204 205 210 211 227 228 229 230 237 246 254 255 260 261 265 272 273 278 279 286   ];
% pattern_L=  [ 1    2   2   3  4    7   8   8   8   9   9  10  10   10  11  11  12  12  12  13  14  14   15 15  16  16  16  16  17  18  19  19  20  20  21  22  22  23  23  24   ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%


% test_sample=[10 ];
% pattern_L=[15 ];

Ntest=size(test_sample,2);



% load pattern_sim.mat
reg=0;reg2=0;Accuracy=[];
nData=size(test_sample,2);
testData = {} ;
testlabel = {} ;
Psc=0;
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
 %-------Add global feature (position information)-----
% sfL=sprintf('D:/HW/SVM_textbookDATA/locL%d.txt',modelnum);
% locL=importdata(sfL);
 for i=1:nData
 sf3=sprintf('./Features/vote%d.txt',test_sample(i));
 F3=importdata(sf3);
 F=[testData{1,i};F3];
 testData{1,i}=F;
%  Lab=[testLabe{1,i};locL];
%  testLabe{1,i} = Lab;
 end
Sc=0;
best_Ymatch_S=[];
testL=[];predict=[];
Sum_score=0;
Psc=0;
MsSet=[];MSet=[];
Err=0;
Er=[];
Correct_Match=0;Total_Match=0;
C=1000;
for Pic=1:nData
% %------------------inference-------------------------------
disp(['Inference by ' num2str(Ntest) ' testing Data..... ']) ;
h = figure( 1 ) ;
set( h , 'Visible' , 'off' );
Ps=[];
Ts=[];
Ms=[];
As=[];

selans=[];SUM_F=[];Score_set=[];
Ym=[];
clf
%%---------------------------------------------------------
% picnum=test_sample(Pic);
% [vote]=shapecontext(picnum);
% test=vote;
%compute argmax y

for modelsel=1:24
    sum=0;W=[];
    filepath='.\model\'; 
    load([filepath 'model' ,num2str(modelsel)]);
    x=testData{1,Pic};
    y=testLabel{1,Pic};
    if size(x,1)~=size(W,1)
        continue;
    end
    [Ymatch,~,~,assignment,match_score,id,pattern_score] = match(x,W,y);
    %%%----global weight--------
%     pattern_score
%     match_score
    score=match_score+C*pattern_score(modelsel);
    Ts=[Ts;score];
    Ms=[Ms;match_score];
%     Ps=[Ps;pattern_score];
    As=[As assignment];
    selans=[selans;modelsel];
    Ym=[Ym Ymatch];
end

%%%%%%%%--------------------------------------------------
[~,index]=sort(Ms,'descend');
[~,ind]=max(Ts);

Modelind=selans(ind);

M=find(Modelind~=selans);
c=1;
while (size(M,1)>=size(selans,1))
    Modelind=id(1+c);
    M=find(Modelind~=selans);
    c=c+1;
end


filepath='.\model\'; 
load([filepath 'model' ,num2str(Modelind)]);
[Ymatch,yGT,Ymatch_Mat,assignment,match_score,~,~,Ltag,acc] = match(x,W,y);
acc;
Sum_score=Sum_score+acc;



% num2str(test_sample(Pic))
disp(['Picture-' num2str(test_sample(Pic)) ' Model select: '  num2str(Modelind)  '(' num2str(pattern_L(Pic)) ')']) ;

[~,patternInd]=max(Ps);
if pattern_L(Pic)==Modelind
    disp(['Pattern recognition' ' ' 'Correct!']) ;
else
    disp(['Pattern recognition'  'Fail!']) ;
end
[~,bestMatchInd]=max(Ms);
% disp(['Match similarty: '  num2str(Ms(bestMatchInd)*100) '%']) ;

All_Score=Ms(bestMatchInd);
% Sum_score=Sum_score+All_Score;
best_assignment=As(:,ind);
best_Ymatch=Ym(:,ind);
predict=[predict Modelind];
% best_Ymatch_S=[best_Ymatch_S;best_Ymatch];
% testL=[testL;y1];

%--------------------------------------------------------
msize=size(best_assignment,1);
Ms=0;
for i=1:msize
    if best_assignment(i)==Ltag(i)
        Ms=Ms+1;
    end
end
MsSet=[MsSet Ms];
MSet=[MSet msize];
best_Ymatch=Ym(:,index(1));

best_assignment
Ltag
if best_assignment==Ltag
    Sc=Sc+1
end
end



for i=1:Ntest
Correct_Match=Correct_Match+MsSet(i);
Total_Match=Total_Match+MSet(i);
end
Match_Level_ACC=Correct_Match/Total_Match;
Avg_accuracy=Sum_score/nData;
Avg_accuracy2=Sc/nData;
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
% disp(['Average Accuracy is: '  num2str(Avg_accuracy*100) '%']) ;
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
ndata=size(predict,2);
%%----------combine the class----------
for i=1:ndata
    if predict(i)==1 || predict(i)==2 || predict(i)==3 || predict(i)==4
        class(i)=1;
    elseif predict(i)==5 || predict(i)==6 || predict(i)==7 || predict(i)==8
        class(i)=2;
    elseif predict(i)==9 || predict(i)==10
        class(i)=3;
    elseif predict(i)==11
        class(i)=4;
     elseif predict(i)==12
        class(i)=5;       
     elseif predict(i)==13 || pattern_L(i)==14
        class(i)=6;
    elseif predict(i)==15
        class(i)=7;
    elseif predict(i)==16
        class(i)=8;
     elseif predict(i)==17
        class(i)=9;
    elseif predict(i)==18 || predict(i)==19 || predict(i)==20
        class(i)=10;
    elseif predict(i)==21 || predict(i)==22
        class(i)=11;
    elseif predict(i)==23 || predict(i)==24
        class(i)=12;
    end
end
for i=1:ndata
    if pattern_L(i)==1 || pattern_L(i)==2 || pattern_L(i)==3 || pattern_L(i)==4
        patL(i)=1;
    elseif pattern_L(i)==5 || pattern_L(i)==6 || pattern_L(i)==7 || pattern_L(i)==8
        patL(i)=2;
    elseif pattern_L(i)==9 || pattern_L(i)==10
        patL(i)=3;
    elseif pattern_L(i)==11
        patL(i)=4;
     elseif pattern_L(i)==12
        patL(i)=5;       
     elseif pattern_L(i)==13 || pattern_L(i)==14
        patL(i)=6;
    elseif pattern_L(i)==15
        patL(i)=7;
    elseif pattern_L(i)==16
        patL(i)=8;
     elseif pattern_L(i)==17
        patL(i)=9;
    elseif pattern_L(i)==18 || pattern_L(i)==19 || pattern_L(i)==20
        patL(i)=10;
    elseif pattern_L(i)==21 || pattern_L(i)==22
        patL(i)=11;
    elseif pattern_L(i)==23 || pattern_L(i)==24
        patL(i)=12;
    end
end
%%%------------------------------------
% confusionmatrix_test = confusionmat(best_Ymatch_S,testL);
[CM, GORDER] = confusionmat(class,patL);
% save patL.mat patL
% save class.mat class
CM

name_class(1,1)={'Template 1'};
name_class(2,1)={'Template 2'};
name_class(3,1)={'Template 3'};
name_class(4,1)={'Template 4'};
name_class(5,1)={'Template 5'};
name_class(6,1)={'Template 6'};
name_class(7,1)={'Template 7'};
name_class(8,1)={'Template 8'};
name_class(9,1)={'Template 9'};
name_class(10,1)={'Template 10'};
name_class(11,1)={'Template 11'};
name_class(12,1)={'Template 12'};

% num_in_class=[10 8 8 6 7 6 4 7 3 9 6 6];
% actual_label=class';
% predict_label=patL';
% num_class=12;
% 
% for i=1:num_class
%     Confusion(i,:)=CM(i,:)/num_in_class(i)*100;
% end 
% 
% 
% draw_cm(Confusion,name_class,num_class);
% saveas( h , [ './result/Confusion/CM'  , '.jpg' ] )


for i=1:nData
    if patL(i)==class(i)
        Psc=Psc+1;
    end
end
Pattern_score=Psc/nData;    
% disp(['Pattern recognition Accuracy is: '  num2str(Pattern_score*100) '%']) 
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;

disp(['PLA is: '  num2str(Avg_accuracy2*100) '%']) ;
disp(['MLA is: '  num2str(Match_Level_ACC*100) '%']) ;
disp(['Pattern recognition Accuracy is: '  num2str(Pattern_score*100) '%']) ;


disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;