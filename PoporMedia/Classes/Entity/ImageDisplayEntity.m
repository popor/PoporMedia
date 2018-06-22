//
//  ImageDisplayEntity.m
//  Wanzi
//
//  Created by 王凯庆 on 2017/1/3.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import "ImageDisplayEntity.h"
#import <PoporSDWebImage/UIImageView+PoporSDWebImage.h>

@implementation ImageDisplayEntity

- (id)initWithUrl:(NSString *)originImageUrl originImage:(UIImage *)originImage rect:(CGRect)rect {
    if (self = [super init]) {
        self.originImageUrl       = originImageUrl;
        self.cachedOriginal       = [UIImageView isSDImageExist:originImageUrl];
        self.thumbnailImageRect   = rect;
        self.thumbnailImageBounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.originImage          = originImage;
    }
    return self;
}

@end
