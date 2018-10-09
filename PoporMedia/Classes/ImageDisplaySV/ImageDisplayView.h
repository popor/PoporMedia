//
//  ImageDisplayView.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDisplayEntity.h"
#import <PoporUI/ProgressView.h>

@protocol ImageDisplayViewDelegate <NSObject>

- (void)singleTapViewAction;

@end

@interface ImageDisplayView : UIScrollView

@property (nonatomic, weak  ) id<ImageDisplayViewDelegate> missDelegate;
@property (nonatomic, weak  ) UIScrollView       * superSV;
@property (nonatomic, strong) UIImageView        * imageIV;
@property (nonatomic, strong) ProgressView       * progressView;
@property (nonatomic, weak  ) ImageDisplayEntity * myImageDisplayEntity;
@property (nonatomic        ) BOOL               isLongImage;// 假如是大长图,那么及时点击的是当前图片,也不需要做消失动画.
@property (nonatomic        ) CGRect             longImageFrame;
@property (nonatomic        ) BOOL               isSetScaleBefore;

// 设置imageIV初始位置
- (void)setImageIVDefaultShowFrame:(CGRect)showFrame;

/**
 * 保证有了图片之后,调用此接口.
 * self.zoomScale = self.minimumZoomScale;会和动画相冲突.所以需要其他图片顶替.
 * 原因和消失类似.
 */
- (void)setImageIVZoomScaleWithAnimation:(BOOL)isAnimation duration:(float)durationTime;
- (void)resetImageIVZoomScale;

// 移除数据.
- (void)deleteImageData;


@end
