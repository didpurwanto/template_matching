clc
clear all
load z1
load z2
node_num=sqrt(size(z1,1));
%arrange the knn index
for i=1:size(z1,1)
    N(i,1)=(z1(i,1)-min(z1))/(max(z1)-min(z1));
end
z1=N;
I=1;
tn=node_num;
for j=1:node_num
    t=1;
    for i=((tn*I)-tn)+1:tn*I
        knnSc(j,t)=z1(i,1);
        t=t+1;
    end
    I=I+1;
end
%%%%%%%%%%%%%%%%
for i=1:size(z2,1)
    N2(i,1)=(z2(i,1)-min(z2))/(max(z2)-min(z2));
end
z2=N2;
I=1;
for j=1:node_num
    t=1;
    for i=((tn*I)-tn)+1:tn*I
        shapeSc(j,t)=z2(i,1);
        t=t+1;
    end
    I=I+1;
end
A=knnSc+shapeSc;

B=exp(-A);
[assignment, cost] = assignmentoptimal(B);
assignment'

% tag=[];
% for i=1:node_num
%     [~,ind]=max(A(i,:));
%     tag=[tag ind];
% end


l=sprintf('./Labels/L%d.txt',46);
y=importdata(l);
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
Ltag
%-----------------------------------------------