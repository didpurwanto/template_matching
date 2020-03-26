function assignment=score(need,P,nodenum,z_index,zmat)
assignment=[];
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

end