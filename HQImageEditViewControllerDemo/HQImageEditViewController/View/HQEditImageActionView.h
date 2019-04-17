//
//  HQEditImageActionView.h
//  CivilAviation
//
//  Created by iOS on 2019/3/29.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@class HQEditImageActionView;
@protocol HQEditImageActionViewDelegate <NSObject>

- (void)action:(HQEditImageActionView *)action didClickButton:(UIButton *)button atIndex:(NSInteger)index;

@end

@interface HQEditImageActionView : UIView

@property (nonatomic, weak) id <HQEditImageActionViewDelegate> delegate;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *originButton;
@property (nonatomic, strong) UIButton *finishButton;

@end

NS_ASSUME_NONNULL_END
