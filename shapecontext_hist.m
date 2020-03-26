% chi-square distance
picnum=1;
[vote]=shapecontext(picnum);
l(1,:)=vote;
subplot(2,1,1)
bar(vote)
title(['Histogram of picture ',num2str(picnum)])
hold on;
picnum=3;
[vote]=shapecontext(picnum);
l(2,:)=vote;
subplot(2,1,2)
bar(vote)
title(['Histogram of picture ',num2str(picnum)])

d=sum(((l(1,:)-l(2,:)).^2)/(576+576));
xlabel(['Chi-square distance is  ',num2str(d)])
