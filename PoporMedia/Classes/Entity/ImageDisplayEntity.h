//
//  ImageDisplayEntity.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDisplayEntity : NSObject

@property (nonatomic, strong) NSString * originImageUrl;
@property (nonatomic        ) BOOL     cachedOriginal;
@property (nonatomic        ) CGRect   thumbnailImageRect;
@property (nonatomic        ) CGRect   thumbnailImageBounds;

@property (nonatomic, strong) UIImage  * originImage;
@property (nonatomic, strong) UIImage  * iconImage;// 缩略图
@property (nonatomic, strong) NSString * title;

@property (nonatomic, weak  ) NSObject * weakOriginEntity;


@property (nonatomic, getter=isIgnore) BOOL ignore;  // 是否忽略,用于NSObject+PickImage

- (id)initWithUrl:(NSString *)originImageUrl originImage:(UIImage *)originImage rect:(CGRect)rect;

@end
