//
//  PoporAVPlayerVCRouter.m
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import "PoporAVPlayerVCRouter.h"
#import "PoporAVPlayerVCPresenter.h"
#import "PoporAVPlayerVC.h"

@implementation PoporAVPlayerVCRouter

+ (UIViewController *)vcWithDic:(NSDictionary *)dic {
    PoporAVPlayerVC * vc = [[PoporAVPlayerVC alloc] initWithDic:dic];
    PoporAVPlayerVCPresenter * present = [PoporAVPlayerVCPresenter new];
    
    [vc setMyPresent:present];
    [present setMyView:vc];
    
    return vc;
}

+ (void)setVCPresent:(UIViewController *)vc {
    if ([vc isKindOfClass:[PoporAVPlayerVC class]]) {
        PoporAVPlayerVC * oneVC = (PoporAVPlayerVC *)vc;
        PoporAVPlayerVCPresenter * present = [PoporAVPlayerVCPresenter new];
        
        [oneVC setMyPresent:present];
        [present setMyView:oneVC];
    }
}

@end
