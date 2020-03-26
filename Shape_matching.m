function [PLA,MLA]=Shape_matching(test_sample)
Score=0;MSet=[];MsSet=[];
Ntest=size(test_sample,2);

for picnum=1:Ntest
sf=sprintf('./Detection/obj%d.txt',test_sample(picnum));
st=sprintf('./Detection/text%d.txt',test_sample(picnum));
l=sprintf('./Labels/L%d.txt',test_sample(picnum));
objdata=importdata(sf);
textdata=importdata(st);
objnum=size(objdata,1);
textnum=size(textdata,1);
textdata2=textdata;
objdata2=objdata;
[objsize,~]=size(objdata);
[tsize,~]=size(textdata);
Cobj=[];Ctext=[];
%center of obj
Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
%center of text
Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);


X=Ctext;
Y=Cobj;
mean_dist_global=[]; % use [] to estimate scale from the data
nbins_theta=5;
nbins_r=5;
Xk=X; 
nsamp1=size(X,1);
nsamp2=size(Y,1);
ndum1=0;
ndum2=0;
if nsamp2>nsamp1
   % (as is the case in the outlier test)
   ndum1=ndum1+(nsamp2-nsamp1);
end
eps_dum=0.15;
r_inner=1/8;
r_outer=2;
n_iter=5;
r=1; % annealing rate
beta_init=1;  % initial regularization parameter (normalized)
display_flag=1;

% out_vec_{1,2} are indicator vectors for keeping track of estimated
% outliers on each iteration
k=1;
s=1;

out_vec_1=zeros(1,nsamp1); 
out_vec_2=zeros(1,nsamp2);
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while s
   disp(['iter=' int2str(k)])
   
   % compute shape contexts for (transformed) model
   [BH1,mean_dist_1]=sc_compute(Xk',zeros(1,nsamp1),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);

   % compute shape contexts for target, using the scale estimate from
   % the warped model
   % Note: this is necessary only because out_vec_2 can change on each
   % iteration, which affects the shape contexts.  Otherwise, Y does
   % not change.
   [BH2,mean_dist_2]=sc_compute(Y',zeros(1,nsamp2),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);
    
   % compute regularization parameter
   beta_k=(mean_dist_1^2)*beta_init*r^(k-1);

   % compute pairwise cost between all shape contexts
   costmat=hist_cost_2(BH1,BH2);
   % pad the cost matrix with costs for dummies
   nptsd=nsamp1+ndum1;
   costmat2=eps_dum*ones(nptsd,nptsd);
   costmat2(1:nsamp1,1:nsamp2)=costmat;
   disp('running hungarian alg.')
   cvec=hungarian(costmat2);
%   cvec=hungarian_fast(costmat2);
   disp('done.')

   % update outlier indicator vectors
   [a,cvec2]=sort(cvec);
   out_vec_1=cvec2(1:nsamp1)>nsamp2;
   out_vec_2=cvec(1:nsamp2)>nsamp1;

   % format versions of Xk and Y that can be plotted with outliers'
   % correspondences missing
   X2=NaN*ones(nptsd,2);
   X2(1:nsamp1,:)=Xk;
   X2=X2(cvec,:);
   X2b=NaN*ones(nptsd,2);
   X2b(1:nsamp1,:)=X;
   X2b=X2b(cvec,:);
   Y2=NaN*ones(nptsd,2);
   Y2(1:nsamp2,:)=Y;

   % extract coordinates of non-dummy correspondences and use them
   % to estimate transformation
   ind_good=find(~isnan(X2b(1:nsamp1,1)));
   % NOTE: Gianluca said he had to change nsamp1 to nsamp2 in the
   % preceding line to get it to work properly when nsamp1~=nsamp2 and
   % both sides have outliers...
   n_good=length(ind_good);
   X3b=X2b(ind_good,:);
   Y3=Y2(ind_good,:);

   
%    if display_flag
%       % show the correspondences between the untransformed images
%       figure(3)
%       plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')
% 
%       ind=cvec(ind_good);
%       hold on
%       plot([X2b(:,1) Y2(:,1)]',[X2b(:,2) Y2(:,2)]','k-')
%       hold off
%       title([int2str(n_good) ' correspondences'])
%       drawnow	
%    end

   % estimate regularized TPS transformation
   [cx,cy,E]=bookstein(X3b,Y3,beta_k);

   % calculate affine cost
   A=[cx(n_good+2:n_good+3,:) cy(n_good+2:n_good+3,:)];
   s=svd(A);
   aff_cost=log(s(1)/s(2));
   
   % calculate shape context cost
   [a1,b1]=min(costmat,[],1);
   [a2,b2]=min(costmat,[],2);
   sc_cost=max(mean(a1),mean(a2));
   
   % warp each coordinate
   fx_aff=cx(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
   d2=max(dist2(X3b,X),0);
   U=d2.*log(d2+eps);
   fx_wrp=cx(1:n_good)'*U;
   fx=fx_aff+fx_wrp;
   fy_aff=cy(n_good+1:n_good+3)'*[ones(1,nsamp1); X'];
   fy_wrp=cy(1:n_good)'*U;
   fy=fy_aff+fy_wrp;

   Z=[fx; fy]';
   
   
   % update Xk for the next iteration
   Xk=Z;
   
   % stop early if shape context score is sufficiently low
   if k==n_iter
      s=0;
   else
      k=k+1;
   end
end
sigma=0.5;
trc=costmat2';
sc=exp(-trc/(2*sigma^2));


objnum=size(Cobj,1);  
nodenum=size(Cobj,1);  
m=1;
A=[];


Text=[X2b(:,1) X2b(:,2)];
Ctext;
As=[];
for i=1:objnum
    for j=1:objnum
        if Text(i,:)==Ctext(j,:)
           id=j;
        end 
    end
    As=[As id];   
end
% As

l=importdata(l);
Ltag=[];Y=1;
for c3=1:nodenum
    for j=((nodenum*c3)-nodenum)+1:nodenum*c3
        if l(j)==1
            Ltag(Y)=rem(j,nodenum);
            if rem(j,nodenum)==0
                Ltag(Y)=nodenum;
            end
                Y=Y+1;
        end
    end
end
% As
% Ltag


% Ltag
if As==Ltag
    S=1;
    Score=Score+S;
end
Ms=0;
for i=1:nodenum
    if As(i)==Ltag(i)
        Ms=Ms+1;
    end
end
MsSet=[MsSet Ms];
MSet=[MSet nodenum];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sf=sprintf('./Detection/obj%d.txt',test_sample(picnum));
% st=sprintf('./Detection/text%d.txt',test_sample(picnum));
% objdata=importdata(sf);
% textdata=importdata(st);
% objnum=size(objdata,1);
% textnum=size(textdata,1);
% textdata2=textdata;
% objdata2=objdata;
% %-------------- build features------------------ 
% %ang=angles between objs and objs
% [objsize,~]=size(objdata);
% [tsize,~]=size(textdata);
% Cobj=[];Ctext=[];
% %center of obj
% Cobj(:,1)=objdata(:,1)+(objdata(:,3)/2);
% Cobj(:,2)=objdata(:,2)+(objdata(:,4)/2);
% %center of text
% Ctext(:,1)=textdata(:,1)+(textdata(:,3)/2);
% Ctext(:,2)=textdata(:,2)+(textdata(:,4)/2);
% CtextN=[];
% CtextN=Ctext;
% btext=textdata(:,1:2);
% 
% %%%
% pic=sprintf('./dataset/%d.jpg',test_sample(picnum));
% a=imread(pic);
% imshow(a)
% hold on;
% for i=1:objnum
%     rectangle('position',[objdata(i,1),objdata(i,2),objdata(i,3),objdata(i,4)],'edgecolor','b','LineWidth',3);
% %     pause
% end
% for i=1:textnum
%     rectangle('position',[textdata(i,1),textdata(i,2),textdata(i,3),textdata(i,4)],'edgecolor','r','LineWidth',3);
% %     pause
% end
% for i=1:objnum
%     if As(i)==Ltag(i)
%         r=0;g=0;b=0;
%         draw_arrow(Cobj(i,:),btext(As(i),:),.1,r,g,b)
%     else
%         r=1;g=1;b=0;
%         draw_arrow(Cobj(i,:),btext(As(i),:),.1,r,g,b)
%     end
% end
% h = figure( 1 ) ;
%  saveas( h , [ './result/shape/shape' num2str( test_sample(picnum)) , '.jpg' ] )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
PLA=Score/Ntest;
Correct_Match=sum(MsSet(1:Ntest));
Total_Match=sum(MSet(1:Ntest));
MLA=Correct_Match/Total_Match;

end