% function cross
% clear all;
tic
PLA_set=[];
MLA_set=[];

for Kf=1:4
%%%~~~K=1~~~~~
if Kf==1
model1=[1 35 101 102 103 104 296 297 298 299 300];
model2=[31 32 106 107 108 109];
model3=[34 110 111 112 113 114 115 116 117 118 119];
model4=[36 37 120 121 122 123];
model5=[124 125 126 127 128];
model6=[129 130 131 132 133];
model7=[42 43 134 136 137 138 139 140];
model8=[44 46 50 141 142 143];
model9=[3 4 144 145 146 147 148 149 150 151 152 153];
model10=[84 85 86 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184];
model11=[154 155 156 157 158 159 160 161 162 163 164 165 166];
model12=[5 6 52 185 186 187 188 189 190 191 192 193];
model13=[55 58 194 195 196 197 198 199];  
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
%%%-------Testing Data-------
%%%~~~Input the testing data number you want~~~~~
test_sample=[105 40 33 36 26 27 87 88 51 58 59 60  9 10 12 2 25 99 65 68 69 70 93 94 96 76 139 289 219  100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160 67 230 54 89];
pattern_L=  [1   2  3  4  11 11 10 10 12 13 14 14 15 15 16 17 17 16 19 20 19 20 22 22 21 24  7  8 16 23 12 15 2  2  3  4   7  8  8  8  9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16   16  16  17  18  19  20  20  21  22  22  23 23  24 11 11 18 16 12 10];
end
%%%~~~K=2~~~~~
if Kf==2
model1=[105 35 101 102 103 104 296 297 298 299 300];
model2=[39 40 106 107 108 109];
model3=[33 110 111 112 113 114 115 116 117 118 119];
model4=[36 120 121 122 123];
model5=[124 125 126 127 128];
model6=[129 130 131 132 133];
model7=[43 134 136 137 138 139 140];
model8=[49 287 289 141 142 143];
model9=[3 146 147 148 149 150 151 152 153];
model10=[87 88 89 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184];
model11=[26 27 156 157 158 159 160 161 162 163 164 165 166];
model12=[53 51 185 186 187 188 189 190 191 192 193];
model13=[58 55 194 195 196 197 198 199];  
model14=[59 60 202 203 204 205];
model15=[9 10 208 209 210 211 212 213 214 215 216 217];
model16=[12 99 230 222 223 224 225 226 227 228 229 230 231 232 233 234];
model17=[25 236 237 238 239 240];
model18=[67 242 243 244 245 246 247 248 249];
model19=[65 251 252 253 254 255];
model20=[68 70 258 259 260 261];
model21=[263 264 265 266 267];
model22=[93 94 270 271 272 273 274];
model23=[18 100 276 277 278 279 280];
model24=[71 75 282 283 284 285 286];
%%%-------Testing Data-------
%%%~~~Input the testing data number you want~~~~~
test_sample=[ 1  32 37  42 44  144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218 219 220 221 235 241 250 69 256 257 262 268 269 19 275 281 40 54 4  8  11 16 24  39  53 56 57 71 72 83 90 91 101 102 113 118  130 131 132 136 140  183 184 191 192 222 231 232 233 234 239 242 243];
pattern_L=  [ 1   2  4   7  8   9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16  16  16  16  17  18  19  19 20  20  21  22  22  23 23  24  2  12 9 15  16 21 17  2   12 12 12 24 24 17 22 22  1   1   3   3    6   6   6   7   7   10  10  12  12  16 16  16  16   16  17  18 18];
end
%%%~~~K=3~~~~~
if Kf==3
model1=[35 105 1 101 102 103 104 296 297 298 299 300];
model2=[39 40 31 32 108 109];
model3=[33 110 111 112 113 114 115 116 117 118 119];
model4=[36 120 121 122 123];
model5=[124 125 126 127 128];
model6=[129 130 131 132 133];
model7=[43 42 136 137 138 139 140];
model8=[49 287 289 44 46 50];
model9=[4 144 145 146 147 150 151 152 153];
model10=[84 85 86 87 88 89 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184];
model11=[26 27 156 157 158 154 155 161 162 163 164 165 166];
model12=[51 53 51 5 6  52 185 186 187 188 189 190 191 192 193];
model13=[58 55 195 196 197 198 199];  
model14=[59 60 200 201 204 205];
model15=[9 10 206 207 210 211 212 213 214 215 216 217];
model16=[12 99 230 222 218 219 220 221 227 228 229 230 231 232 233 234];
model17=[24 25 235 237 238 239 240];
model18=[67 242 243 241 245 246 247 248 249];
model19=[65 251 250 69 254 255];
model20=[68 70 256 257 260 261];
model21=[262 264 265 266 267];
model22=[93 94 268 269  272 273 274];
model23=[18 100 19 275 278 279 280];
model24=[71 75 282 281 284 285 286];
%%%-------Testing Data-------
%%%~~~Input the testing data number you want~~~~~
test_sample=[ 106 107 37  134 141 142 143 148 149 167 168 169 154 185 186 187 194 202 203 208 209 223 224 225 226 236 244 252 253 258 259 263 270 271 276 277 283 40 3 15 17 18  22 29  61 62 75 77 78 92 97 116 117 122 123 126 127 128 129  158  164 172 179 180 181 182 193 197 199 214 215 216];
pattern_L=  [  2   2  4   7    8   8   8   9   9  10  10   10  11 12  12  12  13  14  14   15 15  16  16  16  16  17  18  19  19  20  20  21  22  22  23  23  24  2  9 18 21 23  16 17  19 20 24 24 23 22 21  3   3   4   4   5   5   5    6   11   11  10  10  10  10  10  12  13  13  15  15  15];
end
%%%~~~K=4~~~~~
if Kf==4
model1=[105 1 101 102 103 104 296 35 298 299 300];
model2=[39 40 31 32 106 107];
model3=[33 110 111 112 113 34 115 116 117 118 119];
model4=[36 120 37 122 123];
model5=[124 125 126 127 128];
model6=[129 130 131 132 133];
model7=[43 42 136 137 138 139 140];
model8=[49 141 142 143 46 50];
model9=[3 4 144 145 146 147 148 149 152 153];
model10=[84 85 86 87 88 89 170 171 172 167 168 169 176 177 178 179 180 181 182 183 184];
model11=[26 27 156 157 158 154 155 159 160 163 164 165 166];
model12=[51 53 51 5 6  52 185 186 187  191 192 193];
model13=[58 194 195 196 197 198 199];  
model14=[59 60 200 201 202 203];
model15=[9 10 206 207 208 209 212 213 214 215 216 217];
model16=[12 99 230 222 218 219 220 221 223 224 225 226 231 232 233 234];
model17=[24 25 235 236 238 239 240];
model18=[67 242 243 241 244 245 247 248 249];
model19=[65 251 250 69 252 253];
model20=[68 70 256 257 258 259];
model21=[262 263 264 266 267];
model22=[93 94 268 269  270 271 274];
model23=[18 100 19 275 276 277 280];
model24=[71 75 282 281 283 284 285];
%%%-------Testing Data-------
%%%~~~Input the testing data number you want~~~~~
test_sample=[ 297 108 109 114  44 150 151  173 174 175 161 162  188 189 190 198 204 205 210 211 227 228 229 230 237 246 254 255 260 261 265 272 273 278 279 286 13 14 20 23 30 45 47 48 63 64 66 73 79 80 103 111 112 115 120 124 125  139 156 157  166 170 171 176 177 178 195 196 212 213 217 238];
pattern_L=  [ 1    2   2   3   8   9   9  10  10   10  11  11  12  12  12  13  14  14   15 15  16  16  16  16  17  18  19  19  20  20  21  22  22  23  23  24   18 18 17 16 17 6  8   6 18 19 20 11 23 24  1   3   3   3   4   5   5    7   11  11   11  10  10 10   10  10  13  13  15  15 15  17];
end
Ntest=size(test_sample,2);

trainLabel=[];
for i=1:24
    A(1:size(eval(['model' num2str(i)]),2))=i;
    trainLabel=[trainLabel A];
    A=0;
end

%% Learning graph matching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % During training, the program will sometimes report warnings that the slack of the most violated constraint is smaller than the slack of the working set. 
% % This is due to SVMstruct using approximate inference during constraint generation and is expected behavior.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
traindata=[model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 model14 model15 model16 model17 model18 model19 model20 model21 model22 model23 model24];

for modelnum=1:24
    train_sample=eval(['model',num2str(modelnum)]);
    ssvm_train(train_sample,modelnum);
end

Train_multiclassSVM(traindata,trainLabel);




%% Iter-Inference
BD_initialTestRel(test_sample);
Template_Match(test_sample,pattern_L)
[Assignment,PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
Assignment_reg=Assignment;
Pr = load('./Data/predictions');
Pm = Pr(:,1);
Predicts_reg = Pm;
A=[];
for iter=1:5
    Template_Match(test_sample,pattern_L);
    Pr = load('./Data/predictions');
    Pm = Pr(:,1);
    [Assignment,PLA,MLA,CM,Lt]=infer_matching(test_sample,pattern_L);
    A=[A MLA];
    for i=1:Ntest
        if Assignment_reg{i,1}~=Assignment{i,1}
            Assignment_reg=Assignment;
        end
    end
    
    if Predicts_reg~=Pm 
        Predicts_reg = Pm;
    else
        break;
    end
end

for i=1:Ntest
    if sum(Assignment{i,1}==Lt{i,1})~=size(Assignment{i,1},2)
        ERR=test_sample(i);
    end
end

Confusion_matrix=CM;
Conf(Kf,1)={Confusion_matrix};

PLA_set=[PLA_set PLA];
MLA_set=[MLA_set MLA];
% [PLA,MLA,CM]=infer_matching(test_sample,pattern_L);


%     %% ---------------show image result----------------------
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

end

%% Show result
h = figure( 1 ) ;
SumPLAF=0;
SumMLAF=0;
    disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
for i=1:4
    PLA=PLA_set(1,i);
    MLA=MLA_set(1,i);
    disp(['K= ' num2str(i) ' Page level accuracy (PLA): '  num2str(PLA) '%']) ;
    disp(['K= ' num2str(i) ' Match level accuracy (MLA): '  num2str(MLA) '%']) ;
    disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
    SumPLAF=SumPLAF+PLA_set(1,i);
    SumMLAF=SumMLAF+MLA_set(1,i);
end
PLAF=SumPLAF/4;
MLAF=SumMLAF/4;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['Final Average accuracy: ']) ;
disp(['Page level average accuracy (PLA): '  num2str(PLAF) '%']) ;
disp(['Match level average accuracy (MLA): '  num2str(MLAF) '%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;

%----Confusuin Matrix
num_class=12;
Row=0;Confsum=zeros(num_class,num_class);
for i=1:4
Confusion_matrix=Conf{i,1};
for i=1:num_class
    for j=1:num_class
        Row=Row+Confusion_matrix(i,j);
    end
    num_in_class(1,i)=Row;
    Row=0;
end

for i=1:num_class
    confusion_matrix(i,:)=Confusion_matrix(i,:)/num_in_class(i)*100;
end
confusion_matrix;
Confsum=Confsum+confusion_matrix;
end
confusion_matrix=Confsum/4;
name_class(1,1) = {'Template 1'};
name_class(2,1) = {'Template 2'};
name_class(3,1) = {'Template 3'};
name_class(4,1) = {'Template 4'};
name_class(5,1) = {'Template 5'};
name_class(6,1) = {'Template 6'};
name_class(7,1) = {'Template 7'};
name_class(8,1) = {'Template 8'};
name_class(9,1) = {'Template 9'};
name_class(10,1) = {'Template 10'};
name_class(11,1) = {'Template 11'};
name_class(12,1) = {'Template 12'};
confusion_matrix=roundn(confusion_matrix,-2)
draw_cm(confusion_matrix,name_class,num_class)
saveas( h , [ './result/confusion_matrix/CM'  , '.jpg' ] )
toc
