//
//  ImageFromIphone.m
//  WanziTG
//
//  Created by popor on 15/4/9.
//  Copyright (c) 2015年 wanzi. All rights reserved.
//

#import "ImageProvider.h"
#import <UIKit/UIKit.h>

// 拍摄视频
#import <MobileCoreServices/MobileCoreServices.h>

#import "VPImageCropperVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIDevice+Tool.h"
#import "UIDevice+Permission.h"
#import "UIDevice+SaveImage.h"

#import <PoporFoundation/PrefixSize.h>

@interface ImageProvider ()
<
UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate // 截取图片部分
>
@property(nonatomic, weak)id<ImageProvider_delegate> imageProvider_delegate;
@property(nonatomic, weak)UIViewController * superVC;

@end

@implementation ImageProvider

- (id)init
{
    if(self = [super init]){
#pragma mark - WKQ 被踢下线的话,需要关闭自己.
        //Service * oneS=[Service getDefaultService];
        //oneS.recorder.vc.imageProvider = self;
    }
    return self;
}

- (void)setImageDelegate:(id)oneDelegate superVC:(UIViewController *)superVC {
    self.imageProvider_delegate=oneDelegate;
    self.superVC = superVC;
}

- (void)closeImagePC {
    if (self.imagePC) {
        [self.imagePC dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)selectPhotoFromPhotoLibrary {
    self.isNeedSavePhoto = NO;
    [UIDevice isHaveSysPowerForAlbumBlock:^(BOOL isFirst, BOOL isHavePermission) {
        if (isHavePermission) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            self.imagePC = controller;
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            
            [self.superVC presentViewController:controller animated:YES completion:^(void){
                NSLog(@"Picker View Controller is presented");
            }];
        }
    }];
}

- (void)selectPhotoFromCamera {
    self.isNeedSavePhoto = YES;
    [UIDevice isHaveSysPermissionCameraBlock:^(BOOL isFirst, BOOL isHavePermission) {
        if (isHavePermission) {
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                self.imagePC = controller;
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                //if ([self isFrontCameraAvailable]) {
                //    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                //}
                if ([self isRearCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self.superVC presentViewController:controller animated:YES completion:^(void){
                    NSLog(@"Picker View Controller is presented");
                }];
            }
        }
    }];
}

- (void)takeVideoFromCamera {
    //self.isNeedSavePhoto = YES;
    [UIDevice isHaveSysPermissionCameraBlock:^(BOOL isFirst, BOOL isHavePermission) {
        if (isHavePermission) {
            [UIDevice isHaveSysPermissionAudioBlock:^(BOOL isFirst, BOOL isHavePermission) {
                if (isHavePermission) {
                    [self showTakeVideoFromCameraEvent];
                }
            }];
        }
    }];
}

- (void)showTakeVideoFromCameraEvent {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller;
        
        controller = [[UIImagePickerController alloc]init];
        controller.sourceType   = UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        
        // 清晰度
        //controller.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
        //controller.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        controller.videoQuality = UIImagePickerControllerQualityType640x480;
        
        if ([self isRearCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        }
        {
            controller.mediaTypes        = @[(NSString *)kUTTypeMovie];
            controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            controller.allowsEditing     = YES;//允许编辑
            controller.delegate          = self;//设置代理，检测操作
        }
        
        self.imagePC = controller;
        
        controller.delegate = self;
        [self.superVC presentViewController:controller animated:YES completion:^(void){
            NSLog(@"Picker View Controller is presented");
        }];
        
    }
}

//作者：Realank
//链接：https://www.jianshu.com/p/e3681c4e7a1d
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
#pragma mark [设置头像]
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(UIViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // 进行裁切的代码
        if (self.imageProvider_delegate && [self.imageProvider_delegate respondsToSelector:@selector(hasSelectImage:)]) {
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self.imageProvider_delegate hasSelectImage:editedImage];
        }
        if (self.hasSelectImageBlock) {
            self.hasSelectImageBlock(editedImage);
        }
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperVC *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (self.imageProvider_delegate && [self.imageProvider_delegate respondsToSelector:@selector(desSelectImage)]) {
            //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [self.imageProvider_delegate desSelectImage];
        }
        if (self.desSelectImageBlock) {
            self.desSelectImageBlock();
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // 保存图片到相册文件夹
        [UIDevice isHaveSysPowerForAlbumAlert:NO block:^(BOOL isFirst, BOOL isHavePermission) {
            if (isHavePermission) {
                //[UIDevice saveImageToPhotos:portraitImg showAlert:NO];
                [UIDevice saveImage:portraitImg imageUrl:nil videoUrl:nil collectionName:nil showAlert:NO];
            }
        }];
        if (self.isAutoImageFrame) {
            // 不进行剪切的代码
            portraitImg =[self imageByScalingAndCroppingForSourceImage:portraitImg targetSize:portraitImg.size];
            if (self.imageProvider_delegate && [self.imageProvider_delegate respondsToSelector:@selector(hasSelectImage:)]) {
                //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                [self.imageProvider_delegate hasSelectImage:portraitImg];
            }
            if (self.hasSelectImageBlock) {
                self.hasSelectImageBlock(portraitImg);
            }
        }else{
            //上传图片的时候会做压缩处理，所以这里就不做裁剪了
            //        portraitImg = [self imageByScalingToMaxSize:portraitImg];
            // 裁剪
            if (CGRectEqualToRect(self.editPhotoFrame, CGRectZero)) {
                self.editPhotoFrame=CGRectMake(0, 0, self.superVC.view.frame.size.width, self.superVC.view.frame.size.width);
            }
            self.editPhotoFrame=CGRectMake(0, (ScreenSize.height-self.editPhotoFrame.size.height)/2, self.editPhotoFrame.size.width
                                           , self.editPhotoFrame.size.height);
            VPImageCropperVC *imgEditorVC = [[VPImageCropperVC alloc] initWithImage:portraitImg cropFrame:self.editPhotoFrame limitScaleRatio:3.0];
            imgEditorVC.delegate = self;
            [self.superVC presentViewController:imgEditorVC animated:YES completion:^{
                // TO DO
            }];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL * url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        __weak typeof(self) weakSelf = self;
        [UIDevice isHaveSysPowerForAlbumAlert:NO block:^(BOOL isFirst, BOOL isHavePermission) {
            if (isHavePermission) {
                [UIDevice saveImage:nil imageUrl:nil videoUrl:url collectionName:nil showAlert:NO];
            }
        }];
        
        if(weakSelf.hasTakeVideo){
            weakSelf.hasTakeVideo([url path]);
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self.imageProvider_delegate && [self.imageProvider_delegate respondsToSelector:@selector(desSelectImage)]) {
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self.imageProvider_delegate desSelectImage];
    }
    if (self.desSelectImageBlock) {
        self.desSelectImageBlock();
    }
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - 裁切图片
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ScreenSize.width) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ScreenSize.width;
        btWidth = sourceImage.size.width * (ScreenSize.width / sourceImage.size.height);
    } else {
        btWidth = ScreenSize.width;
        btHeight = sourceImage.size.height * (ScreenSize.width / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
