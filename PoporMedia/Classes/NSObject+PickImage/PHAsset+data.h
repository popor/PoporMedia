//
//  PHAsset+data.h
//  linRunShengPi
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (data)

+ (void)getImageFromPHAsset:(PHAsset *)asset finish:(void (^)(NSData *data))block;

@end
