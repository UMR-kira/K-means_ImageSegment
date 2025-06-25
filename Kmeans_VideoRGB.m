clear; clc; close all;
%% 初始设置
% 设置视频文件路径
inputVideoFile = '1.mp4';
outputVideoFile = 'seg.mp4';
% 创建视频读写对象
vReader = VideoReader(inputVideoFile);
vWriter = VideoWriter(outputVideoFile, "MPEG-4");
vWriter.FrameRate = vReader.FrameRate;
open(vWriter);
% 参数设置
downsample_ratio = 0.25; % 下采样比例
maxIter = 10; % kmeans最大迭代次数
% 获取视频总帧数
numFrames = min(floor(vReader.Duration * vReader.FrameRate), vReader.NumFrames); % 双重保险

% 启动并行池
if isempty(gcp('nocreate'))
    parpool("local",8);
end

% 预分配结果存储
firstFrame = read(vReader, 1);
[h, w, ~] = size(firstFrame);
segmented_frames = cell(numFrames, 1);
k_values = zeros(numFrames, 1);

% 进度系统
D = parallel.pool.DataQueue;
time = waitbar(0, '0/0 帧 (0.0%)', 'Name', '视频处理进度');
completedCount = 0; % 使用累加计数器替代数组记录
afterEach(D, @(~) updateProgressSimple(numFrames, time));% 回调设置

%% 并行处理每一帧
tic;
totalTime = 0;
parfor frameCount = 1:numFrames
    try
        % 读取当前帧
        I = read(vReader, frameCount);
        data = double(reshape(I, [], 3)); % 将图像重塑为n×3矩阵

        % 下采样图像用于快速确定k值和初始中心
        I_small = imresize(I, downsample_ratio);
        I_gray_small = im2gray(I_small); 
        
        % 计算灰度直方图并平滑去噪
        [F, G] = imhist(I_gray_small);
        % figure; bar(G, F);
        Res1 = smoothdata(F,'movmean',8); %对帧进行粗略的均值处理
        % figure; bar(G, Res);
        [Res2,~] = smoothdata(Res1,"sgolay",8,Degree=4); %平滑得到波谷近似值
        % figure; bar(G, Res);
        Res3 = smoothdata(Res2, "gaussian",8); %高斯平滑得到更少的波峰
        % figure; bar(G, Res);
    
        % 检测波峰确定聚类数量k
        [~, center] = findpeaks(Res3);
        k = length(center);
        % 确保 k 合理
        if k < 3
            [~, center] = findpeaks(Res2);
            k = length(center);
        end
        center = center';  % 转为行向量
        k_values(frameCount) = k;

        % 使用下采样图像计算初始中心
        initial_centers = zeros(k, 3);
        for i = 1:k
            % 在下采样图像中找到灰度值接近center(i)的像素
            mask = abs(double(I_gray_small) - center(i)) < 5;
            % 获取这些像素的RGB值
            rgb_values = I_small(repmat(mask, [1,1,3]));
            rgb_values = reshape(rgb_values, [], 3);
            if ~isempty(rgb_values)
                % 计算平均RGB作为初始中心
                initial_centers(i, :) = mean(double(rgb_values), 1);
            else
                % 如果找不到像素，使用默认值
                initial_centers(i, :) = [center(i), center(i), center(i)];
            end
        end
    
        % 对全分辨率图像执行k-means聚类
        [idx, C] = kmeans(data, k, 'Start', initial_centers, ...
                          'MaxIter', maxIter, 'Display', 'off');
        % 重构分割图像
        segmented_img = uint8(reshape(C(idx, :), size(I)));
        segmented_frames{frameCount} = segmented_img;

        % 发送完成信号 (修改为无数据发送)
        send(D, []);
    catch ME
        fprintf('帧%d处理失败: %s\n', frameCount, ME.message);
        segmented_frames{frameCount}= zeros(h, w, 3, 'uint8'); % 返回黑帧
    end
end
% 确保关闭进度条
if ishandle(time)
    close(time);
end
timeElapsed = toc;

%% 按顺序写入视频帧
for frameCount = 1:numFrames
    writeVideo(vWriter, segmented_frames{frameCount});
end
close(vWriter);

%% 显示处理结果
fprintf('\n处理完成!\n');
fprintf('总帧数: %d\n', numFrames);
fprintf('总时间: %.2f seconds\n', sum(timeElapsed));
fprintf('平均处理速度: %.2f 帧/秒\n', numFrames/timeElapsed);

%% 绘制k值变化曲线
figure;
plot(1:frameCount, k_values, 'b-o', 'LineWidth', 1.5);
xlabel('帧数');
ylabel('K值');
title('帧的K值变化');
grid on;

%% 进度更新函数
function updateProgressSimple(totalFrames, time)
    persistent count startTime   
    % 初始化
    if isempty(count)
        count = 0;
        startTime = tic;
    end

    % 更新计数
    count = count + 1;    
    % 计算进度
    percent = count/totalFrames*100;
    elapsed = toc(startTime);
    remaining = (totalFrames-count)*(elapsed/count);    

    % 更新显示 (每0.5秒或关键进度点更新)
    if rem(count,50)==0 || count==totalFrames || elapsed>1
        waitbar(count/totalFrames, time, ...
            sprintf('%d/%d帧 (%.1f%%)\n已用:%.1fs 剩余:%.1fs',...
            count, totalFrames, percent, elapsed, remaining));
        drawnow;
    end
end