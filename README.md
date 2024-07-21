# Adaptive K-means Image Segment
### Histogram-based adaptive K-means clustering image segmentation algorithm  
K-mean clustering algorithm is an efficient and easy to implement unsupervised machine learning method and one of the most commonly used clustering algorithms, but the K-mean clustering algorithm also has certain limitations: it can not be reasonable to determine the K value and the initial clustering centers. if an inappropriate initial value is given will cause the algorithm's efficiency to decline, and it may also make the clustering fall into the wrong local extreme value. This algorithm starts from the histogram that reacts to the gray scale distribution of the image, smoothes the histogram and determines the K and the initial clustering center by the number and position of the wave peaks to realize the adaptive K-mean clustering image segmentation.  
  
*****
### Histogram Smoothing
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/cd93dfc0-b0b4-4bdc-8f35-9de831218f63)  
### K-mean clustering 
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/9c804bf1-c943-4fd7-b8ef-f24ed935b0a9)  
*****
### running result  
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/8558cb0d-a131-425b-8c37-6f6912a756a9)
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/a9c189ba-80c5-42d9-9beb-b3f3b82a0c8d)
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/c40e0ff0-a9d7-49bf-84b1-9ea0ef32374f)  
### comparison chart  
![image](https://github.com/UMR-kira/AdaptiveK-meansImageSegment/assets/113828450/d4d4e69c-e902-48ba-b28b-03fc46d96698)

