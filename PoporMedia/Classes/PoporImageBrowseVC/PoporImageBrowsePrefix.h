//
//  PoporImageBrowsePrefix.h
//  Pods
//
//  Created by apple on 2018/7/12.
//

#ifndef PoporImageBrowsePrefix_h
#define PoporImageBrowsePrefix_h

#define WanziNCBarTitleColor  RGBA(60, 60, 60, 1)           // NCbartitle 颜色
#define WanziNCBarTitleFont   [UIFont systemFontOfSize:18]    //NCbartitle fontfont

#define OpenDurationTime       0.15
#define CloseSelfAnimationTime 0.15

#define PushVCDelayTime        0.20

#define EditTVMaxH             150
#define EditTextMaxLength      100

typedef void(^ImageDisplayVCOpenBlock) (void);
typedef void(^ImageDisplayVCWillCloseBlock) (BOOL isAtFirstChatView,int currentIndex);
typedef void(^ImageDisplayVCDidCloseBlock) (BOOL isEditText,NSMutableArray * imageEntityArray);
typedef void(^ImageDisplayVCSingleTapBlock) (void); // 自定义点击事件
typedef void(^BlockPInt) (int number);
typedef void(^BlockPVoid) (void);

// ---
typedef void(^PoporSDWebImageProgressBlock) (CGFloat progress);
typedef void(^PoporSDWebImageCompletionBlock)(UIImage * image, BOOL isDownloadOK);


#endif /* PoporImageBrowsePrefix_h */
