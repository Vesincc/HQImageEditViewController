//
//  HQEditImageCaptureView.m
//  CivilAviation
//
//  Created by iOS on 2019/4/1.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "HQEditImageCaptureView.h"

@implementation HQEditImageCaptureView

- (instancetype)init {
    if (self = [super init]) {
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view) {
        return view;
    } else {
        return self.captureView;
    }
}

- (UIImage *)captureImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width,self.frame.size.height), NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (UIImage *)captureOriginalImage {
    UIScrollView *scrollView = (UIScrollView *)self.captureView;
    UIImage *orignaImage = self.imageView.image;
    
    CGFloat width = (self.captureView.frame.size.width/self.imageView.frame.size.width)*orignaImage.size.width;
    CGFloat height = (scrollView.frame.size.height/scrollView.frame.size.width)*width;
    CGSize captureSize = CGSizeMake(width, height);
    
    CGFloat x = (scrollView.contentOffset.x/self.imageView.frame.size.width)*orignaImage.size.width;
    CGFloat y = (scrollView.contentOffset.y/self.imageView.frame.size.height)*orignaImage.size.height;
    CGPoint captureOffset = CGPointMake(x, y);
    
    // 长宽微调
    if (x + width >= self.imageView.frame.size.width) {
        x = self.imageView.frame.size.width - width;
    }
    if (y + height >= self.imageView.frame.size.height) {
        y = self.imageView.frame.size.height - height;
    }
    
    CGRect captureRect;
    if (self.rotateTimes % 2 == 0) {
        captureRect = CGRectMake(captureOffset.x, captureOffset.y, captureSize.width, captureSize.height);
    } else {
        captureRect = CGRectMake(captureOffset.x, captureOffset.y, captureSize.height, captureSize.width);
    }
    
    CGImageRef temp = CGImageCreateWithImageInRect(orignaImage.CGImage, captureRect);
    UIImage *result = [UIImage imageWithCGImage:temp];
    CGImageRelease(temp);
    
    result = [self rotateImage:result times:self.rotateTimes];
    
    return result;
}

- (UIImage *)rotateImage:(UIImage *)image times:(NSInteger)rotateTimes {
    if (rotateTimes % 4 == 0) {
        return image;
    } else if (rotateTimes % 4 == 1) {
        return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeft];
    } else if (rotateTimes % 4 == 2) {
        return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown];
    } else {
        return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight];
    }
}

@end
