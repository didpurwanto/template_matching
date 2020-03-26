function [Yset]=greedymethod(patterns,nData)
%%------find possible matching matrix {y}------------------
Yset=[];
 for num=1:nData
x=patterns{1,num};
nodenum = sqrt(size(x,1)/2);
NN=x(1:size(x,1)/2);
Shape=x(size(x,1)/2+1:size(x,1));
c2=1;
on=nodenum;
zmat=zeros(nodenum,on);

z=0.3*NN+0.8*Shape;
for j=1:nodenum
    t=1;
    for i=((on*c2)-on)+1:on*c2
        zmat(j,t)=z(i,1);
        t=t+1;
    end
    c2=c2+1;
end
yReg=zeros(nodenum,on);
assignment=[];
z_index=[];
for i=1:nodenum
    [~,I]=max(zmat(i,:));
    yReg(i,I)=1;
    assignment=[assignment I];
    [~,pos]=sort(zmat(i,:));
    z_index=[z_index;pos];
end

% %------------revise-----------
[v,index]=sort(assignment);
x=1;y=1;F=1;
for i=1:nodenum-1
    if v(i)==v(i+1)
        x=i;
        P(F)=index(x);
        F=F+1;
        y=i+1;
        P(F)=index(y);
        F=F+1;
    end
end
x=1;
need=[];
for i=1:nodenum
    c=0;
    for j=1:nodenum
        if assignment(j)~=i
            c=c+1;
        end
    end
    if c==nodenum
        need(x)=i;
        x=x+1;
        c=0;
    end
end


if y>1
[~,sizeP]=size(P);
end
% P
% Ltag
cont=0;
n=1;
for i=1:nodenum
    for j=1:nodenum
        if v(j)~=i
            cont=cont+1;
        end
    end
    if cont==nodenum
        R=i;
        for a=1:sizeP
            if P(a)==R
%                 Ltag(i)=i;
            end
        end
    end
    cont=0;
end
x=1;
need=[];
for i=1:nodenum
    c=0;
    for j=1:nodenum
        if assignment(j)~=i
            c=c+1;
        end
    end
    if c==nodenum
        need(x)=i;
        x=x+1;
        c=0;
    end
end
[~,det]=size(need);


% assignment
% score

for iter=1:100
    if det>=1
        [~,sn]=size(need);
        [~,sp]=size(P);
        score=zeros(sp,sn);
        for i=1:sp
            for j=1:nodenum
                for k=1:sn
                    if z_index(P(i),j)==need(k)
                        score(i,k)=zmat(P(i),need(k));
                    end
                end
            end
        end
        [~,indexScore]=sort(score,'descend');
        for i=1:sn  
            for j=1:sp
                assignment(1,P(1,indexScore(1,i)))=need(i);
            end
        end

        %update P
        [v,index]=sort(assignment);
        x=1;y=1;F=1;P=[];
        for i=1:nodenum-1
            if v(i)==v(i+1)
            x=i;
            P(F)=index(x);
            F=F+1;
            y=i+1;
            P(F)=index(y);
            F=F+1;
            end
        end
        
        %Update need
        x=1;
        need=[];
        for i=1:nodenum
        c=0;
            for j=1:nodenum
                if assignment(j)~=i
                c=c+1;
                end
            end
            if c==nodenum
            need(x)=i;
            x=x+1;
            c=0;
            end
        end
       [~,det]=size(need);
    end
end

%%---assignment trans to label------------
Ymatch_Mat=zeros(nodenum,nodenum);
Ymatch=[];
for i=1:nodenum
    Ymatch_Mat(i,assignment(i))=1;
end
q=1;
for i=1:nodenum
    for j=1:nodenum
        Ymatch(q,1)=Ymatch_Mat(i,j);
        q=q+1;
    end
end
Ymatch=[Ymatch;Ymatch];
Yset=[Yset;Ymatch];

%%---------------accuracy of greedy method----------------------

% l=sprintf('D:/HW/SVM_textbookDATA/L%d.txt',train_sample(num));
% l=importdata(l);
% Ltag=[];Y=1;
% for c3=1:nodenum
%     for j=((nodenum*c3)-nodenum)+1:nodenum*c3
%         if l(j)==1
%             Ltag(Y)=rem(j,nodenum);
%             if rem(j,nodenum)==0
%                 Ltag(Y)=nodenum;
%             end
%                 Y=Y+1;
%         end
%     end
% end
% assignment=assignment
% Ltag=Ltag


 end

end