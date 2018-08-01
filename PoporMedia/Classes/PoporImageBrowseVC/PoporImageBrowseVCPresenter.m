//
//  PoporImageBrowseVCPresenter.m
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import "PoporImageBrowseVCPresenter.h"
#import "PoporImageBrowseVCInteractor.h"
#import "PoporImageBrowseVCProtocol.h"

@interface PoporImageBrowseVCPresenter ()

@property (nonatomic, weak  ) id<PoporImageBrowseVCProtocol> view;
@property (nonatomic, strong) PoporImageBrowseVCInteractor * interactor;

@end

@implementation PoporImageBrowseVCPresenter

- (id)init {
    if (self = [super init]) {
        [self initInteractors];
        
    }
    return self;
}

- (void)setMyView:(id<PoporImageBrowseVCProtocol>)view {
    self.view = view;
}

- (void)initInteractors {
    if (!self.interactor) {
        self.interactor = [PoporImageBrowseVCInteractor new];
    }
}

#pragma mark - VC_DataSource

#pragma mark - VC_EventHandler
/**
 *  取消大图显示
 */
- (void)singleTapViewEvent {
    if (self.view.isPush) {
        [self showNCBar:!self.view.isShowNCBar];
        return;
    }
    {
        // 准备关闭
        self.view.currentImageSV.progressView.hidden = YES;
        if (self.view.willCloseBlock) {
            self.view.willCloseBlock((self.view.currentImageSV == self.view.startImageSV), self.view.currentIndex);
            self.view.willCloseBlock = nil;
        }
    }
    
    ImageDisplayEntity * oneEntity = self.view.imageEntityArray[self.view.currentIndex];
    // !!!: 假定所有的场景都是UICollectView的情况,那么UICollectView.bound之外的cc.frame(oneEntity.thumbnailImageBounds)都等于CGRectZero;
    if (self.view.currentImageSV == self.view.startImageSV
        || oneEntity.thumbnailImageBounds.size.width>1) {
        ImageDisplayView * oneSV = self.view.currentImageSV;
        
        // 设置layer
        CGRect originFrame = oneEntity.thumbnailImageBounds;
        self.view.closeImageScale = MIN(oneSV.imageIV.width/oneEntity.thumbnailImageBounds.size.width, oneSV.imageIV.height/oneEntity.thumbnailImageBounds.size.height);
        CGRect showFrame = CGRectZero;
        if (oneSV.imageIV.image) {
            float miniScale  = self.view.closeImageScale;
            
            float x = (oneSV.imageIV.width  - originFrame.size.width*miniScale)/2;
            float y = (oneSV.imageIV.height - originFrame.size.height*miniScale)/2;
            showFrame = CGRectInset(oneSV.imageIV.frame, x, y);
            showFrame = [oneSV convertRect:showFrame toView:self.view.imageSV];
        }else{
            if (oneSV.isLongImage) {
                showFrame = [oneSV convertRect:oneSV.longImageFrame toView:self.view.imageSV];
            }else{
                showFrame = [oneSV convertRect:oneSV.imageIV.frame toView:self.view.imageSV];
            }
        }
        
        if (oneSV.isLongImage) {
            self.view.closeImageSVCV = [[UIView alloc] initWithFrame:showFrame];
            
            // 转移 self.view.startImageSV.imageIV
            [oneSV.imageIV removeFromSuperview];
            oneSV.imageIV.frame         = self.view.closeImageSVCV.bounds;
            oneSV.imageIV.contentMode   = UIViewContentModeCenter;
            oneSV.imageIV.clipsToBounds = YES;
        }else{
            self.view.closeImageSVCV = [[UIView alloc] initWithFrame:showFrame];
            
            //NSLog(@"self.view.closeImageSVCV.frame: %@", NSStringFromCGRect(self.view.closeImageSVCV.frame));
            // 转移 self.view.startImageSV.imageIV
            [oneSV.imageIV removeFromSuperview];
            oneSV.imageIV.frame = self.view.closeImageSVCV.bounds;
            
            // 这里和旺信聊天图片的起始缩放方式不一样,因为旺信起始图片尺寸是等比例的,而其他地方是不固定的.
            oneSV.imageIV.contentMode = UIViewContentModeScaleAspectFill;
            
            oneSV.imageIV.clipsToBounds = YES;
            
        }
        [self.view.closeImageSVCV addSubview:oneSV.imageIV];
        
        [self.view.imageSV addSubview:self.view.closeImageSVCV];
    }
    
    [self removeSelfEvent];
}

- (void)removeSelfEvent {
    [self.view.imageSV removeFromSuperview];
    [self.view.window addSubview:self.view.imageSV];
    
    {
        // 转移self.view.vc位置
        NSMutableArray * vcArray = [self.view.baseNC.viewControllers mutableCopy];
        [vcArray exchangeObjectAtIndex:vcArray.count-1 withObjectAtIndex:vcArray.count - 2];
        [self.view.baseNC setViewControllers:vcArray];
        
        // 直接pop的话,会是的self.view = nil,因为是若属性.
        // [self.view.baseNC popViewControllerAnimated:NO];
    }
    self.view.isColseAnimation = YES;
    
    if (!self.view.isPush) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    [UIView animateWithDuration:CloseSelfAnimationTime animations:^{
        [self removeAnimations];
    } completion:^(BOOL finished) {
        [self removeCompletion];
    }];
}

- (void)removeAnimations {
    self.view.imageSV.backgroundColor = [UIColor clearColor];
    
    // !!!: 假定所有的场景都是UICollectView的情况,那么UICollectView.bound之外的cc.frame(oneEntity.thumbnailImageBounds)都等于CGRectZero;
    // !!!: 并且在缩放动画的时候,一般意义上的cc.imageIV的居中方式设置为居中,不然动画不流畅.
    ImageDisplayEntity * oneEntity = self.view.imageEntityArray[self.view.currentIndex];
    if (self.view.currentImageSV == self.view.startImageSV
        || oneEntity.thumbnailImageBounds.size.width>1) {
        ImageDisplayView * oneSV = self.view.currentImageSV;
        // 转移到到NC上.
        [self.view.baseNC.view insertSubview:self.view.imageSV belowSubview:self.view.baseNC.navigationBar];
        
        // 临时替代方案, center.y 需要self.view.offsetCloseY纠正一次.
        CGPoint center = CGPointMake(oneSV.x + oneEntity.thumbnailImageRect.origin.x + oneEntity.thumbnailImageRect.size.width/2 - 1 , oneEntity.thumbnailImageRect.origin.y + oneEntity.thumbnailImageRect.size.height/2 + self.view.offsetCloseY);
        self.view.closeImageSVCV.center    = center;
        
        self.view.closeImageSVCV.transform = CGAffineTransformMakeScale(1/self.view.closeImageScale, 1/self.view.closeImageScale);
        
    }else{
        self.view.currentImageSV.alpha = 0;
        self.view.currentImageSV.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }
}

- (void)removeCompletion {
    if (self.view.didCloseBlock) {
        self.view.didCloseBlock(NO, self.view.imageEntityArray);
        self.view.didCloseBlock = nil;
    }
    
    for (ImageDisplayView * oneSV in self.view.imageSVArray) {
        oneSV.imageIV.image = nil;
    }
    
    [self.view.imageSV removeFromSuperview];
    self.view.imageSV = nil;
    
    // 真正的移除self.view.vc
    NSMutableArray * vcArray = [self.view.baseNC.viewControllers mutableCopy];
    [vcArray removeObjectAtIndex:vcArray.count - 2];
    [self.view.baseNC setViewControllers:vcArray];
    
}

//------
- (void)showNCBar:(BOOL)isShow {
    self.view.isShowNCBar = isShow;
    
    [self.view.vc.navigationController setNavigationBarHidden:!isShow animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:!isShow withAnimation:UIStatusBarAnimationNone];
}
#pragma mark - Interactor_EventHandler

@end
