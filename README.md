# AdaptiveK-meansImageSegment
Histogram-based adaptive K-means clustering image segmentation algorithm

K-mean clustering algorithm is an efficient and easy to implement unsupervised machine learning method and one of the most commonly used clustering algorithms, but the K-mean clustering algorithm also has certain limitations, it can not be reasonable to determine the K value and the initial clustering centers, if an inappropriate initial value is given will cause the algorithm's efficiency to decline, and it may also make the clustering fall into the wrong local extreme value. This algorithm starts from the histogram that reacts to the gray scale distribution of the image, smoothes the histogram and determines the K and the initial clustering center by the number and position of the wave peaks to realize the adaptive K-mean clustering image segmentation.
K-均值聚类算法是一种效率高、容易实现的无监督机器学习方法，也是最常用的聚类算法之一，但K-均值聚类算法也存在一定的局限性，无法合理的确定K值以及初始聚类中心，如果给出了不恰当的初始值就会造成算法效率的下滑，还可能使得聚类陷入错误的局部极值中。本算法从反应图像灰度分布的直方图入手，平滑直方图并以波峰数量和位置确定K以及初始聚类中心，实现自适应K-均值聚类图像分割。

直方图平滑算法·Histogram Smoothing Algorithm
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/cd93dfc0-b0b4-4bdc-8f35-9de831218f63)
K均值聚类算法·K-mean clustering algorithm
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/9c804bf1-c943-4fd7-b8ef-f24ed935b0a9)

运行结果·running result
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/8558cb0d-a131-425b-8c37-6f6912a756a9)
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/a9c189ba-80c5-42d9-9beb-b3f3b82a0c8d)
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/c40e0ff0-a9d7-49bf-84b1-9ea0ef32374f)

对比图·comparison chart
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/d4d4e69c-e902-48ba-b28b-03fc46d96698)

