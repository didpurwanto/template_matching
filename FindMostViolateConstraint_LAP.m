function [Ymatch,GM_score] = FindMostViolateConstraint_LAP(x,w,y,loss,ybar)
% clc;clear all;
%%--------transform knn matrix into correct side-------------------
xs=size(x,1);
y=y(1:xs);
feaReg=[];fEReg=[];yGT=[];
zw = w(1:xs).* x(1:xs).*ybar(1:xs)+loss;
% zw = x(1:xs).*ybar(1:xs)
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
zT;
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
%%%%%%% LAP %%%%%%%
resolution=0.01;
[rowsol,cost,v,u,costMat] = lapjv(z_,resolution);
assignment=rowsol';
%%%%%%%%%
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
assignment';

% for i=1:objsize
%     draw_arrow(Cobj(i,:),btext(assignment(i),:),.1)
% end
% saveas( h , [ 'ssvm' num2str( picnum ) , '.jpg' ] )

% score = (1-(dot(Ymatch,y)/16)) + sum(w(1)*f1.*Ymatch)+ sum(w(2)*f2.*Ymatch);
Ltag=Ltag';
% size_sort=size(assignment)
% size_Ltag=size(Ltag)
% assignment'
% Ltag'
match_sim=sum(assignment==Ltag)/size(assignment,1);
GM_score=match_sim*100;
% GM_error=1-match_sim;
% disp(['Match similarity is '  num2str(match_sim*100)  '%'  ]) ;
% Gf = x(xs+1:end);
% Gy=y(end-15:end);
% pot=Gy.*Gf.*w(xs+1:end);
% ps=size(pot,1);
% for i=1:ps
%     if pot(i)>0
%         Lm(i)=1;
%     else
%         Lm(i)=0;
%     end
% end
% Lm=Lm';
% WG=w(xs+1:end);
% [Lm]=BinaryIntegerProgramming(Gf,WG);

% n=16; 
% 
% cvx_begin
% 
% variable x(n);
% A=Gf;
% maximize dot(A,x)/16;
% subject to 
% norm(x) <= 1;
% cvx_end
% 
% 
% T=0.2;
% Lm=[];
% sx=size(x,1);
% for i=1:sx
%     if x(i,1)>T
%         Lm(i)=1;
%     else
%         Lm(i)=0;
%     end
% end
% x    
% Lm=Lm'





end