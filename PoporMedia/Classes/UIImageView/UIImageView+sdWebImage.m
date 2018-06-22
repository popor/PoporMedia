//
//  UIImageView+sdWebImage.m
//  Wanzi
//
//  Created by 王凯庆 on 2016/12/16.
//  Copyright © 2016年 wanzi. All rights reserved.
//

#import "UIImageView+sdWebImage.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (sdWebImage)

- (id)initWithNamed:(NSString *)name
{
    self=[super init];
    if (self) {
        self.image = [UIImage imageNamed:name];
        self.frame=CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
    return self;
}
/**
 重构系统方法,移除警告
 http://www.cnblogs.com/zyi1992/p/4832716.html
 
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
 
 // your override
 
 #pragma clang diagnostic pop
 
 2.在target的 build settings下  搜索other warning flags  然后给其添加 -Wno-objc-protocol-method-implementation
 
 好了  警告没有了
 
 这里顺便说一下  2中的方法  对很多批量的警告很有用  而后面相关字段 -Wno-objc-protocol-method-implementation  其实是可以查得到的    方法是在xcode中选择你想屏蔽的警告，右键选择 reveal in log 就可以在警告详情中发现 -Wobjc-protocol-method-implementation  这么一个格式的字段 在-W后添加一个no-  然后在用2中的方法添加到 other warning flags 中 就可以处理大部分的警告了
 
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id)initWithImage:(UIImage *)image;
{
    self = [super init];
    if (self) {
        self.image = image;
        self.frame=CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
    return self;
}
#pragma clang diagnostic pop

- (void)abcsd_ImageUrl:(NSString *)url
{
    [self abcsd_ImageUrl:url placeholderImage:nil progress:nil completed:nil];
}

- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    [self abcsd_ImageUrl:url placeholderImage:placeholder progress:nil completed:nil];
}

- (void)abcsd_ImageUrl:(NSString *)url completed:(ABCSDWebImageCompletionBlock)completedBlock
{
    [self abcsd_ImageUrl:url placeholderImage:nil progress:nil completed:completedBlock];
}

- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(ABCSDWebImageCompletionBlock)completedBlock
{
    [self abcsd_ImageUrl:url placeholderImage:placeholder progress:nil completed:completedBlock];
}

- (void)abcsd_ImageUrl:(NSString *)url placeholderImage:(UIImage *)placeholder progress:(ABCSDWebImageProgressBlock)progress completed:(ABCSDWebImageCompletionBlock)completedBlock
{
    // NSLog(@"阿里图片 IV url: %@", url);
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progress) {
            dispatch_main_async_safe(^{
                progress((CGFloat)receivedSize/expectedSize);
            });
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            if (completedBlock) {
                completedBlock(nil, NO);
            }
        }else{
            //            if (IsDebugVersion) {
            //                if (image.size.width>ABCSdImageAlertWidth) {
            //                    {
            //                        NSString * alertInfo = [NSString stringWithFormat:@"IV 图片太大: %i - %i, 已经复制到粘贴板中", (int)image.size.width, (int)image.size.height];
            //                        AlertToastTitle(alertInfo);
            //                        NSLog(@"图片太大警告: %@, url:%@", alertInfo, url);
            //
            //                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            //                        [pasteboard setString:url];
            //                    }
            //                    //                    {
            //                    //                        UIAlertView * oneAV = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"IV 图片太大: %i - %i", (int)image.size.width, (int)image.size.height] message:url delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                    //                        [oneAV showWithBlock:^(NSInteger buttonIndex) {
            //                    //                            NSLog(@"\n!!!!!\n\n\n图片网址是: %@\n\n\n!!!!!", url);
            //                    //
            //                    //                            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            //                    //                            [pasteboard setString:url];
            //                    //                            AlertToastTitle(@"已经将网址复制到粘贴板");
            //                    //                        }];
            //                    //                    }
            //                }
            //            }
            if (completedBlock) {
                completedBlock(self.image, YES);
            }
        }
    }];
}

@end
