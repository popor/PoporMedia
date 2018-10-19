//
//  PoporAVPlayerVCEventHandler.h
//  linRunShengPi
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.

#import <Foundation/Foundation.h>

// UI事件
@protocol PoporAVPlayerVCEventHandler <NSObject>
//- (void)didTouchLoginButton;

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)setupVideoPlaybackForURL:(NSURL*)url;
- (void)playButtonTouched:(id)sender;

- (void)beginScrub:(UISlider *)sender;
- (void)scrubbing:(UISlider *)sender;
- (void)endScrub:(UISlider *)sender;
- (void)backButtonClick;
- (void)rotateAction:(UIButton *)sender;
- (void)lockRotateAction:(UIButton *)sender;

@end
