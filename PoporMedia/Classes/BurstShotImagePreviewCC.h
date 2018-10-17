//
//  BurstShotImagePreviewCC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoporMediaImageEntity.h"

@interface BurstShotImagePreviewCC : UICollectionViewCell

@property (nonatomic, strong) UIImageView * iconIV;
@property (nonatomic, strong) UIButton    * selectBT;
@property (nonatomic, weak  ) PoporMediaImageEntity * weakEntity;

- (void)setImageEntity:(PoporMediaImageEntity *)entity;

@end
