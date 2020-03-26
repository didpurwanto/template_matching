% chi-square distance
% function testsample
% clc
% clear all
function [modelID]=PatternReg(test_sample,pattern_L)
%% ---------------Training Label pattern--------------------
model1=[1 35 101 102 103 104 105 296 297 298 299 300];
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
Ps=0;
model=[];
%% 
% test_sample=[39 40 26 27 49 87 88 89 51 53 54 58 59 60 9  10 12 25 99 65 67 68 69 70 93 94 96 76 80 105 139 287 289 219 230];
% pattern_L=  [2  2  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 16 19 18 20 19 20 22 22 21 24 24  1   7   8   8  16   16];
% test_sample=[39 40];
nData=size(test_sample,2);modelselect=[];pattern_sim=[];selans=[];
for picnum=1:300
    [vote]=shapecontext(picnum);
    l(picnum,:)=vote;
    disp(['Computing global feature..... ' num2str(picnum/300*100) '%']) ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:nData
sf1=sprintf('./Features/knn%d.txt',test_sample(i));
sf2=sprintf('./Features/geo%d.txt',test_sample(i));
L=sprintf('./Labels/L%d.txt',test_sample(i));
F1=importdata(sf1);
F2=importdata(sf2);
L=importdata(L);
Feature=[F1;F2];
Label=[L;L];
 testData{1,i} =  Feature ;
 testLabel{1,i}   = Label ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pic=1:nData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for modelsel=1:24
    W=[];
    load(['./model/model' ,num2str(modelsel)]);
    x=testData{1,pic};
    y=testLabel{1,pic};
    if size(x,1)~=size(W,1)
        continue;
    end
    selans=[selans;modelsel];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
picnum=test_sample(pic);
[vote]=shapecontext(picnum);
test=vote;
Avg=[];A=[];
model_num=size(selans);
for i=1:model_num
    k=1;
    M=eval(['model' num2str(selans(i))]);
    num=size(M,2);
    for j=1:num
    if M(j)~=test_sample(pic)
        d=sum(((test(1,:)-l(M(j),:)).^2)/(576));
    end
    if i==test_sample(pic)
        d=1000;
    end
    A(k,1)=d;
    k=k+1;
    end
    meanA=mean(A);
    Avg=[Avg;meanA];
end
[~,id]=min(Avg);
model=[model selans(id)];


% pattern_sim=[pattern_sim;sim];
end



ndata=size(model,2);
for i=1:ndata
    if model(i)==1 || model(i)==2 || model(i)==3 || model(i)==4
        class(i)=1;
    elseif model(i)==5 || model(i)==6 || model(i)==7 || model(i)==8
        class(i)=2;
    elseif model(i)==9 || model(i)==10
        class(i)=3;
    elseif model(i)==11
        class(i)=4;
     elseif model(i)==12
        class(i)=5;       
     elseif model(i)==13 || model(i)==14
        class(i)=6;
    elseif model(i)==15
        class(i)=7;
     elseif model(i)==16
        class(i)=8;
     elseif model(i)==17
        class(i)=9;
    elseif model(i)==18 || model(i)==19 || model(i)==20
        class(i)=10;
    elseif model(i)==21 || model(i)==22
        class(i)=11;
    elseif model(i)==23 || model(i)==24
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
[CM, GORDER] = confusionmat(class,patL);
Confusion_matrix=CM;
modelID=model;
for i=1:nData
    if patL(i)==class(i)
        Ps=Ps+1;
    end
end
Pattern_score=Ps/nData;
end