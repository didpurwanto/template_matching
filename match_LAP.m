function [assignment,Ltag,acc] = match_LAP(x,w,y)
% clc;clear all;
%%--------transform knn matrix into correct side-------------------
feaReg=[];fEReg=[];yGT=[];
X=x(1:size(x));
W=w(1:size(x));
match_score=sum(W.*X);
% ObjFun= w.* x;
% [A1,A2]=getNEfeatures(ObjFun);
% sumWYF1=sum(A1);
% sumWYF2=sum(A2);
zw = W.* X;
[z1,z2]=getNEfeatures(zw);
z=z1+z2;
c2=1;
node_num=sqrt(size(z,1));
zT=zeros(node_num,node_num);
yGT=zeros(node_num,node_num);
for j=1:node_num
    t=1;
    for i=((node_num*c2)-node_num)+1:node_num*c2
        zT(j,t)=z(i,1);
        yGT(j,t)=y(i,1);
        t=t+1;
    end
    c2=c2+1;
end
%%%%%------GT to check performance-----------
%------------y Label assignment-------------
Ltag=[];Y=1;
for c3=1:node_num
    for j=((node_num*c3)-node_num)+1:node_num*c3
        if y(j)==1
            Ltag(Y)=rem(j,node_num);
            if rem(j,node_num)==0
                Ltag(Y)=node_num;
            end
                Y=Y+1;
        end
    end
end
%-----------------------------------------------
str=size(zT,1);
for i=1:str
    for j=1:str
        z_(i,j)=exp(-zT(i,j));
    end
end

assignment=[]; 
Rand_assignment=[];
resolution=0.02;
[rowsol,cost,v,u,costMat] = lapjv(z_,resolution);
assignment=rowsol;
Rand_assignment=randperm(node_num);
Ymatch_Mat=zeros(node_num,node_num);
for i=1:node_num
    Ymatch_Mat(i,assignment(i))=1;
    Y_rand_Mat(i,Rand_assignment(i))=1;
end
q=1;
for i=1:node_num
    for j=1:node_num
        Ymatch(q,1)=Ymatch_Mat(i,j);
        Y_rand(q,1)=Y_rand_Mat(i,j);
        q=q+1;
    end
end
% Ltag
% assignment'

% for i=1:objsize
%     draw_arrow(Cobj(i,:),btext(assignment(i),:),.1)
% end
% saveas( h , [ 'ssvm' num2str( picnum ) , '.jpg' ] )

% score = (1-(dot(Ymatch,y)/16)) + sum(w(1)*f1.*Ymatch)+ sum(w(2)*f2.*Ymatch);
% Ltag=Ltag';
% size_sort=size(assignment)
% size_Ltag=size(Ltag)
% assignment'
% Ltag'
acc=sum(assignment==Ltag)/size(assignment,2);
% disp(['Match similarity is '  num2str(match_sim*100)  '%'  ]) ;


%--------------------------------------------
%---------global pattern score----------
% fG=x(end-15:end);
% wG=w(end-15:end);
% 
% sl=sum(fG);
% Loc_test=fG/sl;
% wG;
% 
% Ps=0;Set=[];
% for modelsel=1:24
%     load(['Loc' ,num2str(modelsel)]);
%     for i=1:16
%         Scr=abs((Loc_test(i)-Loc(i)));
%         Ps=Ps+Scr;
%     end
%     Set=[Set Ps];
%     Ps=0;
% end
% 
% 
% Set=exp(-Set);
% pattern_score=Set;
% [~,id]=sort(Set,'descend');
% 
% assignment=assignment';
% Ltag=Ltag';





end