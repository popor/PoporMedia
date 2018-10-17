//
//  ImageProvider.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 主要是将UploadImageCommonVC的内容独立出来.
 * 该框架仍然使用老的压缩比例,3.78.00
 *
 * 选择全景图有问题
 */

typedef void(^ImageProvider_desSelectImage)(void); // __BlockTypedef
typedef void(^ImageProvider_hasSelectImage)(UIImage * editedImage); // __BlockTypedef

typedef void(^ImageProvider_hasTakeVideo)(NSString * videoPath); // __BlockTypedef

@protocol ImageProvider_delegate <NSObject>

@optional
- (void)hasSelectImage:(UIImage *)editedImage;
- (void)desSelectImage;

@end

@interface ImageProvider : NSObject

@property (nonatomic        ) BOOL   isAutoImageFrame;
@property (nonatomic        ) CGRect editPhotoFrame;
@property (nonatomic        ) BOOL   isNeedSavePhoto;// 默认拍照时候开启

@property (nonatomic, weak ) UIImagePickerController * imagePC; // 图片采集器
@property (nonatomic, copy  ) ImageProvider_desSelectImage desSelectImageBlock;
@property (nonatomic, copy  ) ImageProvider_hasSelectImage hasSelectImageBlock;
@property (nonatomic, copy  ) ImageProvider_hasTakeVideo   hasTakeVideo;

//- (void)setImageDelegate:(id)oneDelegate;
- (void)setImageDelegate:(id)oneDelegate superVC:(UIViewController *)superVC ;

/**
 @abstract 使用相册
 */
- (void)selectPhotoFromPhotoLibrary;

/**
 @abstract 使用相机
 */
- (void)selectPhotoFromCamera;

- (void)takeVideoFromCamera;

- (void)closeImagePC;

@end
