//
//  NSObject+PickImage.m
//  linRunShengPi
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import "NSObject+PickImage.h"
#import <objc/runtime.h>

#import "ImageProvider.h"
#import "BurstShotImagePickerVC.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import "NSFileManager+Tool.h"
#import <PoporUI/IToastKeyboard.h>

@implementation NSObject (PickImage)

@dynamic pickImageFinishBlock;

- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin block:(PickImageFinishBlock)block {
    [self showImageACTitle:title message:message vc:vc maxCount:maxCount origin:origin actions:nil block:block];
}

- (void)showImageACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc maxCount:(int)maxCount origin:(BOOL)origin actions:(NSArray *)actions block:(PickImageFinishBlock)block
{
    __weak typeof(vc) weakVC = vc;
    __weak typeof(self) weakSelf = self;
    weakSelf.pickImageFinishBlock = block;
    
    UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * camerAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BurstShotImagePickerVC * vc=[[BurstShotImagePickerVC alloc] initWithMaxNum:maxCount finishBlock:^(NSArray *array) {
            [weakSelf hasSelectImages:array assets:nil origin:origin];
        }];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [weakVC presentViewController:nc animated:YES completion:nil];
    }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"使用相册");
        
        TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        vc.allowPickingImage         = YES;
        vc.allowPickingVideo         = NO;
        vc.allowTakePicture          = NO;
        vc.allowPickingOriginalPhoto = origin;
        
        [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf hasSelectImages:photos assets:assets origin:isSelectOriginalPhoto];
        }];
        
        [weakVC presentViewController:vc animated:YES completion:nil];
    }];
    
    [oneAC addAction:cancleAction];
    [oneAC addAction:camerAction];
    [oneAC addAction:albumAction];
    for (UIAlertAction * oneAction in actions) {
        [oneAC addAction:oneAction];
    }
    [weakVC presentViewController:oneAC animated:YES completion:nil];
}

#pragma mark 上传图片
- (void)hasSelectImages:(NSArray *)images assets:(NSArray *)assets origin:(BOOL)origin {
    if (self.pickImageFinishBlock) {
        self.pickImageFinishBlock(images, assets, origin);
    }
}

#pragma mark - video
- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size block:(PickVideoFinishBlock)block {
    [self showVideoACTitle:title message:message vc:vc videoIconSize:size actions:nil block:block];
}

- (void)showVideoACTitle:(NSString *)title message:(NSString *)message vc:(UIViewController *)vc videoIconSize:(CGSize)size actions:(NSArray *)actions block:(PickVideoFinishBlock)block{
    
    __weak typeof(vc) weakVC = vc;
    __weak typeof(self) weakSelf = self;
    
    UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"使用相册");
        // 视频目前只能单独选择
        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        imagePickerVC.allowPickingImage         = NO;
        imagePickerVC.allowPickingVideo         = YES;
        imagePickerVC.allowTakePicture          = NO;
        imagePickerVC.allowPickingOriginalPhoto = NO;
        
        [imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            NSLog(@"1");
            
            [NSObject iosVideoUrlWithPHAsset:asset block:^(NSString *fileUrl, NSString *fileTitle) {
                NSLog(@"2");
                NSLog(@"fileUrl:%@, fileTitle:%@", fileUrl, fileTitle);
                
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
                option.normalizedCropRect = CGRectMake(0, 0, size.width*2, size.height*2);
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = NO;
                
                option.synchronous = NO;
                
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    [weakSelf feedbackVideoUrl:fileUrl imageData:imageData image:nil phAsset:asset block:block];
                }];
            }];
        }];
        
        [weakVC presentViewController:imagePickerVC animated:YES completion:nil];
        
    }];
    
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍摄");
        if (!weakSelf.imageProvider) {
            ImageProvider * imageProvider = [[ImageProvider alloc] init];
            //imageProvider.isAutoImageFrame = YES;
            [imageProvider setImageDelegate:nil superVC:weakVC];
            [imageProvider setHasTakeVideo:^(NSString *videoPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"拍摄 videoPath: %@", videoPath);
                    UIImage * image = [NSObject thumbnailImageForVideo:[NSURL fileURLWithPath:videoPath] atTime:0.1];
                    [weakSelf feedbackVideoUrl:videoPath imageData:nil image:image phAsset:nil block:block];
                });                
            }];
            weakSelf.imageProvider = imageProvider;
        }
        
        [weakSelf.imageProvider takeVideoFromCamera];
    }];
    
    [oneAC addAction:cancleAction];
    [oneAC addAction:cameraAction];
    [oneAC addAction:albumAction];
    
    for (UIAlertAction * oneAction in actions) {
        [oneAC addAction:oneAction];
    }
    
    [vc presentViewController:oneAC animated:YES completion:nil];
}

- (void)feedbackVideoUrl:(NSString *)url imageData:(NSData *)imageData image:(UIImage *)image phAsset:(PHAsset *)phAsset block:(PickVideoFinishBlock)block{
    if(block){
        if ([url hasPrefix:@"file://"]) {
            url = [url substringFromIndex:7];
        }
        if (!url) {
            AlertToastTitle(@"获取视频信息出错");
            block(nil, nil, nil, nil, 0, 0);
            return;
        }
        CGFloat time;
        CGFloat videoSize;
        {
            videoSize = [[NSFileManager defaultManager] attributesOfItemAtPath:url error:nil].fileSize;
            // 视频长度
            NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:opts];
            double second = urlAsset.duration.value / urlAsset.duration.timescale;
            time = (int)second;
        }
        videoSize = videoSize/1024.0f/1024.0f;
        block(url, imageData, image, phAsset, time, videoSize);
    }
}

+ (void)iosVideoUrlWithPHAsset:(PHAsset *)phAsset block:(void(^)(NSString *fileUrl, NSString *fileTitle))block
{
    [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        // Use the AVAsset avAsset
        // AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
        // AVPlayer *videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        AVURLAsset * urlAsset = (AVURLAsset*)avAsset;
        //NSLog(@"url: %@", urlAsset.URL.absoluteString);
        //NSLog(@"fileName: %@", [NSFileManager getFileName:urlAsset.URL.absoluteString]);
        
        if (block) {
            block(urlAsset.URL.absoluteString, urlAsset.URL.absoluteString.lastPathComponent);
        }
    }];
}

+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

#pragma mark - set get
- (void)setPickImageFinishBlock:(PickImageFinishBlock)pickImageFinishBlock {
    objc_setAssociatedObject(self, @"pickImageFinishBlock", pickImageFinishBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PickImageFinishBlock)pickImageFinishBlock {
    return objc_getAssociatedObject(self, @"pickImageFinishBlock");
}

- (void)setImageProvider:(ImageProvider *)imageProvider {
    objc_setAssociatedObject(self, @"imageProvider", imageProvider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ImageProvider *)imageProvider {
    return objc_getAssociatedObject(self, @"imageProvider");
}

@end