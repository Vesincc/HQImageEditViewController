//
//  HQEditImageActionView.m
//  CivilAviation
//
//  Created by iOS on 2019/3/29.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "HQEditImageActionView.h"

@interface HQEditImageActionView ()

@property (nonatomic, strong) UIView *line;

@end

@implementation HQEditImageActionView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.85f];
        
        [self addSubview:self.rotateButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.originButton];
        [self addSubview:self.finishButton];
        
        [self addSubview:self.line];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(25 + 40));
        make.height.equalTo(@49);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.equalTo(@50);
        make.height.equalTo(@49);
        make.top.equalTo(@49);
    }];
    
    [self.originButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@49);
        make.top.equalTo(@49);
        make.centerX.equalTo(@0);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.width.equalTo(@50);
        make.height.equalTo(@49);
        make.top.equalTo(@49);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@49);
        make.left.right.equalTo(@0);
        make.height.equalTo(@.7f);
    }];
}

#pragma mrak - event response
- (void)buttonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(action:didClickButton:atIndex:)]) {
        [self.delegate action:self didClickButton:button atIndex:button.tag];
    }
}

#pragma mark - getter & setter
- (UIButton *)rotateButton {
    if (!_rotateButton) {
        _rotateButton = [[UIButton alloc] init];
        
        [_rotateButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_rotate_90_degrees_ccw" ofType:@"png"]] forState:UIControlStateNormal];
        _rotateButton.tag = 0;
        _rotateButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rotateButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@25);
            make.center.equalTo(@0);
        }];
        [_rotateButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _cancelButton.tag = 1;
        [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)originButton {
    if (!_originButton) {
        _originButton = [[UIButton alloc] init];
        
        [_originButton setTitle:@"还原" forState:UIControlStateNormal];
        [_originButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _originButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _originButton.tag = 2;
        [_originButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originButton;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _finishButton.tag = 3;
        [_finishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:1 alpha:.3f];
    }
    return _line;
}

@end
