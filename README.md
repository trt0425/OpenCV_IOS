# OpenCV_IOS

使用OpenCV IOS版 交通號誌辨識  
使用到Swift、Objective-C和OpenCV  
HSV 色彩空間轉化 把紅色區間找出來得到 只有紅色區塊，  
再來使用HOUGH_GRADIENT函式去找出圓形，  
利用ROI去切出圓形給予model去辨識交通號誌。  
以下是運行結果  
![image](https://github.com/trt0425/OpenCV_IOS/blob/master/IMG_5183.PNG)ˋ  

使用CoreML 選出比較常用的限速個一千張去訓練  
![image](https://github.com/trt0425/OpenCV_IOS/blob/master/model.png)
