//
//  UIImageView+Tool.h
//  Wanzi
//
//  Created by 王凯庆 on 16/10/22.
//  Copyright © 2016年 wanzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PoporSDWebImage)

// 图片是否缓存
+ (BOOL)isSDImageExist:(NSString *)url;
+ (NSString *)SDImagePath:(NSString *)url;
+ (NSString *)SDImageKey:(NSString *)url;

// 同步设施图片
- (BOOL)setSyncSDImageUrl:(NSString *)url;
+ (UIImage *)imageSyncSDImageUrl:(NSString *)url;
+ (NSString *)cachePath;

@end
