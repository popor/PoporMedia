//
//  IToastPTool.m
//  PoporUI
//
//  Created by popor on 2018/6/19.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "IToastPTool.h"

@implementation IToastPTool

+ (void)load {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [IToastPTool share];
    });
}

+ (IToastPTool *)share {
    static IToastPTool * oneRK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oneRK = [[self alloc] init];
        [oneRK addMonitor];
    });
    return oneRK;
}

- (void)addMonitor {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 键盘通知事件
- (void)keyboardShow:(NSNotification *)note {
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardH = keyBoardRect.size.height;
    self.keyboardH_record = self.keyboardH;
}

- (void)keyboardHide:(NSNotification *)note {
    self.keyboardH = 0;
}

+ (void)alertTitle:(NSString *)title {
    [self alertTitle:title duration:2 copy:NO bottom:0];
}

+ (void)alertTitle:(NSString *)title duration:(NSInteger)duration {
    [self alertTitle:title duration:duration copy:NO bottom:0];
}

+ (void)alertTitle:(NSString *)title bottom:(CGFloat)bottom {
    [self alertTitle:title duration:-1 copy:NO bottom:bottom];
}

+ (void)alertTitle:(NSString *)title duration:(NSInteger)duration bottom:(CGFloat)bottom {
    [self alertTitle:title duration:duration copy:NO bottom:bottom];
}

+ (void)alertTitle:(NSString *)title duration:(NSInteger)duration copy:(BOOL)copy {
    [self alertTitle:title duration:duration copy:copy bottom:-1];
}

+ (void)alertTitle:(NSString *)title duration:(NSInteger)duration copy:(BOOL)copy bottom:(CGFloat)bottom {
    if ([title isEqualToString:@""] || !title) {
        NSLog(@"提示语为空");
        return;
    }
    if (duration == 0 || duration == -1) {
        duration = 2.5;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        IToastPTool * tool = [IToastPTool share];
        tool.bottom = bottom;
        IToast_Popor * oneIT=[[IToast_Popor alloc] initWithText:title];
        [oneIT setDuration:duration * 1000];
        [oneIT show:iToastTypePoporNotice];
        
        tool.bottom = 0;
        if (copy) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:title];
        }
    });
}

@end
