//
//  HQEditImageEditView.m
//  CivilAviation
//
//  Created by iOS on 2019/4/1.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "HQEditImageEditView.h"

@interface HQEditImageEditView ()
@property (nonatomic, assign) BOOL isMoving;
@end

@implementation HQEditImageEditView

- (instancetype)initWithMargin:(UIEdgeInsets)margin size:(CGSize)size {
    if (self = [super init]) {
        self.layer.masksToBounds = NO;
        
        self.margin = margin;
        self.previewSize = size;
        
        [self addSubview:self.maskView];
        [self addSubview:self.preView];
        
        [self.preView addSubview:self.lineWrap];
        [self.lineWrap addSubview:self.imageWrap];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-self.margin.top));
        make.left.equalTo(@(-self.margin.left));
        make.width.equalTo(@(self.previewSize.width + self.margin.left + self.margin.right));
        make.height.equalTo(@(self.previewSize.height + self.margin.top + self.margin.bottom));
    }];
    
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.imageWrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@-1.5f);
        make.bottom.right.equalTo(@1.5f);
    }];
}

#pragma mark - public method
- (void)maskViewShowWithDuration:(CGFloat)duration {
    if (self.maskViewAnimation) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 1;
        }];
    }
}
- (void)maskViewHideWithDuration:(CGFloat)duration {
    if (self.maskViewAnimation) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 0;
        }];
    }
}

#pragma mark - private method
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.imageWrap.hidden == NO && self.isMoving == NO) {
        for (UIView *view in self.imageWrap.subviews) {
            CGRect rect = [view convertRect:view.bounds toView:self];
            if (CGRectContainsPoint(rect, point)) {
                return view;
            }
        }
    }
    return nil;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isMoving = YES;
    [self maskViewHideWithDuration:.2f];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint current = [touches.anyObject locationInView:self];
    CGPoint pre = [touches.anyObject previousLocationInView:self];
    
    if (touches.anyObject.view.tag == 0) { // 左上
        CGPoint move = CGPointMake(current.x - pre.x, current.y - pre.y);
        CGFloat moveFit = fabs(move.x) > fabs(move.y) ? move.x : move.y;
        
        CGFloat x = (self.lineWrap.frame.origin.x + moveFit) >= 0 ? (self.lineWrap.frame.origin.x + moveFit) : 0;
        if (x >= self.previewSize.width/3.f) {
            x = self.previewSize.width/3.f;
        }
        CGFloat y = (self.previewSize.height/self.previewSize.width) * x;
        self.lineWrap.frame = CGRectMake(x, y, self.previewSize.width - x, self.previewSize.height - y);
    } else if (touches.anyObject.view.tag == 1) { // 右上
        CGPoint move = CGPointMake(pre.x - current.x, current.y - pre.y);
        CGFloat moveFit = fabs(move.x) > fabs(move.y) ? move.x : move.y;
        
        CGFloat width = (self.lineWrap.frame.size.width - moveFit) <= self.previewSize.width ? (self.lineWrap.frame.size.width - moveFit) : self.previewSize.width;
        if (width <= self.previewSize.width*2/3.f) {
            width = self.previewSize.width*2/3.f;
        }
        CGFloat height = (self.previewSize.height/self.previewSize.width) * width;
        CGFloat y = self.previewSize.height - height;
        self.lineWrap.frame = CGRectMake(0, y, width, height);
    } else if (touches.anyObject.view.tag == 2) { // 左下
        CGPoint move = CGPointMake(current.x - pre.x, pre.y - current.y);
        CGFloat moveFit = fabs(move.x) > fabs(move.y) ? move.x : move.y;
        
        CGFloat x = (self.lineWrap.frame.origin.x + moveFit) >= 0 ? (self.lineWrap.frame.origin.x + moveFit) : 0;
        if (x >= self.previewSize.width/3.f) {
            x = self.previewSize.width/3.f;
        }
        CGFloat height = self.previewSize.height - x*(self.previewSize.height/self.previewSize.width);
        self.lineWrap.frame = CGRectMake(x, 0, self.previewSize.width - x, height);
    } else if (touches.anyObject.view.tag == 3) { // 右下
        CGPoint move = CGPointMake(pre.x - current.x, pre.y - current.y);
        CGFloat moveFit = fabs(move.x) > fabs(move.y) ? move.x : move.y;
        
        CGFloat width = (self.lineWrap.frame.size.width - moveFit) <= self.previewSize.width ? (self.lineWrap.frame.size.width - moveFit) : self.previewSize.width;
        if (width <= self.previewSize.width*2/3.f) {
            width = self.previewSize.width*2/3.f;
        }
        CGFloat height = (self.previewSize.height/self.previewSize.width) * width;;
        self.lineWrap.frame = CGRectMake(0, 0, width, height);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.lineWrap mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isMoving) {
        return;
    }
    
    CGRect orignalFrame = self.lineWrap.frame;

    self.imageWrap.hidden = YES;
    if (touches.anyObject.view.tag == 0) { // 左上
        self.lineWrap.layer.anchorPoint = CGPointMake(1, 1);
    } else if (touches.anyObject.view.tag == 1) { // 右上
        self.lineWrap.layer.anchorPoint = CGPointMake(0, 1);
    } else if (touches.anyObject.view.tag == 2) { // 左下
        self.lineWrap.layer.anchorPoint = CGPointMake(1, 0);
    } else if (touches.anyObject.view.tag == 3) { // 右下
        self.lineWrap.layer.anchorPoint = CGPointMake(0, 0);
    }
    self.lineWrap.frame = orignalFrame;
    if ([self.delegate respondsToSelector:@selector(editView:anchorPointIndex:rect:)]) {
        [self.delegate editView:self anchorPointIndex:touches.anyObject.view.tag rect:self.lineWrap.frame];
    }
    
    
    [UIView animateWithDuration:.2f animations:^{
        self.lineWrap.transform = CGAffineTransformMakeScale(self.previewSize.width/self.lineWrap.frame.size.width, self.previewSize.height/self.lineWrap.frame.size.height);
    } completion:^(BOOL finished) {
        self.isMoving = NO;
        self.imageWrap.hidden = NO;
        self.lineWrap.layer.anchorPoint = CGPointMake(.5f, .5f);
        self.lineWrap.transform = CGAffineTransformIdentity;
        self.lineWrap.frame = CGRectMake(0, 0, self.previewSize.width, self.previewSize.height);
    }];
}

#pragma mark - getter & setter
- (UIView *)preView {
    if (!_preView) {
        _preView = [[UIView alloc] init];
    }
    return _preView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:.85f];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.previewSize.width + self.margin.left + self.margin.right, self.previewSize.height + self.margin.top + self.margin.bottom)];
        [path appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(self.margin.left, self.margin.top, self.previewSize.width, self.previewSize.height)] bezierPathByReversingPath]];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        [_maskView.layer setMask:layer];
        
        _maskView.alpha = 0;
    }
    return _maskView;
}

- (UIView *)lineWrap {
    if (!_lineWrap) {
        _lineWrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.previewSize.width, self.previewSize.height)];
        
        UIView *top = [[UIView alloc] init];
        [_lineWrap addSubview:top];
        
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@1.5f);
        }];
        
        UIView *left = [[UIView alloc] init];
        [_lineWrap addSubview:left];
        
        [left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@1.5f);
        }];
        
        UIView *right = [[UIView alloc] init];
        [_lineWrap addSubview:right];
        
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(@1.5f);
        }];
        
        UIView *bottom = [[UIView alloc] init];
        [_lineWrap addSubview:bottom];
        
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@1.5f);
        }];
        
        top.layer.backgroundColor = UIColor.whiteColor.CGColor;
        top.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        top.layer.shadowOffset = CGSizeMake(0,0);
        top.layer.shadowOpacity = 1;
        top.layer.shadowRadius = 2;
        
        left.layer.backgroundColor = UIColor.whiteColor.CGColor;
        left.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        left.layer.shadowOffset = CGSizeMake(0,0);
        left.layer.shadowOpacity = 1;
        left.layer.shadowRadius = 2;
        
        bottom.layer.backgroundColor = UIColor.whiteColor.CGColor;
        bottom.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        bottom.layer.shadowOffset = CGSizeMake(0,0);
        bottom.layer.shadowOpacity = 1;
        bottom.layer.shadowRadius = 2;
        
        right.layer.backgroundColor = UIColor.whiteColor.CGColor;
        right.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
        right.layer.shadowOffset = CGSizeMake(0,0);
        right.layer.shadowOpacity = 1;
        right.layer.shadowRadius = 2;
        
        
        NSMutableArray *rowLines = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:1 alpha:.8f];
            [_lineWrap addSubview:line];
            [rowLines addObject:line];
            line.hidden = (i == 0 || i == 3) ? YES : NO;
        }
        
        [rowLines mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:1 leadSpacing:0 tailSpacing:0];
        [rowLines mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.right.equalTo(@0);
        }];
        
        NSMutableArray *columnLins = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:1 alpha:.8f];
            [_lineWrap addSubview:line];
            [columnLins addObject:line];
            line.hidden = (i == 0 || i == 3) ? YES : NO;
        }
        
        [columnLins mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:1 leadSpacing:0 tailSpacing:0];
        [columnLins mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
            make.top.bottom.equalTo(@0);
        }];
    }
    return _lineWrap;
}

- (UIView *)imageWrap {
    if (!_imageWrap) {
        _imageWrap = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIImageView *topLeft = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cycle_top_left" ofType:@"png"]]];
        topLeft.tag = 0;
        [_imageWrap addSubview:topLeft];
        [topLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.width.height.equalTo(@24);
        }];
        
        UIImageView *topright = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cycle_top_right" ofType:@"png"]]];
        topright.tag = 1;
        [_imageWrap addSubview:topright];
        [topright mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.width.height.equalTo(@24);
        }];
        
        UIImageView *bottomLeft = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cycle_bottom_left" ofType:@"png"]]];
        bottomLeft.tag = 2;
        [_imageWrap addSubview:bottomLeft];
        [bottomLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(@0);
            make.width.height.equalTo(@24);
        }];
        
        UIImageView *bottomRight = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cycle_bottom_right" ofType:@"png"]]];
        bottomRight.tag = 3;
        [_imageWrap addSubview:bottomRight];
        [bottomRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(@0);
            make.width.height.equalTo(@24);
        }];
    }
    return _imageWrap;
}
@end
