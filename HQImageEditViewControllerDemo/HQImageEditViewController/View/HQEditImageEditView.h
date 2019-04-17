//
//  HQEditImageEditView.h
//  CivilAviation
//
//  Created by iOS on 2019/4/1.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN
@class HQEditImageEditView;
@protocol HQEditImageEditViewDelegate <NSObject>

- (void)editView:(HQEditImageEditView *)editView anchorPointIndex:(NSInteger)anchorPointIndex rect:(CGRect)rect;

@end

@interface HQEditImageEditView : UIView

@property (nonatomic, weak) id <HQEditImageEditViewDelegate> delegate;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *preView;
@property (nonatomic, strong) UIView *lineWrap;

@property (nonatomic, strong) UIView *imageWrap;

@property (nonatomic, assign) CGSize previewSize;
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) BOOL maskViewAnimation;

- (instancetype)initWithMargin:(UIEdgeInsets)margin size:(CGSize)size;

- (void)maskViewShowWithDuration:(CGFloat)duration;
- (void)maskViewHideWithDuration:(CGFloat)duration;
@end

NS_ASSUME_NONNULL_END
