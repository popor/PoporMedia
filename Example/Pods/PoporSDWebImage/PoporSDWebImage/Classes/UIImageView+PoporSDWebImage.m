//
//  UIImageView+Tool.m
//  Wanzi
//
//  Created by 王凯庆 on 16/10/22.
//  Copyright © 2016年 wanzi. All rights reserved.
//

#import "UIImageView+PoporSDWebImage.h"
#import "SDWebImageManager.h"

@implementation UIImageView (PoporSDWebImage)

+ (BOOL)isSDImageExist:(NSString *)url {
    return [UIImageView isFileExist:[UIImageView SDImagePath:url]];
}

+ (NSString *)SDImagePath:(NSString *)url {
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    NSURL * imageURL     = [NSURL URLWithString:url];
    NSString * imageKey  = [manager cacheKeyForURL:imageURL];
    NSString * imagePath = [manager.imageCache defaultCachePathForKey:imageKey];
    return imagePath;
}

+ (NSString *)SDImageKey:(NSString *)url {
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    NSURL * imageURL     = [NSURL URLWithString:url];
    NSString * imageKey  = [manager cacheKeyForURL:imageURL];
    return imageKey;
}

- (BOOL)setSyncSDImageUrl:(NSString *)url {
    self.image = [UIImageView imageSyncSDImageUrl:url];
    if (self.image) {
        return YES;
    }else{
        return NO;
    }
}

+ (UIImage *)imageSyncSDImageUrl:(NSString *)url {
    return [UIImageView createWithAbsImageName:[UIImageView SDImagePath:url]];
}

+ (NSString *)cachePath {
    NSString * folder = [UIImageView SDImagePath:@"a.jpg"];
    NSURL * url = [NSURL URLWithString:folder];
    folder = [folder substringToIndex:folder.length - [url lastPathComponent].length];
    
    return folder;
}

#pragma mark - 额外的补充函数
+ (BOOL)isFileExist:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 如果存在的话，直接返回就好了。
        return YES;
    }else {
        return NO;
    }
    // end.
}

+ (UIImage *)createWithAbsImageName:(NSString *)imageName {
    UIImage * image=[UIImage imageWithContentsOfFile:imageName];
    if (image.imageOrientation != UIImageOrientationUp) {
        image=[UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
    }
    return image;
}

@end

