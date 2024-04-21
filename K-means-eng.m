%% Initial operation
clear;clc;close all; 
I=imread('mwander.jpg');%Read the image and save it as I matrix
I=rgb2gray(I); %convert the image to a grayscale matrix
figure;imshow(I); %show the image 
figure;imhist(I); %display the image grayscale histogram
 
%% Iterative smoothing of histograms
[F,G] = imhist(I); %[Frequency of occurrence of grayscale, corresponding to grayscale values]
Res = F; % Record gray scale frequency matrix
S = zeros(0,256);   
figure.
for i=1:5 % iterate five times
    Res = SmoothHist(Res , S);%smoothing function
    subplot(2,3,i).
    bar(G , Res); % display gray scale histograms
end
figure.
bar(G , Res);% show final smoothed histograms
 
%% Use of wave crests to find K-values
% Take first order derivatives
dy = zeros(0,256);
for i = 1:255 %dx change value to 1 approximate derivative
    dy(i) = Res(i+1) - Res(i).
end
dy(256) = dy(255);%Last bit is approximately equal to first bit
figure;bar(G,dy); %Display derivative figure
 
% Number of wave crests
k = 0;
flag = 0;%flag positive derivatives
for j = 1:256 
    if dy(j) > 0 % derivative greater than 0
        flag = 1; %flag
        continue; %Skip if greater than 0
    elseif dy(j) < 0 && flag %Satisfies positive and negative transformations.
        k = k + 1; % count the number of clustered points
        center(k) = j; % Determine the location of the clustering points
        flag = 0; % flag cleared
    else
        continue; %Skip if 0
    end
end
%% Perform clustering iterations
m = center.
iter = 20; % number of iterations
lenT = zeros(1,k);
sumJ = zeros(1,iter);

for i=1:iter        
    for j=1:k
        if j == 1
            tf = find(I<m(j)+(m(j+1)-m(j)/2); % find the gray point of the starting cluster center
            lenT(j) = length(tf); % record the length of the matrix i.e. the number of points
            ind(1:lenT(j),j) = tf; % Assign by length to ind matrix
            tf = []; % matrix dimensions cannot be reassigned after they are determined, so they need to be cleared
        elseif j == k
            tf = find(I>m(j-1)+(m(j)-m(j-1))/2); %find the gray point of the last cluster center
            lenT(j) = length(tf).
            ind(1:lenT(j),j) = tf.
            tf = [];
        else %Find the grayscale point at the center of the cluster in the middle position
            tf = find(I>(m(j-1)+(m(j)-m(j-1))/2) & (I<m(j)+(m(j+1)-m(j))/2)); 
            lenT(j) = length(tf).
            ind(1:lenT(j),j) = tf.
            tf = [];
        end
    end
    for d = 1:k
        J(d) = sum((I(ind(1:lenT(d),d))-m(d)). ^2); % Calculate the sum of squared errors
        sumJ(i) = sumJ(i) + J(d); % sum of error squares
        m(d) = mean(I(ind(1:lenT(d),d))); % update cluster centers
    end
end
plot(sumJ);%Output error variation curve
 
 
%% Plotting images for clustered segmentation
A=zeros(256,256).
for i=1:k%Assign the point with the closest Euclidean distance to the cluster center grayscale as the cluster center grayscale value
    A(ind(1:lenT(i),i)) = m(i);% Segmentation using grayscale
end
A=uint8(A); %convert to uint integer
figure.
imshow(A); %show the segmented image


%% Histogram smoothing
function result = SmoothHist(Freq,Smooth) % input initial histogram return smooth histogram
    step = 10; % step length
    for i = 0 : 255
        count = 0; % count missing items
        temp = 0;
        for j = -step/2 : step/2 - 1 % from negative half step to positive half step
            k = i + j; % Position of gray point to be summated
            if k < 0 % skip previous boundary value
                count = count + 1; % the number of boundaries that are not summed up
                continue;
            elseif k > 255 %Skip after boundary value
                count = count + 1; % the number of backward boundaries that are not summed up
                continue;
            else
                temp = temp + Freq(k+1);% gray scale summation
                continue;
            end
        end 
        temp = floor(temp/(step-count)); % Gray scale sum divided by the number of participants in the summation (rounded down)
        Smooth(i+1) = temp; % Assign to the matrix to be exported
    end
    result = Smooth; % return smoothed histogram matrix
end
