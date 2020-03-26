資料夾介紹:
result:不同approaches matching 出來的結果

model:Object-text Matching learning完成的model存放在此

Data:Template Matching learning完成的model存放在此

Label:matching label for each image(每張圖片中物件該跟哪個文字作匹配)

LX:第X張圖片正確的matching結果(object-word之間的關係，若是批配給1，不匹配給0)

dataset:300張Image

svm-struct-matlab-1.2: struct-SVM toolbox (須加入到路徑中)

Detection:偵測結果
Input: Image
Output: bounding boxes(x,y,w,h)---(x,y):方框左上角的座標, w:方框寬度, h:方框高度
objX:物件在第X張圖片的bounding boxes
textX:文字在第X張圖片的bounding boxes

Features:包含(Distance information, information, Spatial information and Relative location information)
Input:Detection 找到的bounding boxes
Output:
geoX:物件在第X張圖片的shape corresponding probability (類似使用shape matching 的結果)
knnX:物件在第X張圖片的distance corresponding probability (類似使用KNN matching 的結果)
2LvoteX:在第X張圖片物件與文字的投票結果，可用來代表該pattern中文字與物件分佈的情況(2Level,8個bins*2=16個bins,每個bins45度)，因此維度是16+16=32(物件與文字分開投票)
RelX:在第X張圖片物件與文字的相對位置關係，一樣以投票的方式記錄(將圖片切割成8等分進行spatial投票，在每個bin內依據文字在物件的方位(8個方位)再進行投票)，因此維度是8*8=64



路徑：
How to use?

cd 300SourceCode              ->EX: cd D:\HW\論文資料夾\300SourceCode
addpath(genpath(pwd))
main

執行main.m

由於detection, feature extraction, learning 的結果皆已存在資料夾中
可直接執行mode 4~8 觀察結果。

程式介面:
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

Input> 6~8 run K-fold cross validation (K=4) , 交替計算不同testing data
(mode 4 and 5 just use K=1 to test)

訓練與測試資料修改:
Datasetting.m

訓練:
modelX=[] -> 代表第X個model，該model要訓練的圖片編號打入[]中
Example:
model1=[1 35 101 102 103 104 296 297 298 299 300];
代表第一個model包含圖片{1 35 101 102 103 104 296 297 298 299 300}，共11張圖片訓練model1
(可以參考dataset資料夾中的"pattern_class")


測試:
test_sample= [] -> choise the image you want to test 選擇你所需要測試的圖片編號
pattern_L= []  -> corresponding the testing image, their pattern label belong what model? 該圖片屬於哪個model類別(可以參考dataset資料夾中的"pattern_class")


這部分是將DATA切成三部分去測試:
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