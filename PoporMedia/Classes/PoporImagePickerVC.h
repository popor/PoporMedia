//
//  BurstShotImagePickerVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoporMediaPrefix.h"
#import <SKFCamera/LLSimpleCamera.h>

typedef void(^PoporImagePickerFinishBlock) (NSArray * array);

@interface PoporImagePickerVC : UIViewController

@property (nonatomic, strong) LLSimpleCamera   *camera;
@property (strong, nonatomic) UILabel          *errorLabel;
@property (strong, nonatomic) UIButton         *snapButton;
@property (strong, nonatomic) UIButton         *switchButton;
@property (strong, nonatomic) UIButton         *flashButton;
@property (strong, nonatomic) UIButton         *backButton;

@property (nonatomic, strong) UIButton         *completeBT;

@property (nonatomic, strong) NSMutableArray   *imageArray;// 针对连拍图片数组
@property (nonatomic        ) int              maxNum;
@property (nonatomic, strong) UICollectionView *previewCV;
@property (nonatomic        ) CGSize           ccSize;

@property (nonatomic, copy  ) PoporImagePickerCameraBlock appearBlock;

- (id)initWithFinishBlock:(PoporImagePickerFinishBlock)block; // 拍摄单张图片,开启了编辑图片功能,
- (id)initWithMaxNum:(int)maxNum finishBlock:(PoporImagePickerFinishBlock)block; // 大于1张的话,不开启编辑图片功能.


@end
