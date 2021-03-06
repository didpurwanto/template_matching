function ssvm_train(train_sample,modelnum)
% modelnum=12;
% train_sample=eval(['model',num2str(modelnum)]);
nData=size(train_sample,2);
patterns = {} ;
labels = {} ;
for i=1:nData
sf1=sprintf('./Features/knn%d.txt',train_sample(i));
sf2=sprintf('./Features/geo%d.txt',train_sample(i));
l=sprintf('./Labels/L%d.txt',train_sample(i));
F1=importdata(sf1);
F2=importdata(sf2);
l=importdata(l);
Feature=[F1;F2];
Label=[l;l];
patterns{1,i} =  Feature ;
trainlabel(:,i)  = Label ;
end
 [Yset]=greedymethod(patterns,nData);
Y=[];
 [Yset]=greedymethod(patterns,nData);
 for i=1:nData
     Y=[Y Yset];
 end
y=[trainlabel;Y];
 for i=1:nData
    labels{1,i}   = y(:,i);
 end

 %-------Add global feature (position information)-----
% sfL=sprintf('./Labels/locL%d.txt',modelnum);
% locL=importdata(sfL);
%  for i=1:nData
%  sf3=sprintf('./Features/vote%d.txt',train_sample(i));
%  F3=importdata(sf3);
%  F=[patterns{1,i};F3];
%  patterns{1,i}=F;
%  Lab=[labels{1,i};locL];
%  labels{1,i} = Lab;
%  end

%%---------------------------------------------
 % training examples
  parm.patterns = patterns ;
  parm.labels = labels ;
 % callbacks & other parameters
 parm.lossFn = @lossCB ;
 parm.constraintFn = @constraintCB ;
 parm.featureFn = @featureCB ;
 parm.dimension = size(F1,1)+size(F2,1);
 parm.verbose = 2 ;
%  model = svm_struct_learn(' -c 1.0 -o 1 -v 1 ', parm);
 model = svm_struct_learn(' -c 10 -o 1 -e 0.01', parm) ;
 w = model.w ;
%  w(end-15:end)
for i=1:size(w,1)
    W(i,1)=(w(i,1)-min(w))/(max(w)-min(w));
end
W;


 save(['./model/model',num2str(modelnum),'.mat'],'W');
 
function delta = lossCB(param, y, ybar)
  ys=size(ybar,1);
  yGT=y(1:ys);
  n=sqrt(ys);
%   y2=sum(y(end-15:end).*ybar(end-15:end));
  delta = (1-(sum((yGT.*ybar(1:ys)))/2)/n);

end

function psi = featureCB(param, x, y)
  xs=size(x,1);
  yGT=y(1:xs);
  xf=x(1:xs);
  LFy=yGT.*xf;
%   GFy=y(end-15:end).*x(end-15:end);
  F=[LFy];
  psi = sparse(F) ;
end

function yhat = constraintCB(param, model, x, y)
  w=model.w;
  xs=size(x,1);
  yGT=y(1:xs);
  setN=fix((size(y,1)/xs)-1);
  Ypset=zeros(xs,setN); 
  for setnum=1:setN
     Ypset(:,setnum)=y(xs*setnum+1:xs*(setnum+1))';
  end
  yhat=[];Score=[];
  for Setnum=1:setN
        ybar=Ypset(:,Setnum);
        n=sqrt(size(Ypset,1));
       loss = (1-(sum((yGT.*ybar))/2)/n);
       [Ymatch,GM_score] = FindMostViolateConstraint(x,w,y,loss,ybar);
       yhat=[yhat Ymatch];
       Score=[Score GM_score];
  end
  [Maxscore,I]=max(Score);
  Ybest=yhat(:,I);
  Ybest=[Ybest;Ybest];
  if loss  < 0.7
      yhat = [Ybest] ;
  else
      yhat = (randn(size(x,1),1) > 0) ; 
  end
  
  
end

% Maxscore


end
