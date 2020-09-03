//
//  OpenCVWrapper.m
//  OpenCV_IOS
//
//  Created by wang on 2020/8/21.
//  Copyright © 2020 wang. All rights reserved.
//
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "OpenCVWrapper.h"
using namespace cv;
using namespace std;

@implementation OpenCVWrapper


+(nonnull UIImage *)getBinaryImage:(nonnull UIImage *)image {
    
    Mat mat, rgbMat, hsvMat, ractMat;
    UIImageToMat(image, mat);
    UIImageToMat(image, ractMat);
    medianBlur(mat, mat, 5);
    
    rgbMat = ~mat;
    medianBlur(rgbMat, rgbMat, 5);
    cv::cvtColor(rgbMat, hsvMat, COLOR_RGB2HSV);
    Mat mask;
    inRange(hsvMat, Scalar(90 - 10, 70, 50), Scalar(90 + 10, 255, 255), mask);
    GaussianBlur(mask, mask, cv::Size(5, 5), 2, 2);
    
    UIImage *binImg;
    vector<cv::Vec3f> circles;
    cv::HoughCircles(mask, circles, HOUGH_GRADIENT,1.2, 80);
    if (circles.size() < 3)
    {
        for(size_t i = 0; i < circles.size(); i++)
        {
            
           int Max_Width = mat.cols;
           int Max_Height = mat.rows;
           
            
            Vec3i c = circles[i];
            cv::Point center = cv::Point(c[0], c[1]);
            
            // circle center
            //circle( outMat, center, 1, Scalar(0,100,100), 3, LINE_AA);
            // circle outline
            int radius = c[2];
            
            //circle( outMat, center, radius, Scalar(255,0,255), 3, LINE_AA);
            if (c[0] + radius <= Max_Width and c[1] + radius <= Max_Height and c[0] - radius >=0 and c[1] - radius >=0) {
                cv::Rect rect = cv::Rect(c[0]-radius, c[1]-radius, radius*2, radius*2);
                ractMat = mat(rect);
                binImg = MatToUIImage(ractMat);
                
            } else {
                binImg = MatToUIImage(mat);
                
            }
            
            
            //NSLog(@"radius = %1d , x = %1d , y = %1d , width = %1d, height = %1d", radius, c[0], c[1], Max_Width, Max_Height);
        }
    }
   
    
    return binImg;
}

+(nonnull UIImage *)getTrafficSignImage:(nonnull UIImage *)redImage
{
    
    Mat mat, rgbMat, hsvMat, ractMat;
    UIImageToMat(redImage, mat);
//    cv::cvtColor(mat, rgbMat, cv::COLOR_BGR2RGB);
    
    rgbMat = ~mat;
    cv::cvtColor(rgbMat, hsvMat, COLOR_RGB2HSV);
    
    Mat mask;
    inRange(hsvMat, Scalar(90 - 10, 70, 50), Scalar(90 + 10, 255, 255), mask);
    //blur(mask, mask,cv::Size(9,9));
    GaussianBlur(mask, mask, cv::Size(3, 3), 2,2);
    equalizeHist(mask, mask);
//    threshold(mask,mask,120,255,THRESH_BINARY);
    
    Mat erodeStruct = getStructuringElement(MORPH_ELLIPSE,cv::Size(5,5));
    erode(mask, mask, erodeStruct);
    dilate(mask, mask, erodeStruct);

    //Canny(mask, mask, 100, 200, 3);
    //threshold(mask,mask,120,255,THRESH_BINARY);
    UIImage *binImg = MatToUIImage(mask);
    return binImg;
}


+(nonnull UIImage *)getCircleImage:(nonnull UIImage *)circleImage
{
    
    Mat mat, rgbMat, hsvMat, ractMat;
    UIImageToMat(circleImage, mat);
    UIImageToMat(circleImage, ractMat);
    medianBlur(mat, mat, 5);
    
    rgbMat = ~mat;
    medianBlur(rgbMat, rgbMat, 5);
    cv::cvtColor(rgbMat, hsvMat, COLOR_RGB2HSV);
    Mat mask;
    inRange(hsvMat, Scalar(90 - 10, 70, 50), Scalar(90 + 10, 255, 255), mask);
    GaussianBlur(mask, mask, cv::Size(5, 5), 2, 2);
//    Mat erodeStruct = getStructuringElement(MORPH_ELLIPSE,cv::Size(3,3));
//    erode(mask, mask, erodeStruct);
//    medianBlur(rgbMat, rgbMat, 9);
//    erode(mask, mask, erodeStruct);
    UIImage *binImg =MatToUIImage(mat);
    vector<cv::Vec3f> circles;
    cv::HoughCircles(mask, circles, HOUGH_GRADIENT,1.2, 80);
    for(size_t i = 0; i < circles.size(); i++)
    {
        Vec3i c = circles[i];
        cv::Point center = cv::Point(c[0], c[1]);
        int radius = c[2];
        circle(mat, center, radius, Scalar(255,255,255), 8, 8, 0 );
         binImg = MatToUIImage(mat);

    }
    return binImg;
}
@end
