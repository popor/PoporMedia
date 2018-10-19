//
//  VideoEntity.h
//  PoporMedia_Example
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoEntity : NSObject

@property (nonatomic, strong) UIImage  *videoImage; // 拍摄的截图
@property (nonatomic, strong) NSData  *videoImageData; // 相册的截图

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSString *videoPath;

@end

NS_ASSUME_NONNULL_END
