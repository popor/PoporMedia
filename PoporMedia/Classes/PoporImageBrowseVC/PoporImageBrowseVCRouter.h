//
//  PoporImageBrowseVCRouter.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporImageBrowsePrefix.h"

// 处理View跳转和viper组件初始化
@interface PoporImageBrowseVCRouter : NSObject

+ (UIViewController *)vcWithDic:(NSDictionary *)dic;
+ (void)setVCPresent:(UIViewController *)vc;

@end
