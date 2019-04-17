# HQImageEditViewController
头像裁剪、图片裁剪<br>

## CocoaPods
```
pod 'HQImageEditViewController'
```

## ScreenShot
正方形裁剪框<br>
![image](https://github.com/Vesincc/HQImageEditViewController/blob/master/QQ20190416-155405-HD.gif)

矩形裁剪框<br>
![image](https://github.com/Vesincc/HQImageEditViewController/blob/master/QQ20190416-155714-HD.gif)

## import
```objc
#import <HQImageEditViewController.h>
```

## Use
```objc
HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
vc.originImage = [UIImage imageNamed:@"25"];
vc.delegate = self;
[self.navigationController pushViewController:vc animated:YES];
```

## Delegate
```objc

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
```

## 裁剪框
```objc
HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
vc.editViewSize = CGSizeMake(300, 200);
```

## 裁剪蒙层
```objc
HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
vc.maskViewAnimation = YES;
```

