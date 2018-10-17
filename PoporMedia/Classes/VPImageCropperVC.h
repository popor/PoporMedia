//
//  VPImageCropperVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VPImageCropperDelegate <NSObject>

- (void)imageCropper:(UIViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(UIViewController *)cropperViewController;

@end

@interface VPImageCropperVC : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
