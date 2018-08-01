//
//  PoporImageBrowseVC.m
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import "PoporImageBrowseVC.h"
#import "PoporImageBrowseVCPresenter.h"
#import "PoporImageBrowseVCRouter.h"

#import <PoporFoundation/PrefixFun.h>

@interface PoporImageBrowseVC ()

@property (nonatomic, strong) PoporImageBrowseVCPresenter * present;

@end

@implementation PoporImageBrowseVC

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.window = [[UIApplication sharedApplication] keyWindow];
        
        [NSAssistant setVC:self dic:dic];
        self.push = NO;
    }
    return self;
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
        // self.willCloseBlock = nil;
        if (self.didCloseBlock) {
            self.didCloseBlock(NO, self.imageEntityArray);
            // self.didCloseBlock = nil;
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

- (void)backTouched {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"图片浏览";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.present) {
        [PoporImageBrowseVCRouter setVCPresent:self];
    }
    
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 参考: https://www.jianshu.com/p/c244f5930fdf
    if (self.isViewLoaded && !self.view.window) {
        // self.view = nil;//当再次进入此视图中时能够重新调用viewDidLoad方法
        
    }
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

- (void)setMyPresent:(id)present {
    self.present = present;
}

#pragma mark - views
- (void)addViews {
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

- (void)browse {
    
    [self initImageSvSection];
}

- (void)initImageSvSection {
    
    if (self.customeHideStatusBlock) {
        self.customeHideStatusBlock();
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(OpenDurationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        });
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
    //CGRect rect = self.view.frame;
    //NSLogRect(rect);
    CGFloat screenW = ScreenSize.width;
    CGFloat screenH = ScreenSize.height;
    int starIndex                  = (int)[self.imageEntityArray indexOfObject:self.currentImageEntity];
    self.currentIndex              = starIndex;
    self.imageSV.contentSize       = CGSizeMake(screenW * self.imageEntityArray.count, screenH);
    self.imageSV.contentOffset     = CGPointMake(screenW * starIndex, 0);
    for (int i = 0; i<self.imageEntityArray.count; i++) {
        CGRect oneSVFrame          = CGRectMake(screenW*i + 1, 0, screenW - 2, screenH);
        ImageDisplayView * oneSV   = [[ImageDisplayView alloc] initWithFrame:oneSVFrame];
        oneSV.superSV              = self.imageSV;
        oneSV.missDelegate         = self;
        oneSV.myImageDisplayEntity = self.imageEntityArray[i];
        if (i == starIndex) {
            // MARK:往下移20, 是因为隐藏状态栏的时候,superVC的高度会上移self.offsetOpenY个像素,在非铺满屏幕的情况下.
            [oneSV setImageIVDefaultShowFrame:CGRectOffset(self.startImageFrame, 0, self.offsetOpenY)];
            NSLogRect(self.startImageFrame);
            
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
            PoporSDWebImageCompletionBlock completeBlock =^(UIImage *image, BOOL isDownloadOK) {
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

                [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:oneEntity.originImageUrl] placeholderImage:nil options:(SDWebImageOptions)0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    CGFloat progress = (CGFloat)receivedSize/expectedSize;
                    oneSV.progressView.hidden = NO;
                    [oneSV.progressView setCurrentProgress:progress];
                    
                } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        if (completeBlock) {
                            completeBlock(nil, NO);
                        }
                    }else{
                        if (completeBlock) {
                            completeBlock(image, YES);
                        }
                    }
                }];
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
            //self.imageSV.backgroundColor = [UIColor blackColor];
            self.imageSV.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            if (self.openBlock) {
                self.openBlock();
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
        
        PoporSDWebImageCompletionBlock completeBlock =^(UIImage *image, BOOL isDownloadOK) {
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
            
            [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:oneEntity.originImageUrl] placeholderImage:nil options:(SDWebImageOptions)0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                CGFloat progress = (CGFloat)receivedSize/expectedSize;
                oneSV.progressView.hidden = NO;
                [oneSV.progressView setCurrentProgress:progress];
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    if (completeBlock) {
                        completeBlock(nil, NO);
                    }
                }else{
                    if (completeBlock) {
                        completeBlock(image, YES);
                    }
                }
            }];
            
        }else{
            completeBlock(oneEntity.originImage, YES);
        }
    }
}

- (void)singleTapViewAction {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }else{
        [self.present singleTapViewEvent];
    }
}

#pragma mark - @synthesize

@synthesize baseNC;

@synthesize closeImageScale;

@synthesize closeImageSVCV;

@synthesize currentImageEntity;

@synthesize currentImageSV;

@synthesize currentIndex;

@synthesize customeHideStatusBlock;

@synthesize delayPushSelf;

@synthesize didCloseBlock;

@synthesize imageEntityArray;

@synthesize imageSV;

@synthesize imageSVArray;

@synthesize isColseAnimation;

@synthesize isShowNCBar;

@synthesize offsetCloseY;

@synthesize offsetOpenY;

@synthesize push;

@synthesize singleTapBlock;

@synthesize startImageSV;

@synthesize svScrollBlock;

@synthesize willCloseBlock;

@synthesize window;

@synthesize startImageFrame;

@synthesize openBlock;

@end

