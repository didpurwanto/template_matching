% clc;clear all;
function [Assignment,PLA,MLA,CM,Lt]=infer_matching_LAP(test_sample,pattern_L)


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

Sc=0;
best_Ymatch_S=[];
testL=[];predict=[];
Sum_score=0;
Psc=0;
MsSet=[];MSet=[];
Err=0;
Er=[];
Correct_Match=0;Total_Match=0;
C=10;
Pr = load('./Data/predictions');
pattern_score=Pr(:,2:25);
for Pic=1:nData
% %------------------inference-------------------------------
% disp(['Inference by ' num2str(Ntest) ' testing Data..... ']) ;
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
pred=Pr(Pic,1);
ps=Pr(Pic,2:25);
ans=[];
for i=1:a
    if sum(pred==selans)==1
        ans=pred;
    else
        mods=size(selans);
        for j=1:mods
            s=ps(1,selans(j));
            Score=[Score s];
        end
        [~,ind]=max(Score);
        ans=selans(ind,1);
    end
end



% load([filepath 'model' ,num2str(Modelind)]);
load(['./model/model' ,num2str(ans)]);
[assignment,Ltag,acc] = match_LAP(x,W,y);
Sum_score=Sum_score+acc;
assignment=assignment';
%-------
% Update the relative location
UpdateRel(assignment,Pic,test_sample);
%-------
Modelind=ans;
% num2str(test_sample(Pic))
% disp(['Picture-' num2str(test_sample(Pic)) ' Template select: '  num2str(Modelind)  '(' num2str(pattern_L(Pic)) ')']) ;
disp(['Picture-' num2str(test_sample(Pic))]) ;
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
best_assignment=assignment;
% best_Ymatch=Ym(:,ind);
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
% best_Ymatch=Ym(:,index(1));

best_assignment;
Ltag=Ltag';
if best_assignment==Ltag
    Sc=Sc+1;
end


Assignment(Pic,1)={assignment};
Lt(Pic,1)={Ltag};



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
     elseif predict(i)==13 || predict(i)==14
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
CM;



for i=1:nData
    if patL(i)==class(i)
        Psc=Psc+1;
    end
end
Pattern_score=Psc/nData;    
PLA=Avg_accuracy2*100;
MLA=Match_Level_ACC*100;

% disp(['Pattern recognition Accuracy is: '  num2str(Pattern_score*100) '%']) 
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
% 
% disp(['PLA is: '  num2str(Avg_accuracy2*100) '%']) ;
% disp(['MLA is: '  num2str(Match_Level_ACC*100) '%']) ;
% disp(['Pattern recognition Accuracy is: '  num2str(Pattern_score*100) '%']) ;
% 
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;


end