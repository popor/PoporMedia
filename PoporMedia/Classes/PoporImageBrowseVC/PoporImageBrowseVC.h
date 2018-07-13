//
//  PoporImageBrowseVC.h
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import <UIKit/UIKit.h>
#import "PoporImageBrowseVCEventHandler.h"
#import "PoporImageBrowseVCDataSource.h"
#import "PoporImageBrowseVCProtocol.h"

@interface PoporImageBrowseVC : UIViewController <PoporImageBrowseVCProtocol>

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)browse;

@end
