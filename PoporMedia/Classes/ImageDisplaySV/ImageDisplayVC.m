//
//  ImageDisplayVC.m
//  WanziTG
//
//  Created by 王凯庆 on 2017/1/4.
//  Copyright © 2017年 wanzi. All rights reserved.
//

#import "ImageDisplayVC.h"
#import "ImageDisplayView.h"
#import "UIImageView+sdWebImage.h"

#import <PoporSDWebImage/UIImageView+PoporSDWebImage.h>
#import <PoporFoundation/PrefixSize.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporUI/UIView+Extension.h>

#define OpenDurationTime       0.15
#define CloseSelfAnimationTime 0.15

#define PushVCDelayTime        0.20

#define EditTVMaxH			   150
#define EditTextMaxLength	   100

@interface ImageDisplayVC ()<ImageDisplayViewDelegate, UIScrollViewDelegate, UITextViewDelegate>

@end

@implementation ImageDisplayVC

- (id)init {
    if (self = [super init]) {
        self.window        = [[UIApplication sharedApplication] keyWindow];
        self.delayPushSelf = YES;
    }
    return self;
}

- (void)showInNC:(UINavigationController *)nc
            push:(BOOL)isPush
         fromFrame:(CGRect)StartImageFrame
// 启动的frame下移20个像素,假如为-1的话,非铺满屏幕的界面会在隐藏状态栏的时候发生位移
     offsetOpenY:(CGFloat)offsetOpenY
    offsetCloseY:(CGFloat)offsetCloseY
          entity:(ImageDisplayEntity *)startEntity
           entityArray:(NSMutableArray *)imageEntityArray
       openBlock:(ImageDisplayVCOpenBlock)openBlock
  willCloseBlock:(ImageDisplayVCWillCloseBlock)willCloseBlock
   didCloseBlock:(ImageDisplayVCDidCloseBlock)didCloseBlock
{
    self.baseNC             = nc;
    self.isPush             = isPush;
    self.offsetOpenY        = offsetOpenY;
    self.offsetCloseY       = offsetCloseY;
    
    self.imageEntityArray   = imageEntityArray;//wxImageEntityArray;//@[startEntity];
    self.willCloseBlock     = willCloseBlock;
    self.didCloseBlock      = didCloseBlock;
    self.currentImageEntity = startEntity;
    
    if (self.isPush) {
        //        if (!self.backImage) {
        //            self.backImage = nil;
        //        }
    }else{
        if (self.customeHideStatusBlock) {
            self.customeHideStatusBlock();
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(OpenDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            });
        }
    }
    if (!self.imageSVArray) {
        self.imageSVArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.imageSV) {
        self.imageSV = [[UIScrollView alloc] init];
        self.imageSV.frame = ScreenBounds;
        //创建灰色透明背景，使其背后内容不可操作
        self.imageSV.showsHorizontalScrollIndicator = NO;
        self.imageSV.showsVerticalScrollIndicator   = NO;
        self.imageSV.backgroundColor                = [UIColor clearColor];
        self.imageSV.pagingEnabled                  = YES;
        self.imageSV.delegate                       = self;
        
        if (!self.isPush) {
            [self.window addSubview:self.imageSV];
        }
    }
    
    int starIndex                  = (int)[self.imageEntityArray indexOfObject:startEntity];
    self.currentIndex              = starIndex;
    self.imageSV.contentSize       = CGSizeMake(ScreenSize.width * self.imageEntityArray.count, ScreenSize.height);
    self.imageSV.contentOffset     = CGPointMake(ScreenSize.width * starIndex, 0);
    for (int i = 0; i<self.imageEntityArray.count; i++) {
        CGRect oneSVFrame          = CGRectMake(ScreenSize.width*i + 1, 0, ScreenSize.width - 2, ScreenSize.height);
        ImageDisplayView * oneSV   = [[ImageDisplayView alloc] initWithFrame:oneSVFrame];
        oneSV.superSV              = self.imageSV;
        oneSV.missDelegate         = self;
        oneSV.myImageDisplayEntity = self.imageEntityArray[i];
        if (i == starIndex) {
            // MARK:往下移20, 是因为隐藏状态栏的时候,superVC的高度会上移self.offsetOpenY个像素,在非铺满屏幕的情况下.
            [oneSV setImageIVDefaultShowFrame:CGRectOffset(StartImageFrame, 0, self.offsetOpenY)];
            
            self.startImageSV      = oneSV;
            self.currentImageSV    = oneSV;
        }else{
            [oneSV setImageIVDefaultShowFrame:oneSV.myImageDisplayEntity.thumbnailImageRect];
        }
        
        [self.imageSVArray addObject:oneSV];
        [self.imageSV addSubview:oneSV];
        
        if (i == starIndex) {
            ImageDisplayEntity * oneEntity = oneSV.myImageDisplayEntity;
            BOOL cachedOriginal = oneEntity.cachedOriginal || oneEntity.originImage;// 是否之前缓存了原图片
            
            oneSV.progressView.hidden = NO;
            [oneSV.progressView setCurrentProgress:0.01];
            
            if (self.isPush) {
                // do Nothing
            }else{
                // 假如有动画伴随的话,需要先将图片隐藏.
                oneSV.imageIV.hidden = YES;
            }
            ABCSDWebImageCompletionBlock completeBlock =^(UIImage *image, BOOL isDownloadOK) {
                oneSV.imageIV.image = image;
                if (cachedOriginal) {
                    // 缓存后,显示动画
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //NSLog(@"放大动画");
                        // 默认为YES
                        [oneSV setImageIVZoomScaleWithAnimation:!self.isPush duration:OpenDurationTime];
                    });
                }else{
                    // 第一次下载的话,不显示动画
                    oneSV.imageIV.hidden = NO;
                    [oneSV setImageIVZoomScaleWithAnimation:NO duration:OpenDurationTime];
                }
                if (!isDownloadOK) {
                    oneSV.progressView.hidden = NO;
                    AlertToastTitle(@"图片下载失败");
                }else{
                    oneSV.progressView.hidden = YES;
                }
            };
            if (!oneEntity.originImage) {
                [[[UIImageView alloc] init] abcsd_ImageUrl:oneEntity.originImageUrl placeholderImage:nil progress:^(CGFloat progress) {
                    oneSV.progressView.hidden = NO;
                    [oneSV.progressView setCurrentProgress:progress];
                } completed:completeBlock];
            }else{
                completeBlock(oneEntity.originImage, YES);
            }
        }
    }
    
    // 准备其他页面数据.
    [self prepareOtherSVImageAt:self.currentIndex];
    
    if (self.isPush) {
        self.title = [NSString stringWithFormat:@"%i/%i", self.currentIndex+1, (int)self.imageEntityArray.count];
        self.imageSV.backgroundColor = [UIColor blackColor];
        
        [self.baseNC pushViewController:self animated:YES];
    }else{
        if (!self.isDelayPushSelf) {
            NSLog(@"-- %@", self.baseNC);
            [self.baseNC pushViewController:self animated:NO];
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        }
        
        [UIView animateWithDuration:PushVCDelayTime animations:^{
            self.imageSV.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            if (openBlock) {
                openBlock();
            }
            if (self.isDelayPushSelf) {
                NSLog(@"-- %@", self.baseNC);
                [self.baseNC pushViewController:self animated:NO];
                [self.navigationController setNavigationBarHidden:YES animated:NO];
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.imageSV != scrollView) {
        return;
    }
    int pageNum = (int)scrollView.contentOffset.x/ScreenSize.width;
    float offsetRecordX = scrollView.contentOffset.x;
    if (offsetRecordX != (ScreenSize.width*pageNum)) {
        return;
    }else{
        if (self.currentIndex != pageNum) {
            self.currentIndex = pageNum;
            [self resetSVImageAt:pageNum];
        }
    }
    if (self.svScrollBlock) {
        self.svScrollBlock(pageNum);
    }
}

- (void)resetSVImageAt:(int)index {
    self.currentIndex = index;
    if (index < self.imageEntityArray.count && index>=0) {
        self.currentImageSV = self.imageSVArray[index];
        self.currentImageEntity = self.imageEntityArray[index];
    }
    if (self.currentImageSV.imageIV.image == nil) {
        [self loadSVImageAt:index animation:NO];
    }else{
        [self.currentImageSV resetImageIVZoomScale];
    }
    
    [self deleteOtherSVImageAt:index];
    [self prepareOtherSVImageAt:index];
}

- (void)deleteOtherSVImageAt:(int)index {
    NSArray * deleteArray = @[@(index-3),  @(index+3)];
    for (NSNumber * deleteNum in deleteArray) {
        if (deleteNum.intValue>=0 && deleteNum.intValue<self.imageSVArray.count) {
            ImageDisplayView * oneSV = self.imageSVArray[deleteNum.intValue];
            [oneSV deleteImageData];
        }
    }
}

- (void)prepareOtherSVImageAt:(int)index {
    NSArray * prepareArray = @[@(index-2), @(index-1), @(index+1), @(index+2)];
    for (NSNumber * prepareNum in prepareArray) {
        if (prepareNum.intValue>=0 && prepareNum.intValue<self.imageSVArray.count) {
            [self loadSVImageAt:prepareNum.intValue animation:NO];
        }
    }
}

- (void)loadSVImageAt:(int)index animation:(BOOL)animation {
    if (index>=0 && index<self.imageSVArray.count) {
        //NSLog(@"load SV image at : %i", index);
        ImageDisplayView * oneSV = self.imageSVArray[index];
        if (oneSV.imageIV.image) {
            return;
        }
        ImageDisplayEntity * oneEntity = oneSV.myImageDisplayEntity;
        [oneSV setImageIVDefaultShowFrame:oneSV.myImageDisplayEntity.thumbnailImageRect];
        
        oneSV.progressView.hidden = NO;
        [oneSV.progressView setCurrentProgress:0.01];
        
        ABCSDWebImageCompletionBlock completeBlock =^(UIImage *image, BOOL isDownloadOK) {
            if (oneSV.imageIV) {
                oneSV.imageIV.image = image;
                
                [oneSV setImageIVZoomScaleWithAnimation:animation duration:OpenDurationTime];
            }
            if (!isDownloadOK) {
                oneSV.progressView.hidden = NO;
                AlertToastTitle(@"图片下载失败");
            }else{
                oneSV.progressView.hidden = YES;
            }
        };
        if (!oneEntity.originImage) {
            [[[UIImageView alloc] init] abcsd_ImageUrl:oneEntity.originImageUrl placeholderImage:nil progress:^(CGFloat progress) {
                //显示下载的进度条
                oneSV.progressView.hidden = NO;
                [oneSV.progressView setCurrentProgress:progress];
            } completed:completeBlock];
        }else{
            completeBlock(oneEntity.originImage, YES);
        }
    }
}

- (void)singleTapViewAction {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }else{
        [self singleTapViewEvent];
    }
}
/**
 *  取消大图显示
 */
- (void)singleTapViewEvent {
    if (self.isPush) {
        [self showNCBar:!self.isShowNCBar];
        return;
    }
    {
        // 准备关闭
        self.currentImageSV.progressView.hidden = YES;
        if (self.willCloseBlock) {
            self.willCloseBlock((self.currentImageSV == self.startImageSV), self.currentIndex);
            self.willCloseBlock = nil;
        }
    }
    
    ImageDisplayEntity * oneEntity = self.imageEntityArray[self.currentIndex];
    // !!!: 假定所有的场景都是UICollectView的情况,那么UICollectView.bound之外的cc.frame(oneEntity.thumbnailImageBounds)都等于CGRectZero;
    if (self.currentImageSV == self.startImageSV
        || oneEntity.thumbnailImageBounds.size.width>1) {
        ImageDisplayView * oneSV = self.currentImageSV;
        
        // 设置layer
        CGRect originFrame = oneEntity.thumbnailImageBounds;
        self.closeImageScale = MIN(oneSV.imageIV.width/oneEntity.thumbnailImageBounds.size.width, oneSV.imageIV.height/oneEntity.thumbnailImageBounds.size.height);
        CGRect showFrame = CGRectZero;
        if (oneSV.imageIV.image) {
            float miniScale  = self.closeImageScale;
            
            float x = (oneSV.imageIV.width  - originFrame.size.width*miniScale)/2;
            float y = (oneSV.imageIV.height - originFrame.size.height*miniScale)/2;
            showFrame = CGRectInset(oneSV.imageIV.frame, x, y);
            showFrame = [oneSV convertRect:showFrame toView:self.imageSV];
        }else{
            if (oneSV.isLongImage) {
                showFrame = [oneSV convertRect:oneSV.longImageFrame toView:self.imageSV];
            }else{
                showFrame = [oneSV convertRect:oneSV.imageIV.frame toView:self.imageSV];
            }
        }
        
        if (oneSV.isLongImage) {
            self.closeImageSVCV = [[UIView alloc] initWithFrame:showFrame];
            
            // 转移 self.startImageSV.imageIV
            [oneSV.imageIV removeFromSuperview];
            oneSV.imageIV.frame         = self.closeImageSVCV.bounds;
            oneSV.imageIV.contentMode   = UIViewContentModeCenter;
            oneSV.imageIV.clipsToBounds = YES;
        }else{
            self.closeImageSVCV = [[UIView alloc] initWithFrame:showFrame];
            
            //NSLog(@"self.closeImageSVCV.frame: %@", NSStringFromCGRect(self.closeImageSVCV.frame));
            // 转移 self.startImageSV.imageIV
            [oneSV.imageIV removeFromSuperview];
            oneSV.imageIV.frame = self.closeImageSVCV.bounds;
            
            // 这里和旺信聊天图片的起始缩放方式不一样,因为旺信起始图片尺寸是等比例的,而其他地方是不固定的.
            oneSV.imageIV.contentMode = UIViewContentModeScaleAspectFill;
            
            oneSV.imageIV.clipsToBounds = YES;
            
        }
        [self.closeImageSVCV addSubview:oneSV.imageIV];
        
        [self.imageSV addSubview:self.closeImageSVCV];
    }
    
    [self removeSelfEvent];
}

- (void)removeSelfEvent {
    [self.imageSV removeFromSuperview];
    [self.window addSubview:self.imageSV];
    [self.baseNC popViewControllerAnimated:NO];
    self.isColseAnimation = YES;
    
    if (!self.isPush) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [UIView animateWithDuration:CloseSelfAnimationTime animations:^{
        [self removeAnimations];
    } completion:^(BOOL finished) {
        [self removeCompletion];
        
    }];
}

- (void)removeAnimations {
    self.imageSV.backgroundColor = [UIColor clearColor];
    
    // !!!: 假定所有的场景都是UICollectView的情况,那么UICollectView.bound之外的cc.frame(oneEntity.thumbnailImageBounds)都等于CGRectZero;
    // !!!: 并且在缩放动画的时候,一般意义上的cc.imageIV的居中方式设置为居中,不然动画不流畅.
    ImageDisplayEntity * oneEntity = self.imageEntityArray[self.currentIndex];
    if (self.currentImageSV == self.startImageSV
        || oneEntity.thumbnailImageBounds.size.width>1) {
        ImageDisplayView * oneSV = self.currentImageSV;
        // 转移到到NC上.
        [self.baseNC.view insertSubview:self.imageSV belowSubview:self.baseNC.navigationBar];
        
        // 临时替代方案, center.y 需要self.offsetCloseY纠正一次.
        CGPoint center = CGPointMake(oneSV.x + oneEntity.thumbnailImageRect.origin.x + oneEntity.thumbnailImageRect.size.width/2 - 1 , oneEntity.thumbnailImageRect.origin.y + oneEntity.thumbnailImageRect.size.height/2 + self.offsetCloseY);
        self.closeImageSVCV.center    = center;
        
        self.closeImageSVCV.transform = CGAffineTransformMakeScale(1/self.closeImageScale, 1/self.closeImageScale);
        
    }else{
        self.currentImageSV.alpha = 0;
        self.currentImageSV.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }
}

- (void)removeCompletion {
    if (self.didCloseBlock) {
        self.didCloseBlock(NO, self.imageEntityArray);
        self.didCloseBlock = nil;
    }
    
    for (ImageDisplayView * oneSV in self.imageSVArray) {
        oneSV.imageIV.image = nil;
    }
    [self.imageSV removeFromSuperview];
    self.imageSV = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isPush) {
        self.baseNC.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self setImageVCNCBarColor:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPush) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    
    if (self.isColseAnimation) {
        // 缩放关闭
        // do Nothing.
    }else{
        // pop关闭
        self.willCloseBlock = nil;
        if (self.didCloseBlock) {
            self.didCloseBlock(NO, self.imageEntityArray);
            self.didCloseBlock = nil;
        }
    }
    [self setImageVCNCBarColor:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
    self.baseNC.interactivePopGestureRecognizer.enabled = YES;
    if (self.isColseAnimation) {
        // 缩放关闭
        // do Nothing.
    }else{
        // pop关闭
        [self.imageSV removeFromSuperview];
        self.imageSV = nil;
    }
}

#pragma mark - 修改BaseNC title 颜色.
- (void)setImageVCNCBarColor:(BOOL)isDefault {
    if (isDefault) {
        //        {
        //            // 字体颜色
        //            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        //            [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        //            [dict setObject:WanziNCBarTitleFont forKey:NSFontAttributeName];
        //            self.baseNC.navigationBar.titleTextAttributes = dict;
        //
        //            // 背景色
        //            self.baseNC.navigationBar.barTintColor = [UIColor blackColor];
        //        }
    }else{
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //        {
        //            // 字体颜色
        //            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        //            [dict setObject:WanziNCBarTitleColor forKey:NSForegroundColorAttributeName];
        //            [dict setObject:WanziNCBarTitleFont forKey:NSFontAttributeName];
        //            self.baseNC.navigationBar.titleTextAttributes = dict;
        //
        //            // 背景色
        //            self.baseNC.navigationBar.barTintColor = [UIColor whiteColor];
        //        }
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.imageSV removeFromSuperview];
    [self.view addSubview:self.imageSV];
    
    //    if (self.isPush) {
    //        [self loadLeftItemWithImage:self.backImage target:nil action:@selector(backTouched)];
    //    }else{
    //        [self loadLeftItemWithTitle:nil target:nil action:nil];
    //    }
    
    if (self.isPush) {
        self.isShowNCBar = YES;
    }
}


- (void)showNCBar:(BOOL)isShow {
    self.isShowNCBar = isShow;
    
    [self.navigationController setNavigationBarHidden:!isShow animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:!isShow withAnimation:UIStatusBarAnimationNone];
}

- (void)backTouched {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
