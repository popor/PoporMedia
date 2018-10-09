//
//  ImageDisplayVC.h
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDisplayEntity.h"
@class ImageDisplayView;

//TabBar
#define PoporMediaNCBarTitleColor  RGBA(60, 60, 60, 1)           // NCbartitle 颜色
#define PoporMediaNCBarTitleFont   [UIFont systemFontOfSize:18]	//NCbartitle fontfont

typedef void(^ImageDisplayVCOpenBlock) (void);
typedef void(^ImageDisplayVCWillCloseBlock) (BOOL isAtFirstChatView,int currentIndex);
typedef void(^ImageDisplayVCDidCloseBlock) (BOOL isEditText,NSMutableArray * imageEntityArray);
typedef void(^ImageDisplayVCSingleTapBlock) (void); // 自定义点击事件
typedef void(^BlockPInt) (int number);
typedef void(^BlockPVoid) (void);

@interface ImageDisplayVC : UIViewController

@property (nonatomic, weak  ) UINavigationController * baseNC;

@property (nonatomic, copy  ) ImageDisplayVCWillCloseBlock willCloseBlock;
@property (nonatomic, copy  ) ImageDisplayVCDidCloseBlock  didCloseBlock;
@property (nonatomic, copy  ) ImageDisplayVCSingleTapBlock singleTapBlock;
@property (nonatomic, copy  ) BlockPInt               svScrollBlock;
@property (nonatomic, copy  ) BlockPVoid              customeHideStatusBlock;

@property (nonatomic, strong) UIScrollView       * imageSV;
@property (nonatomic        ) int                currentIndex;
@property (nonatomic, getter=isDelayPushSelf) BOOL delayPushSelf; //默认是YES,针对于非push动画. 假如baseNC显示nc那么为YES,否则为NO.

//------------------------------------------------------------------------------
@property (nonatomic        ) BOOL               isPush;
@property (nonatomic, weak  ) UIWindow           * window;
//@property (nonatomic, strong) UIScrollView       * imageSV;
@property (nonatomic        ) CGFloat            offsetOpenY;
@property (nonatomic        ) CGFloat            offsetCloseY;

@property (nonatomic, weak  ) ImageDisplayView   * currentImageSV;
//@property (nonatomic        ) int                currentIndex;
@property (nonatomic, weak  ) NSMutableArray     * imageEntityArray;
@property (nonatomic, strong) NSMutableArray     * imageSVArray;

// 主要是负责显示第一个图片和关闭第一个图片.
@property (nonatomic, weak  ) ImageDisplayView   * startImageSV;
@property (nonatomic        ) float              closeImageScale;
@property (nonatomic, strong) UIView             * closeImageSVCV;
@property (nonatomic        ) BOOL               isColseAnimation;

@property (nonatomic        ) BOOL               isShowNCBar;
@property (nonatomic, weak  ) ImageDisplayEntity * currentImageEntity;

//@property (nonatomic, strong) UIImage            * backImage;
//------------------------------------------------------------------------------

- (id)init;

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
   didCloseBlock:(ImageDisplayVCDidCloseBlock)didCloseBlock;

- (void)singleTapViewEvent;

- (void)resetSVImageAt:(int)index;

@end
