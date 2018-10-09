//
//  PoporImageBrowseVCPresenter.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporImageBrowseVCEventHandler.h"
#import "PoporImageBrowseVCDataSource.h"

// 处理和View事件
@interface PoporImageBrowseVCPresenter : NSObject <PoporImageBrowseVCEventHandler, PoporImageBrowseVCDataSource>

- (void)setMyView:(id)view;
- (void)initInteractors;

@end
