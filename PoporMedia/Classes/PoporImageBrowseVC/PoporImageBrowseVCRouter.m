//
//  PoporImageBrowseVCRouter.m
//  Pods
//
//  Created by apple on 2018/7/12.
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
