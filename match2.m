function [Ymatch,yGT,Ymatch_Mat,assignment,match_score,msize,match] = match2(x,w,y)
% clc;clear all;
%%--------transform knn matrix into correct side-------------------
feaReg=[];fEReg=[];yGT=[];
X=x(1:size(x));
W=w(1:size(x));
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
[assignment, cost] = assignmentoptimal(z_);
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




Ltag=Ltag';
% size_sort=size(assignment)
% size_Ltag=size(Ltag)
% assignment'
% Ltag'
match_score=sum(assignment==Ltag)/size(assignment,1);
msize=size(assignment,1);
match=0;
for i=1:msize
    if assignment(i)==Ltag(i)
        match=match+1;
    end
end

% disp(['Match similarity is '  num2str(match_sim*100)  '%'  ]) ;


%--------------------------------------------

end