//
//  BurstShotImagePreviewCC.h
//  linRunShengPi
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDisplayEntity.h"

@interface BurstShotImagePreviewCC : UICollectionViewCell

@property (nonatomic, strong) UIImageView * iconIV;
@property (nonatomic, strong) UIButton    * selectBT;
@property (nonatomic, weak  ) ImageDisplayEntity * weakEntity;

- (void)setImageEntity:(ImageDisplayEntity *)entity;

@end
