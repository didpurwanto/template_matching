function BD_initialTestRel(test_sample)
%% Test Relative position
% test_sample=[105 40 33 36 26 27 87 88 51 58 59 60  9 10 12 2 25 99 65 68 69 70 93 94 96 76 139 289 219  100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160 67 230 54 89];
Ntest=size(test_sample,2);
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
% [assignment]=grKNN(patterns,Ntest,test_sample);
%% Relative position
for num=1:Ntest
sf=sprintf('./Detection/obj%d.txt',test_sample(num));
st=sprintf('./Detection/text%d.txt',test_sample(num));
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
pic=sprintf('./dataset/%d.jpg',test_sample(num));
a=imread(pic);
% imshow(a)
Cobj=[];Ctext=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
%center of text
Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);

assignment=randperm(objnum);
M=Cobj;
N=[];
for i=1:objnum
t=Ctext(assignment(i),:);
N=[N;t];
end
[ra]=compute_angle(M,N);
rp=ra;

[sizeY,sizeX,~]=size(a);
C(1,1)=0.5*sizeX;
C(1,2)=0.5*sizeY;

%calculate angles
M(:,1)=C(1,1)*ones(objnum,1);
M(:,2)=C(1,2)*ones(objnum,1);
N=Cobj;
[ra]=compute_angle(M,N);

% vote
B=[];
% ra
% rp
B=[ra rp];


for i=1:objnum
    bin(i)=(B(i,1)-1)*8+B(i,2);
end
dim=8*8;
vTest=zeros(1,dim);
for i=1
    numb=1;
for x=1:dim
    for j=1:textnum
        if bin(1,j)==numb
            t=numb;
            vTest(i,t)=vTest(i,t)+1;
        end
    end
    numb=numb+1;
end
end


%%%%------save postion vote----------
m=1;
B=[];
site=sprintf('./Features/testRel%d.txt',test_sample(num));
for i=1:objnum*2
B=vTest;
fid = fopen(site, 'w');
fprintf(fid, '%f \n', B );
fclose(fid);
end

end

end