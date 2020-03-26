clear all;clc;
ACC_cross=[];
Cset=[];
Scaleset=[];
Tolset=[];
model1=[1 35 101 102 103 104 296 297 298 299 300];
model2=[31 32 106 107 108 109];
model3=[33 34 110 111 112 113 114 115 116 117 118 119];
model4=[36 37 120 121 122 123];
model5=[124 125 126 127 128];
model6=[129 130 131 132 133];
model7=[42 43 134 136 137 138 139 140];
model8=[44 46 50 141 142 143];
model9=[3 4 144 145 146 147 148 149 150 151 152 153];
model10=[84 85 86 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184];
model11=[154 155 156 157 158 159 160 161 162 163 164 165 166];
model12=[5 6 52 185 186 187 188 189 190 191 192 193];
model13=[55 57 194 195 196 197 198 199];  
model14=[200 201 202 203 204 205];
model15=[206 207 208 209 210 211 212 213 214 215 216 217];
model16=[218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234];
model17=[235 236 237 238 239 240];
model18=[241 242 243 244 245 246 247 248 249];
model19=[250 251 252 253 254 255];
model20=[256 257 258 259 260 261];
model21=[262 263 264 265 266 267];
model22=[268 269 270 271 272 273 274];
model23=[18 19 275 276 277 278 279 280];
model24=[281 282 283 284 285 286];

test_sample=[105 39 40 33 36 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 25 99 65 67 68 69 70 93 94 96 76 139 287 289 219 230 100 ];
pattern_L=  [ 1  2  2  3  4  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 16 19 18 20 19 20 22 22 21 24  7   8   8  16   16  23 ];
Ntest=size(test_sample,2);
for i=1
% Ci=[0.01 0.1 1 10 100 1000 10000 100000 1000000];
% C=Ci(Cnum);
% T=[0.001 0.01 0.1 1 10 100];
% Tol=T(Tnum);
for modelnum=1:24
    train_sample=eval(['model',num2str(modelnum)]);
    ssvm_train_cross(train_sample,modelnum);
end

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
Err=0;
Er=[];
Psc=0;
MsSet=[];MSet=[];
Correct_Match=0;Total_Match=0;
for Pic=1:nData
disp(['Inference by ' num2str(Ntest) 'testing Data..... ']) ;
h = figure( 1 ) ;
set( h , 'Visible' , 'off' );
Ps=[]; %initial Pattern score
Ts=[]; %initial Total score
Ms=[]; %initial Matching score
As=[]; selans=[];SUM_F=[];Score_set=[];
Ym=[]; %Y matching result
clf
%%---------------------------------------------------------
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
    [Ymatch,yGT,Ymatch_Mat,assignment,match_score,pattern_score,Ltag] = match(x,W,y,pattern_L(Pic));
    %%%----global weight--------
%     SUM=sumWYF1+sumWYF2;
%     SUM=SUM;
%     SUM_F=[SUM_F;SUM];
    score=pattern_score+match_score;
    Ts=[Ts;score];
    Ms=[Ms;match_score];
    Ps=[Ps;pattern_score];
    As=[As assignment];
    selans=[selans;modelsel];
    Ym=[Ym Ymatch];
end

[~,index]=sort(Ms,'descend');
[~,Modelind]=max(Ts);
% num2str(test_sample(Pic))
disp(['Picture-' num2str(test_sample(Pic)) ' Model select: '  num2str(selans(Modelind))  '(' num2str(pattern_L(Pic)) ')']) ;

[~,patternInd]=max(Ps);
if pattern_L(Pic)==selans(Modelind)
    disp(['Pattern recognition' ' ' 'Correct!']) ;
else
    disp(['Pattern recognition'  'Fail!']) ;
end
[~,bestMatchInd]=max(Ms);
disp(['Match similarty: '  num2str(Ms(bestMatchInd)*100) '%']) ;

All_Score=Ms(bestMatchInd);
Sum_score=Sum_score+All_Score;
best_assignment=As(:,index(1));
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
predict=[predict selans(Modelind)];
Error=1-All_Score;
Err=Err+Error;
Er=[Er Error];
if All_Score==1
    Sc=Sc+1;
end

end

for i=1:Ntest
Correct_Match=Correct_Match+MsSet(i);
Total_Match=Total_Match+MSet(i);
end
Match_Level_ACC=Correct_Match/Total_Match;
Stdev=std(Er)/sqrt(length(Er));
mE=Err/nData;
Avg_accuracy1=Sum_score/nData;
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
     elseif predict(i)==13
        class(i)=6;
    elseif predict(i)==14
        class(i)=7;
    elseif predict(i)==15
        class(i)=8;
     elseif predict(i)==16
        class(i)=9;
    elseif predict(i)==17
        class(i)=10;    
    elseif predict(i)==18 || predict(i)==19 || predict(i)==20
        class(i)=11;
    elseif predict(i)==21 || predict(i)==22
        class(i)=12;
    elseif predict(i)==23 || predict(i)==24
        class(i)=13;
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
     elseif pattern_L(i)==13
        patL(i)=6;
    elseif pattern_L(i)==14
        patL(i)=7;
    elseif pattern_L(i)==15
        patL(i)=8;
    elseif pattern_L(i)==16
        patL(i)=9;
    elseif pattern_L(i)==17
        patL(i)=10;
    elseif pattern_L(i)==18 || pattern_L(i)==19 || pattern_L(i)==20
        patL(i)=11;
    elseif pattern_L(i)==21 || pattern_L(i)==22
        patL(i)=12;
    elseif pattern_L(i)==23 || pattern_L(i)==24
        patL(i)=13;
    end
end
%%%------------------------------------
% confusionmatrix_test = confusionmat(best_Ymatch_S,testL);
[CM, GORDER] = confusionmat(patL, class);
Confusion_matrix=CM;
for i=1:nData
    if patL(i)==class(i)
        Psc=Psc+1;
    end
end
Pattern_score=Psc/nData;
Avg_accuracy2=Sc/nData;

% save loss1.mat loss
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['------------ Our approach result: --------------']) ;
disp(['Mean error is ' num2str(mE*100) '%']) ;
disp(['Average Accuracy is: '  num2str(Avg_accuracy2*100) '%']) ;
disp(['Pattern recognition Accuracy is: '  num2str(Pattern_score*100) '%']) ;
disp(['Average Accuracy2 is: '  num2str(Match_Level_ACC*100) '%']) ;
disp(['Standard error is ' num2str(Stdev*100) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
ACC_cross=[ACC_cross;Avg_accuracy2];
% Cset=[Cset;Cp];
% Scaleset=[Scaleset;Scale];
% Tolset=[Tolset;Tol];


end
