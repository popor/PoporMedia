//
//  PoporImageBrowseVCProtocol.h
//  Pods
//
//  Created by apple on 2018/7/12.
//  

#import <Foundation/Foundation.h>

#import "PoporImageBrowsePrefix.h"
#import "ImageDisplayEntity.h"
#import "ImageDisplayView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <PoporFoundation/NSAssistant.h>
#import <PoporSDWebImage/UIImageView+PoporSDWebImage.h>
#import <PoporFoundation/PrefixSize.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporUI/UIView+Extension.h>

// 对外接口
@protocol PoporImageBrowseVCProtocol <NSObject>

- (UIViewController *)vc;
- (void)setMyPresent:(id)present;

// self   : 自己的
@property (nonatomic, strong) UIScrollView       * imageSV;
@property (nonatomic        ) int                currentIndex;
//默认是YES,针对于非push动画. 假如baseNC显示nc那么为YES,否则为NO.
@property (nonatomic, getter=isDelayPushSelf) BOOL delayPushSelf;

//------------------------------------------------------------------------------
@property (nonatomic, getter=isPush) BOOL        push;
@property (nonatomic, weak  ) UIWindow           * window;
@property (nonatomic        ) CGFloat            offsetOpenY;
@property (nonatomic        ) CGFloat            offsetCloseY;

@property (nonatomic, weak  ) ImageDisplayView   * currentImageSV;
@property (nonatomic, strong) NSMutableArray     * imageSVArray;

// 主要是负责显示第一个图片和关闭第一个图片.
@property (nonatomic, weak  ) ImageDisplayView   * startImageSV;
@property (nonatomic        ) float              closeImageScale;
@property (nonatomic, strong) UIView             * closeImageSVCV;
@property (nonatomic        ) BOOL               isColseAnimation;

@property (nonatomic        ) BOOL               isShowNCBar;


// inject : 外部注入的
@property (nonatomic, weak  ) UINavigationController       * baseNC;
@property (nonatomic        ) CGRect                       startImageFrame;
@property (nonatomic, weak  ) ImageDisplayEntity           * currentImageEntity;
@property (nonatomic, weak  ) NSMutableArray               * imageEntityArray;

@property (nonatomic, copy  ) ImageDisplayVCOpenBlock      openBlock;
@property (nonatomic, copy  ) ImageDisplayVCWillCloseBlock willCloseBlock;
@property (nonatomic, copy  ) ImageDisplayVCDidCloseBlock  didCloseBlock;
@property (nonatomic, copy  ) ImageDisplayVCSingleTapBlock singleTapBlock;
@property (nonatomic, copy  ) BlockPInt                    svScrollBlock;
@property (nonatomic, copy  ) BlockPVoid                   customeHideStatusBlock;


@end
