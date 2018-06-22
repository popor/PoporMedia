//
//  UIImageView+sdWebImage.h
//  Wanzi
//
//  Created by 王凯庆 on 2016/12/16.
//  Copyright © 2016年 wanzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"

typedef NS_ENUM(NSUInteger, UploadFileTyp) {
    UploadFileType_Normal,
    UploadFileType_Chat,
    
};

typedef void(^ABCSDWebImageProgressBlock) (CGFloat progress);
typedef void(^ABCSDWebImageCompletionBlock)(UIImage * image, BOOL isDownloadOK);

@interface UIImageView (sdWebImage)

/**
 *  NSString *path = [[NSBundle mainBundle] pathForResource:@"smallcat" ofType:@"png"];
 *	UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
 *	在ipone5 s、iphone6和iphone6 plus都是优先加载@3x的图片，如果没有@3x的图片，就优先加载@2x的图片
 *	这个方法
 *	[UIImage imageNamed:@"smallcat"]
 *	iphone5s和iphone6优先加载@2x的图片，iphone6 plus是加载@3x的图片。
 *
 *  @param name 图片
 *
 */
- (id)initWithNamed:(NSString *)name;
- (id)initWithImage:(UIImage *)image;
/**
 *  老方法,请使用 (initWithNamed:)
 *
 *  @param name     图片
 *  @param isRetina 是否高清图片
 *
 */
//- (id)initWithNamed:(NSString *)name isRetina:(BOOL)isRetina  NS_DEPRECATED_IOS(2_0, 7_0, "Use -initWithNamed:");


- (void)abcsd_ImageUrl:(NSString *)url;
- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder;
- (void)abcsd_ImageUrl:(NSString *)url completed:(ABCSDWebImageCompletionBlock)completedBlock;
- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(ABCSDWebImageCompletionBlock)completedBlock;
- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder progress:(ABCSDWebImageProgressBlock)progress completed:(ABCSDWebImageCompletionBlock)completedBlock;

@end
