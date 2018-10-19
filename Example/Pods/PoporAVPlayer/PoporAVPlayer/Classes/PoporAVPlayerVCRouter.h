//
//  PoporAVPlayerVCRouter.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>

// 处理View跳转和viper组件初始化
@interface PoporAVPlayerVCRouter : NSObject

+ (UIViewController *)vcWithDic:(NSDictionary *)dic;
+ (void)setVCPresent:(UIViewController *)vc;

@end
