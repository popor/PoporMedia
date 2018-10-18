//
//  BurstShotImagePreviewVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <PoporImageBrower/PoporImageBrower.h>
#import "PoporMediaImageEntity.h"
#import <PoporFoundation/PrefixBlock.h>

// 预览
@interface BurstShotImagePreviewVC : PoporImageBrower
@property (nonatomic, strong) UIColor * toolBarColor;

@property (nonatomic, copy  ) BlockPVoid completeBlock; // 完成按钮事件


@end
