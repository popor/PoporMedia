//
//  PoporImageBrowseVCRouter.m
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import "PoporImageBrowseVCRouter.h"
#import "PoporImageBrowseVCPresenter.h"
#import "PoporImageBrowseVC.h"

@implementation PoporImageBrowseVCRouter

+ (UIViewController *)vcWithDic:(NSDictionary *)dic {
    PoporImageBrowseVC * vc = [[PoporImageBrowseVC alloc] initWithDic:dic];
    PoporImageBrowseVCPresenter * present = [PoporImageBrowseVCPresenter new];
    
    [vc setMyPresent:present];
    [present setMyView:vc];
    
    [vc browse];
    
    return vc;
}

+ (void)setVCPresent:(UIViewController *)vc {
    if ([vc isKindOfClass:[PoporImageBrowseVC class]]) {
        PoporImageBrowseVC * oneVC = (PoporImageBrowseVC *)vc;
        PoporImageBrowseVCPresenter * present = [PoporImageBrowseVCPresenter new];
        
        [oneVC setMyPresent:present];
        [present setMyView:oneVC];
    }
}

@end
