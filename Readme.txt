��Ƨ�����:
result:���Papproaches matching �X�Ӫ����G

model:Object-text Matching learning������model�s��b��

Data:Template Matching learning������model�s��b��

Label:matching label for each image(�C�i�Ϥ�������Ӹ���Ӥ�r�@�ǰt)

LX:��X�i�Ϥ����T��matching���G(object-word���������Y�A�Y�O��t��1�A���ǰt��0)

dataset:300�iImage

svm-struct-matlab-1.2: struct-SVM toolbox (���[�J����|��)

Detection:�������G
Input: Image
Output: bounding boxes(x,y,w,h)---(x,y):��إ��W�����y��, w:��ؼe��, h:��ذ���
objX:����b��X�i�Ϥ���bounding boxes
textX:��r�b��X�i�Ϥ���bounding boxes

Features:�]�t(Distance information, information, Spatial information and Relative location information)
Input:Detection ��쪺bounding boxes
Output:
geoX:����b��X�i�Ϥ���shape corresponding probability (�����ϥ�shape matching �����G)
knnX:����b��X�i�Ϥ���distance corresponding probability (�����ϥ�KNN matching �����G)
2LvoteX:�b��X�i�Ϥ�����P��r���벼���G�A�i�ΨӥN���pattern����r�P������G�����p(2Level,8��bins*2=16��bins,�C��bins45��)�A�]�����׬O16+16=32(����P��r���}�벼)
RelX:�b��X�i�Ϥ�����P��r���۹��m���Y�A�@�˥H�벼���覡�O��(�N�Ϥ����Φ�8�����i��spatial�벼�A�b�C��bin���̾ڤ�r�b���󪺤��(8�Ӥ��)�A�i��벼)�A�]�����׬O8*8=64



���|�G
How to use?

cd 300SourceCode              ->EX: cd D:\HW\�פ��Ƨ�\300SourceCode
addpath(genpath(pwd))
main

����main.m

�ѩ�detection, feature extraction, learning �����G�Ҥw�s�b��Ƨ���
�i��������mode 4~8 �[��G�C

�{������:
---------------------------------------------------------------
Select the mode:
---------------------------------------------------------------
1:Detection
2:Feature extraction
3:Learning our models
4:Inference
5:Other approaches
6:K-fold cross validation (Our approach)
7:K-fold cross validation (Two phase)
8:K-fold cross validation (LAP)
---------------------------------------------------------------
Input> 4 to inference our approach

Input> 5 to select other approaches:
---------------------------------------------------------------
Select the approach:
---------------------------------------------------------------
1:KNNs
2:Greedy method
3:Shape
4:Two phase
5:LAP Inference 
---------------------------------------------------------------
Input> 1~5 to see the performance of each approach

Input> 6~8 run K-fold cross validation (K=4) , ����p�⤣�Ptesting data
(mode 4 and 5 just use K=1 to test)

�V�m�P���ո�ƭק�:
Datasetting.m

�V�m:
modelX=[] -> �N���X��model�A��model�n�V�m���Ϥ��s�����J[]��
Example:
model1=[1 35 101 102 103 104 296 297 298 299 300];
�N��Ĥ@��model�]�t�Ϥ�{1 35 101 102 103 104 296 297 298 299 300}�A�@11�i�Ϥ��V�mmodel1
(�i�H�Ѧ�dataset��Ƨ�����"pattern_class")


����:
test_sample= [] -> choise the image you want to test ��ܧA�һݭn���ժ��Ϥ��s��
pattern_L= []  -> corresponding the testing image, their pattern label belong what model? �ӹϤ��ݩ����model���O(�i�H�Ѧ�dataset��Ƨ�����"pattern_class")


�o�����O�NDATA�����T�����h����:
%%%%%%%%%%%%  Direction 1   -------------------------------------
% test_sample=[16 17 18 90 91 92 93 94 96  262 263 264 265 266 267 268 269 270 271 272 273 274 275];
% pattern_L=[22 22 22 22 22 22 22 22 22 22  22 22 22 22 22 22 22 22 22 22 22 22 22 ];
%%%%%%%%%%%%  Direction 2   -------------------------------------
% test_sample=[105 39 40 33 36 139 49 287 289 26 27 51 53 54 58 59 60 12 99 219 230];
% pattern_L=[1 2 2 3 4 7 8 8 8 11 11 12 12 12 13 14 14 16 16 16 16];
%%%%%%%%%%%%  Direction 3   -------------------------------------
% test_sample=[87 88 89 9 10 25 67 65 69 68 70 100 76];
% pattern_L=[10 10 10 15 15 17 18 19 19 20 20 23 24];
%%%%%%%%%%%%%%%%%%%%%%%%%%