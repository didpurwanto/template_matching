%% Inference by cross iteration
tic
clc;clear all;
test_sample=[105 40 33 36 26 27 87 88 51 58 59 60  9 10 12 2 25 99 65 68 69 70 93 94 96 76 139 289 219  100  5  7 31 32 34 37  42 44 46 50 144 145 84 85 86 154 155   5 6  52  55 200 201 206 207 218  220 221 235 241 250 256 257 262 268 269 19 275 281 159 160 67 230 54 89];
pattern_L=  [1   2  3  4  11 11 10 10 12 13 14 14 15 15 16 17 17 16 19 20 19 20 22 22 21 24  7  8 16 23 12 15 2  2  3  4   7  8  8  8  9   9  10 10 10  11  11  12 12 12  13 14  14   15 15  16   16  16  17  18  19  20  20  21  22  22  23 23  24 11 11 18 16 12 10];
Ntest=size(test_sample,2);
BD_initialTestRel(test_sample);
Template_Match(test_sample,pattern_L)
[Assignment,PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
Assignment_reg=Assignment;
Pr = load('./Data/predictions');
Pm = Pr(:,1);
Predicts_reg = Pm;
A=[];

for iter=1:5
    eq_score=0;
    multiclassSVM;
    Pr = load('./Data/predictions');
    Pm = Pr(:,1);
    [Assignment,PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
    for i=1:Ntest
        if Assignment_reg{i,1}~=Assignment{i,1}
            Assignment_reg=Assignment;
        else
            eq_score=eq_score+1;
        end
    end
    if sum(Predicts_reg==Pm)~=Ntest 
        Predicts_reg = Pm
    else if sum(Predicts_reg==Pm)==Ntest && eq_score==Ntest
        break;
        end
    end
end

% [PLA,MLA,CM]=infer_matching(test_sample,pattern_L);
%% Show result
% h = figure( 1 ) ;
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
% 
% disp(['PLA is: '  num2str(PLA) '%']) ;
% disp(['MLA is: '  num2str(MLA) '%']) ;
% 
% disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']) ;
% 
% CM
% %----Confusuin Matrix
% num_class=12;
% Row=0;
% 
% Confusion_matrix=CM;
% for i=1:num_class
%     for j=1:num_class
%         Row=Row+Confusion_matrix(i,j);
%     end
%     num_in_class(1,i)=Row;
%     Row=0;
% end
% 
% for i=1:num_class
%     confusion_matrix(i,:)=Confusion_matrix(i,:)/num_in_class(i)*100;
% end
% 
% 
% name_class(1,1) = {'Template 1'};
% name_class(2,1) = {'Template 2'};
% name_class(3,1) = {'Template 3'};
% name_class(4,1) = {'Template 4'};
% name_class(5,1) = {'Template 5'};
% name_class(6,1) = {'Template 6'};
% name_class(7,1) = {'Template 7'};
% name_class(8,1) = {'Template 8'};
% name_class(9,1) = {'Template 9'};
% name_class(10,1) = {'Template 10'};
% name_class(11,1) = {'Template 11'};
% name_class(12,1) = {'Template 12'};
% confusion_matrix=roundn(confusion_matrix,-2)
% draw_cm(confusion_matrix,name_class,num_class)
% 
% saveas( h , [ './result/confusion_matrix/CM'  , '.jpg' ] )
toc
