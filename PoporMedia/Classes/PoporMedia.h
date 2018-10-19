//
//  PoporMedia.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAsset+data.h"

@class PHAsset;

typedef void(^PickImageFinishBlock)(NSArray *images, NSArray *assets, BOOL origin);
typedef void(^PickVideoFinishBlock)(NSURL * videoURL, NSString * videoPath, NSData *imageData, UIImage *image, PHAsset * phAsset, CGFloat time, CGFloat videoSize);

@class PoporVideoProvider;

@interface PoporMedia : NSObject

@property (nonatomic, copy  ) PickImageFinishBlock pickImageFinishBlock;
@property (nonatomic, strong) PoporVideoProvider * imageProvider;

#pragma mark - image
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin block:(PickImageFinishBlock)block;
// 可以增加自定义actions
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin actions:(NSArray *)actions block:(PickImageFinishBlock)block;

#pragma mark - video
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType block:(PickVideoFinishBlock)block;
// 可以增加自定义actions
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType actions:(NSArray *)actions block:(PickVideoFinishBlock)block;

@end
