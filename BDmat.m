function BDmat(train,test,label)
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
model13=[55 194 195 196 197 198 199];  
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
% 
M=[model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 model11 model12 model13 model14 model15 model16 model17 model18 model19 model20 model21 model22 model23 model24];
% M=train;
nData=size(M,2);
F=[];
for i=1:nData
 sf3=sprintf('./Features/2Lvote%d.txt',M(i));
 sf4=sprintf('./Features/Rel%d.txt',M(i));
 F3=importdata(sf3);
 F4=importdata(sf4);
 F3=F3';F4=F4';
 Fcom=[F3 F4];
 F=[F;Fcom];
end
% save trainF.mat F

% [A,B]=size(F);
% site=sprintf('./Features/trainData.txt');
% fid = fopen(site, 'wt');
% for i=1:A
% fprintf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', F(i,:) );
% end
% fclose(fid);
% 
% 
Label=[];
for i=1:24
    A(1:size(eval(['model' num2str(i)]),2))=i;
    Label=[Label A];
    A=0;
end
% save trainL.mat Label
% 
% site=sprintf('./Features/trainLabel.txt');
% fid = fopen(site, 'w');
% fprintf(fid, '%d \n', Label );
% fclose(fid);
% 

% 
% 
% 
% 
%% Test Data

Fts=[];
test_sample=[105 40 33 36 26 27 87 88 51 58 59 60  9 10 12 2 25 99 65 68 69 70 93 94 96 76 139 289 219  100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160 67 230 54 89];
% test_sample=test;
nData=size(test_sample,2);
for i=1:nData
 sf3=sprintf('./Features/2Lvote%d.txt',test_sample(i));
 sf4=sprintf('./Features/testRel%d.txt',test_sample(i));
 Ft1=importdata(sf3);
 Ft2=importdata(sf4);
 Ft1=Ft1';Ft2=Ft2';
 Ftcom=[Ft1 Ft2];
 Fts=[Fts;Ftcom];
end
% save testF.mat Fts
% 
% [A,B]=size(Fts);
% site=sprintf('./Features/testData.txt');
% fid = fopen(site, 'wt');
% for i=1:A
% fprintf(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \n', Fts(i,:) );
% end
% fclose(fid);
% 
% L=label;
% % test_sample=[105 40 33 36 26 27 87 88 51 58 59 60  9 10 12 2 25 99 65 68 69 70 93 94 96 76 139 289 219  100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160 67 230 54 89];
L=  [1   2  3  4  11 11 10 10 12 13 14 14 15 15 16 17 17 16 19 20 19 20 22 22 21 24  7  8 16 23 12 15 2  2  3  4   7  8  8  8  9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16   16  16  17  18  19  20  20  21  22  22  23 23  24 11 11 18 16 12 10];
% % L=[ 1  2  2  3  4  11 11 8  10 10 10 12 12 12 13 14 14 15 15 16 17 17 16 19 18 20 19 20 22 22 21 24  7   8   8  16   16  23 12 15];
% site=sprintf('./Features/testLabel.txt');
% fid = fopen(site, 'w');
% fprintf(fid, '%d \n', L );
% fclose(fid);
% 
% save testL.mat L
% 
% 
% 
%% Train
x = F;
y = Label;
fid1 = fopen('./Data/TrainData.txt','w');
for i = 1:size(x,1)
    fprintf(fid1,'%i ',y(1,i));
    for l = 1:size(x,2)
        fprintf(fid1,'%i:%d ',l,x(i,l));                
    end
    fprintf(fid1,'\n');
end
fclose(fid1);

%% Test
x2 = Fts;
y2 = L;

fid2 = fopen('./Data/TestData.txt','w');
for i = 1:size(x2,1)
    fprintf(fid2,'%i ',y2(i));
    for l = 1:size(x2,2)
        fprintf(fid2,'%i:%d ',l,x2(i,l));                
    end
    fprintf(fid2,'\n');
end
fclose(fid2);



% end
















