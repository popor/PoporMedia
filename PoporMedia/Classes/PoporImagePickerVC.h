//
//  BurstShotImagePickerVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePickerFinishBlock)    (NSArray * array);

@interface PoporImagePickerVC : UIViewController

- (id)initWithFinishBlock:(ImagePickerFinishBlock)block; // 拍摄单张图片,开启了编辑图片功能,
- (id)initWithMaxNum:(int)maxNum finishBlock:(ImagePickerFinishBlock)block; // 大于1张的话,不开启编辑图片功能.


@end
