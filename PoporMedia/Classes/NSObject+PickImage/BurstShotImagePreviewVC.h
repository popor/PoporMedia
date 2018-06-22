//
//  BurstShotImagePreviewVC.h
//  linRunShengPi
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import "ImageDisplayVC.h"
#import "ImageDisplayEntity.h"

typedef void(^BurstShotImagePreviewCompleteBlock) (void);

@interface BurstShotImagePreviewVC : ImageDisplayVC

@property (nonatomic, weak  ) NSMutableArray * weakImageArray;
@property (nonatomic, copy  ) BurstShotImagePreviewCompleteBlock completeBlock;


@end
