//
//  BurstShotImagePreviewVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import "ImageDisplayVC.h"
#import "ImageDisplayEntity.h"

typedef void(^BurstShotImagePreviewCompleteBlock) (void);

@interface BurstShotImagePreviewVC : ImageDisplayVC

@property (nonatomic, weak  ) NSMutableArray * weakImageArray;
@property (nonatomic, copy  ) BurstShotImagePreviewCompleteBlock completeBlock;


@end
