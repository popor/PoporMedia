//
//  ImageDisplayView.m
//  Wanzi
//
//  Created by 王凯庆 on 2017/1/3.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import "ImageDisplayView.h"
#import "UIDevice+Tool.h"
#import "UIDevice+Permission.h"
#import "UIDevice+SaveImage.h"
#import <PoporFoundation/SizePrefix.h>
#import <PoporUI/UIView+Extension.h>
#import <PoporUI/BlockActionSheet.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporSDWebImage/UIImageView+PoporSDWebImage.h>

#define SingleTapEventTime 0.2

@interface ImageDisplayView ()<UIScrollViewDelegate>

@property (nonatomic) BOOL    showActionSheet;// 防止重发弹出

@property (nonatomic) BOOL    isLongTap;
@property (nonatomic) BOOL    isSingleTap;
@property (nonatomic) BOOL    isDoubleTap;

@property (nonatomic) CGPoint touchedPoint;
@property (nonatomic) BOOL    isSelfSVScrolling;
@property (nonatomic) BOOL    isSetImageDataBefore; // 防止2次预加载时候,重复绘制ImageSV

@property (nonatomic        ) float longImageMaxScale;
@property (nonatomic        ) float longImageMinScale;

@end

@implementation ImageDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.delegate = self;
        
        self.longImageMaxScale = ScreenSize.height/ScreenSize.width;
        self.longImageMinScale = ScreenSize.width/ScreenSize.height;
    }
    return self;
}

- (void)setImageIVDefaultShowFrame:(CGRect)showFrame
{
    self.longImageFrame = showFrame;// 临时代替
    if (!self.imageIV) {
        self.imageIV = [[UIImageView alloc] initWithFrame:showFrame];
        self.imageIV.userInteractionEnabled = YES;
        self.imageIV.backgroundColor        = [UIColor blackColor];
        
        [self addSubview:self.imageIV];
    }
    if (!self.progressView) {
        self.progressView = [[ProgressView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.progressView.center = CGPointMake(self.width/2, self.height/2);
        self.progressView.hidden = YES;
        [self addSubview:self.progressView];
    }
}

- (void)setImageIVZoomScaleWithAnimation:(BOOL)isAnimation duration:(float)durationTime
{
    if (!self.imageIV.image) {
        return;
    }
    if (self.isSetImageDataBefore) {
        return;
    }
    
    CGRect originFrame;
    if (isAnimation) {
        originFrame = self.imageIV.frame;
    }
    float showW         = 0;
    float showH         = 0;
    //float maxImageScale = 0;
    //    NSLog(@"方向: %i", (int)self.imageIV.image.imageOrientation);
    if (self.imageIV.image.imageOrientation == UIImageOrientationUp ||
        self.imageIV.image.imageOrientation == UIImageOrientationDown) {
        showW = (int)CGImageGetWidth (self.imageIV.image.CGImage);
        showH = (int)CGImageGetHeight(self.imageIV.image.CGImage);
    }else if(self.imageIV.image.imageOrientation == UIImageOrientationLeft ||
             self.imageIV.image.imageOrientation == UIImageOrientationRight){
        showW = (int)CGImageGetHeight(self.imageIV.image.CGImage);
        showH = (int)CGImageGetWidth (self.imageIV.image.CGImage);
    }
    float imageWScale = showW/self.frame.size.width;
    float imageHScale = showH/self.frame.size.height;
    //    NSLog(@"\r\n");
    //    NSLog(@"CellW: %f, CellH:%f", self.longImageFrame.size.width, self.longImageFrame.size.height);
    //    NSLog(@"imageW: %f, imageH:%f", showW, showH);
    //    NSLog(@"imageWScale: %f, imageHScale:%f", imageWScale, imageHScale);
    //    NSLog(@"%f - %f", self.longImageFrame.size.width/showW, self.longImageFrame.size.height/showH);
    //maxImageScale = MAX(imageWScale, imageHScale);
    self.imageIV.frame= CGRectMake(0, 0, showW, showH);
    
    float whScale = showW/showH;
    if (whScale > self.longImageMaxScale || whScale < self.longImageMinScale) {
        //if (fabs(self.longImageFrame.size.width/showW - self.longImageFrame.size.height/showH) > 0.01) {
        self.isLongImage = YES;
        // 长图
        float miniSizeScale = MIN(imageWScale, imageHScale);
        if (miniSizeScale > 1) {
            self.minimumZoomScale = MIN(imageWScale, imageHScale);
            self.minimumZoomScale = 1/self.minimumZoomScale;
            self.maximumZoomScale = 0.98;
            self.imageIV.center = CGPointMake(showW/2, showH/2);
            if (showW<showH) {
                self.imageIV.y = 0;
                self.imageIV.contentMode = UIViewContentModeTop;
            }else{
                self.imageIV.contentMode = UIViewContentModeTopLeft;
                self.imageIV.x = 0;
            }
            //NSLog(@"大");
        }else{
            self.imageIV.contentMode = UIViewContentModeTopLeft;
            self.minimumZoomScale = 1/MAX(imageWScale, imageHScale);
            self.maximumZoomScale = 1/MIN(imageWScale, imageHScale);
            
            self.imageIV.center   = CGPointMake(showW/2, showH/2);
            //NSLog(@"小");
        }
        self.zoomScale        = self.minimumZoomScale;
        
        //NSLog(@"长图 frame: %@", NSStringFromCGRect(self.imageIV.frame));
        // 计算长条图片关闭时候,用到的longImageFrame.
        if (!self.isSetScaleBefore) {
            if (showW<showH) {
                self.longImageFrame   = CGRectMake(0, 0, self.imageIV.width, self.longImageFrame.size.height * (self.imageIV.width/self.longImageFrame.size.width));
            }else{
                self.longImageFrame   = CGRectMake(0, 0, self.longImageFrame.size.width * (self.imageIV.height/self.longImageFrame.size.height), self.imageIV.height);
            }
            self.longImageFrame = CGRectMake((self.width - self.longImageFrame.size.width)/2 + 1// 自己都减少了2
                                             , (self.height - self.longImageFrame.size.height)/2
                                             , self.longImageFrame.size.width
                                             , self.longImageFrame.size.height);
        }
    }else{
        // 方图
        self.minimumZoomScale = MAX(imageWScale, imageHScale);
        if (self.minimumZoomScale > 1) {
            // 大图
            self.minimumZoomScale = 1/self.minimumZoomScale;
            self.minimumZoomScale = MIN(self.minimumZoomScale, self.maximumZoomScale);
            self.maximumZoomScale = 0.98;
            //NSLog(@"大");
        }else{
            // 小图
            self.minimumZoomScale = 1/MAX(imageWScale, imageHScale);
            self.maximumZoomScale = 1/MIN(imageWScale, imageHScale);
            //NSLog(@"小");
        }
        self.zoomScale           = self.minimumZoomScale;
        self.imageIV.contentMode = UIViewContentModeScaleAspectFit;
        //NSLog(@"方图 frame: %@", NSStringFromCGRect(self.imageIV.frame));
        
        {
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // 下面需要走一遍,不然会出错,主要针对相机拍摄的图片.
            showW = self.imageIV.width;
            showH = self.imageIV.height;
            self.imageIV.frame = CGRectMake((self.width - showW)/2, (self.height - showH)/2, showW, showH);
            //NSLog(@"方图 frame: %@", NSStringFromCGRect(self.imageIV.frame));
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
    //NSLog(@"- mini:%f, max:%f", self.minimumZoomScale, self.maximumZoomScale);
    //NSLog(@"frame: %@", NSStringFromCGRect(self.imageIV.frame));
    
    if (isAnimation) {
        if (self.imageIV.image) {
            __block UIImageView *  animationIV;
            float miniScale  = MIN(self.imageIV.width/originFrame.size.width, self.imageIV.height/originFrame.size.height);
            float x = (self.imageIV.width /miniScale - originFrame.size.width)/2;
            float y = (self.imageIV.height/miniScale - originFrame.size.height)/2;
            CGRect showFrame = CGRectInset(originFrame, -x, -y);
            animationIV = [[UIImageView alloc] initWithFrame:showFrame];
            // 这里和旺信聊天图片的起始缩放方式不一样,因为旺信起始图片尺寸是等比例的,而其他地方是不固定的.
            animationIV.contentMode = UIViewContentModeScaleAspectFill;
            animationIV.image = self.imageIV.image;
            [self addSubview:animationIV];
            
            [UIView animateWithDuration:durationTime animations:^{
                animationIV.frame = self.imageIV.frame;
            } completion:^(BOOL finished) {
                self.imageIV.hidden = NO;
                [animationIV removeFromSuperview];
                animationIV.image   = nil;
                animationIV         = nil;
            }];
        }else{
            self.imageIV.hidden = NO;
        }
    }
    self.isSetScaleBefore     = YES;
    self.isSetImageDataBefore = YES;
    [self resetImageIVZoomScale];
}

- (void)resetImageIVZoomScale
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isSetImageDataBefore) {
            self.zoomScale   = self.minimumZoomScale;
            self.contentSize = CGSizeMake(self.contentSize.width - 2, self.contentSize.height);
            //NSLog(@"重新设置 mini:%f, max:%f", self.minimumZoomScale, self.maximumZoomScale);
        }
    });
}

// 移除数据.
- (void)deleteImageData
{
    self.isSetImageDataBefore = NO;
    // 注意先后顺序.
    self.zoomScale        = 1;
    self.contentOffset    = CGPointMake(0, 0);
    
    self.imageIV.image    = nil;
    [self.imageIV removeFromSuperview];
    self.imageIV = nil;
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageIV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageIV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                      scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isSelfSVScrolling = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"0 停止滑动");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isSelfSVScrolling = NO;
        //NSLog(@"1 停止滑动");
    });
}

#pragma mark - Zoom methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    {
        // 检测长按开始.
        self.isLongTap = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SingleTapEventTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isLongTap) {
                self.isSingleTap = NO;
                self.isDoubleTap = NO;
                [self longTapEvent];
            }
        });
    }
    self.touchedPoint = [[touches anyObject] locationInView:self.imageIV];//触摸点
    UITouch *touch    = [[event allTouches] anyObject];
    if ([touch tapCount] == 1) {
        self.isSingleTap = YES;
        self.isDoubleTap = NO;
        if (!self.isSelfSVScrolling) {
            [self singelClicked];
        }
    }
    
    if ([touch tapCount] == 2) {
        self.isSingleTap = NO;
        self.isDoubleTap = YES;
        [self doubelClicked];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self interruptLongTapEvent];
    [self performSelector:@selector(runSingleClickedAction) withObject:nil afterDelay:SingleTapEventTime];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self interruptLongTapEvent];
}

- (void)interruptTapEvent
{
    self.isSingleTap = NO;
    self.isDoubleTap = NO;
    self.isLongTap   = NO;
}

- (void)singelClicked
{
    if (self.isSelfSVScrolling) {
        // 假如在滑动中,那么忽略单击事件
        NSLog(@"\r\n\r\n假如在滑动中,那么忽略单击事件!!!!!!!!!!!!!!");
        return;
    }
    [self performSelector:@selector(runSingleClickedAction) withObject:nil afterDelay:SingleTapEventTime + 0.05];
}

- (void)runSingleClickedAction
{
    if (self.isSingleTap) {
        [self interruptTapEvent];
        if ([self.missDelegate respondsToSelector:@selector(singleTapViewAction)]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.missDelegate singleTapViewAction];
            });
        }
    }
}

- (void)doubelClicked
{
    if (self.isDoubleTap) {
        [self interruptTapEvent];
        if (self.zoomScale == self.maximumZoomScale) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.zoomScale = self.minimumZoomScale;
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            [self zoomToRect:CGRectMake(self.touchedPoint.x, self.touchedPoint.y, 100, 100)
                    animated:YES];
            self.zoomScale = self.maximumZoomScale;
            [UIView commitAnimations];
        }
    }
}

/**
 *  由于 触摸结束而终止长按事件
 */
- (void)interruptLongTapEvent
{
    self.isLongTap = NO;
}

- (void)longTapEvent
{
    if (self.showActionSheet) {
        return;
    }
    [self interruptTapEvent];
    //NSLog(@"长按__重新设置 mini:%f, max:%f", self.minimumZoomScale, self.maximumZoomScale);
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", @"复制",nil];
    sheet.tag = 100;
    self.showActionSheet = YES;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [sheet showInView:window selectActionSheetblock:^  (NSInteger buttonIndex){
        self.showActionSheet = NO;
        if (buttonIndex!=sheet.cancelButtonIndex) {
            switch (buttonIndex) {
                case 0:{
                    [self saveImageDataToAlbum];
                    break;
                }
                case 1:{
                    [self copyImage];
                    break;
                }
                default:
                    break;
            }
        }
    }];
}

/**
 *  使用Data格式,容量小
 */
- (void)saveImageDataToAlbum
{
    [UIDevice isHaveSysPowerForAlbumBlock:^(BOOL isFirst, BOOL isHavePermission) {
        if (isHavePermission) {
            NSString * filePath = [UIImageView SDImagePath:self.myImageDisplayEntity.originImageUrl];
            if (filePath) {
                [UIDevice saveImage:nil imageUrl:[NSURL fileURLWithPath:filePath] videoUrl:nil collectionName:nil showAlert:YES];
            }
            //            NSData * imageData = [NSData dataWithContentsOfFile:[UIImageView SDImagePath:self.myImageDisplayEntity.originImageUrl]];
            //            if (imageData) {
            //                [UIDevice saveImageDataToPhotos:imageData showAlert:YES];
            //            }
        }
    }];
}

- (void)copyImage
{
    NSData * imageData = [NSData dataWithContentsOfFile:[UIImageView SDImagePath:self.myImageDisplayEntity.originImageUrl]];
    if (imageData) {
        [UIPasteboard generalPasteboard].image = [UIImage imageWithData:imageData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (imageData) {
            AlertToastTitle(@"已复制");
        }else{
            AlertToastTitle(@"复制图片失败");
        }
    });
}

@end
