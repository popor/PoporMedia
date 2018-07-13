//
//  PoporImageBrowseVCRouter.h
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import <Foundation/Foundation.h>
#import "PoporImageBrowsePrefix.h"

// 处理View跳转和viper组件初始化
@interface PoporImageBrowseVCRouter : NSObject

+ (UIViewController *)vcWithDic:(NSDictionary *)dic;
+ (void)setVCPresent:(UIViewController *)vc;

@end
