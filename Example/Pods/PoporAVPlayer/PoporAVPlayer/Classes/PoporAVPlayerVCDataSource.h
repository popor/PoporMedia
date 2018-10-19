//
//  PoporAVPlayerVCDataSource.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>

// 数据来源
@protocol PoporAVPlayerVCDataSource <NSObject>

#pragma mark - 设置播放进度时间为0
- (void)setDefaultProgressTime;

// app 前后台切换
- (void)applicationWillResignActive:(NSNotification *)notification;
- (void)applicationDidBecomeActive:(NSNotification *)notification;

// 移除KVO
- (void)removeKVO;

@end
