//
//  PoporImageBrowseVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PoporImageBrowseVCEventHandler.h"
#import "PoporImageBrowseVCDataSource.h"
#import "PoporImageBrowseVCProtocol.h"

@interface PoporImageBrowseVC : UIViewController <PoporImageBrowseVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)browse;

@end
