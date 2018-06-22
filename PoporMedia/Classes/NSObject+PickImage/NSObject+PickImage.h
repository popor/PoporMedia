//
//  NSObject+PickImage.h
//  linRunShengPi
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAsset+data.h"
//#import "UIView+UploadStatus.h"

@class PHAsset;

typedef void(^PickImageFinishBlock)(NSArray *images, NSArray *assets, BOOL origin);
typedef void(^PickVideoFinishBlock)(NSString * videoPath, NSData *imageData, UIImage *image, PHAsset * phAsset, CGFloat time, CGFloat videoSize);

@class ImageProvider;

@interface NSObject (PickImage)

@property (nonatomic, copy  ) PickImageFinishBlock pickImageFinishBlock;
@property (nonatomic, strong) ImageProvider * imageProvider;

#pragma mark - image
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin block:(PickImageFinishBlock)block;
// 可以增加自定义actions
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin actions:(NSArray *)actions block:(PickImageFinishBlock)block;

#pragma mark - video
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size block:(PickVideoFinishBlock)block;
// 可以增加自定义actions
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size actions:(NSArray *)actions block:(PickVideoFinishBlock)block;

@end
