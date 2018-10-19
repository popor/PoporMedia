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

typedef void(^PoporImageFinishBlock)(NSArray *images, NSArray *assets, BOOL origin);
typedef void(^PoporVideoFinishBlock)(NSURL * videoURL, NSString * videoPath, NSData *imageData, UIImage *image, PHAsset * phAsset, CGFloat time, CGFloat videoSize);

@class PoporVideoProvider;

@interface PoporMedia : NSObject

@property (nonatomic, copy  ) PoporImageFinishBlock PoporImageFinishBlock;
@property (nonatomic, strong) PoporVideoProvider * imageProvider;

#pragma mark - image
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin block:(PoporImageFinishBlock)block;
// 可以增加自定义actions
- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin actions:(NSArray *)actions block:(PoporImageFinishBlock)block;

#pragma mark - video
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType block:(PoporVideoFinishBlock)block;
// 可以增加自定义actions
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size qualityType:(UIImagePickerControllerQualityType)qualityType actions:(NSArray *)actions block:(PoporVideoFinishBlock)block;

@end
