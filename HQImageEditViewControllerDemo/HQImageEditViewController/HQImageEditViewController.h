//
//  HQImageEditViewController.h
//  CivilAviation
//
//  Created by iOS on 2019/3/29.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQImageEditViewController;
@protocol HQImageEditViewControllerDelegate <NSObject>


/**
 选取完成

 @param vc vc
 @param image 截取View获得图片
 @param originSizeImage 截取框对应原图片
 */
- (void)editController:(HQImageEditViewController *)vc finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage;


/**
 取消

 @param vc vc
 */
- (void)editControllerDidClickCancel:(HQImageEditViewController *)vc;

@end

@interface HQImageEditViewController : UIViewController

@property (nonatomic, weak) id <HQImageEditViewControllerDelegate> delegate;

/**
 截取原图
 */
@property (nonatomic, strong) UIImage *originImage;

/**
 选取框size
 */
@property (nonatomic, assign) CGSize editViewSize;


/**
 蒙层动画 默认no
 */
@property (nonatomic, assign) BOOL maskViewAnimation;

@end

NS_ASSUME_NONNULL_END
