//
//  PoporImageBrowseVCPresenter.h
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import <Foundation/Foundation.h>
#import "PoporImageBrowseVCEventHandler.h"
#import "PoporImageBrowseVCDataSource.h"

// 处理和View事件
@interface PoporImageBrowseVCPresenter : NSObject <PoporImageBrowseVCEventHandler, PoporImageBrowseVCDataSource>

- (void)setMyView:(id)view;
- (void)initInteractors;

@end
