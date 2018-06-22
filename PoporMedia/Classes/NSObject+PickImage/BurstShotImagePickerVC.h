//
//  BurstShotImagePickerVC.h
//  linRunShengPi
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePickerFinishBlock)    (NSArray * array);

@interface BurstShotImagePickerVC : UIViewController

- (id)initWithFinishBlock:(ImagePickerFinishBlock)block; // 拍摄单张图片,开启了编辑图片功能,
- (id)initWithMaxNum:(int)maxNum finishBlock:(ImagePickerFinishBlock)block; // 大于1张的话,不开启编辑图片功能.


@end
