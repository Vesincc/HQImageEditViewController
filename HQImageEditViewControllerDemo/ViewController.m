//
//  ViewController.m
//  HQImageEdit
//
//  Created by iOS on 2019/4/16.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "ViewController.h"
#import "HQImageEditViewController/HQImageEditViewController.h"

@interface ViewController () <HQImageEditViewControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点击屏幕裁剪图片";
    
    [self.view addSubview:self.imageView];
    
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
    vc.originImage = [UIImage imageNamed:@"25"];
    vc.delegate = self;
    vc.editViewSize = CGSizeMake(300, 200);
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HQImageEditViewControllerDelegate
- (void)editController:(HQImageEditViewController *)vc finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage {
    self.imageView.image = originSizeImage;
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [vc.navigationController popViewControllerAnimated:YES];
}

- (void)editControllerDidClickCancel:(HQImageEditViewController *)vc {
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [vc.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter & setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
