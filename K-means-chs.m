%% 初始操作
clear;clc;close all; 
I=imread('mwander.jpg');%读取图像，存为I矩阵
I=rgb2gray(I);          %将图像转化为灰度矩阵
figure;imshow(I);       %显示图像 
figure;imhist(I);       %显示图像灰度直方图
 
%% 对直方图进行迭代平滑
[F,G] = imhist(I);  %[灰度出现频率,对应灰度值]
Res = F;            %记录灰度频率矩阵
S = zeros(0,256);   
figure;
for i=1:5           %迭代五次
    Res = SmoothHist(Res , S);%平滑函数
    subplot(2,3,i);
    bar(G , Res);    %显示灰度直方图
end
figure;
bar(G , Res);%显示最终平滑的直方图
 
%%  利用波峰求K值
% 求一阶导数
dy = zeros(0,256);
for i = 1:255 %dx变化值为1近似求导
    dy(i) = Res(i+1) - Res(i);
end
dy(256) = dy(255);%最后一位近似等于前一位
figure;bar(G,dy); %显示导数图
 
%求波峰数量
k = 0;
flag = 0;%标记正导数
for j = 1:256 
    if dy(j) > 0        %导数大于0
        flag = 1;       %标记
        continue;       %大于0就跳过
    elseif dy(j) < 0 && flag %满足正负变换
        k = k + 1;      %统计聚类点个数
        center(k) = j;  %确定聚类点位置
        flag = 0;       %标记清除
    else
        continue;       %为0则跳过
    end
end
%% 进行聚类迭代
m = center;
iter = 20;          %迭代次数
lenT = zeros(1,k);
sumJ = zeros(1,iter);

for i=1:iter        
    for j=1:k
        if j == 1
            tf = find(I<m(j)+(m(j+1)-m(j))/2);    %找到起始的聚类中心的灰度点
            lenT(j) = length(tf);                 %记录矩阵长度即点的个数
            ind(1:lenT(j),j) = tf;                %按长度赋值给ind矩阵
            tf = [];                   %矩阵维度确定后不能重新赋值，所以需要清空
        elseif j == k
            tf =  find(I>m(j-1)+(m(j)-m(j-1))/2);  %找到最后的聚类中心的灰度点
            lenT(j) = length(tf);
            ind(1:lenT(j),j) = tf;
            tf = [];
        else                                    %找到中间位置的聚类中心的灰度点
            tf = find(I>(m(j-1)+(m(j)-m(j-1))/2) & (I<m(j)+(m(j+1)-m(j))/2)); 
            lenT(j) = length(tf);
            ind(1:lenT(j),j) = tf;
            tf = [];
        end
    end
    for d = 1:k
        J(d) = sum((I(ind(1:lenT(d),d))-m(d)).^2);  %计算误差平方和
        sumJ(i) = sumJ(i) + J(d);                   %误差平方和相加
        m(d) = mean(I(ind(1:lenT(d),d)));           %更新聚类中心
    end
end
plot(sumJ);%输出误差变化曲线
 
 
%% 绘制聚类分割的图像
A=zeros(256,256);
for i=1:k%将离聚类中心灰度的欧式距离最近的点赋值为聚类中心灰度值
    A(ind(1:lenT(i),i)) = m(i);%利用灰度进行分割
end
A=uint8(A);            %转换为uint整数
figure;
imshow(A);      %显示分割后的图像


%% 直方图平滑
function result = SmoothHist(Freq,Smooth) %输入初始直方图返回平滑直方图
    step = 10;      %步长
    for i = 0 : 255
        count = 0;  %计数缺失项
        temp = 0;
        for j = -step/2 : step/2 - 1 %从负半步长到正半步长
            k = i + j;             %待求和灰度点位置
            if k < 0               %跳过前边界值
                count = count + 1; %没有求和的前边界个数
                continue;
            elseif k > 255         %跳过后边界值
                count = count + 1; %没有求和的后边界个数
                continue;
            else
                temp = temp + Freq(k+1);%灰度求和
                continue;
            end
        end 
        temp = floor(temp/(step-count)); %灰度和除以参与求和的个数（向下取整）
        Smooth(i+1) = temp; %赋值给待输出矩阵
    end
    result = Smooth; %返回平滑直方图矩阵
end