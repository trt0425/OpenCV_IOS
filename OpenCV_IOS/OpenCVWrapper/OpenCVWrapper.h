//
//  OpenCVWrapper.h
//  OpenCV_IOS
//
//  Created by wang on 2020/8/21.
//  Copyright © 2020 wang. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>


#endif

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif



NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+(UIImage *)getBinaryImage:(UIImage *)image;
+(UIImage *)getTrafficSignImage:(UIImage *)redImage;
+(UIImage *)getCircleImage:(UIImage *)circleImage;
@end

NS_ASSUME_NONNULL_END
