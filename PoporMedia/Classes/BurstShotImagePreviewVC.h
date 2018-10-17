//
//  BurstShotImagePreviewVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <PoporImageBrower/PoporImageBrower.h>
#import "PoporMediaImageEntity.h"

typedef void(^BurstShotImagePreviewCompleteBlock) (void);

// 预览
@interface BurstShotImagePreviewVC : PoporImageBrower

@property (nonatomic, weak  ) NSMutableArray<PoporMediaImageEntity *> * weakImageArray;

@property (nonatomic, copy  ) BurstShotImagePreviewCompleteBlock completeBlock;


@end
