//
//  BurstShotImagePreviewVC.m
//  PoporMedia
//
//  Created by popor on 2017/1/4.
//  Copyright © 2017年 PoporMedia. All rights reserved.
//

#import "BurstShotImagePreviewVC.h"
#import <TZImagePickerController/UIView+Layout.h>

#import <PoporUI/UIView+Extension.h>
#import <PoporUI/UIDeviceScreen.h>

@interface BurstShotImagePreviewVC ()

@property (nonatomic, strong) UIView      * naviBar;
@property (nonatomic, strong) UIButton    * backButton;
@property (nonatomic, strong) UIButton    * selectButton;
@property (nonatomic, strong) UIView      * toolBar;
@property (nonatomic, strong) UIButton    * doneButton;

@property (nonatomic, strong) UIImageView * numberImageView;
@property (nonatomic, strong) UILabel     * numberLabel;
@property (nonatomic, strong) UIButton    * originalPhotoButton;
@property (nonatomic, strong) UILabel     * originalPhotoLabel;
@property (nonatomic        ) int         selectNum;


@property (nonatomic, getter=isShowTopBottomBar) BOOL showTopBottomBar;

@end

@implementation BurstShotImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.toolBarColor) {
        CGFloat rgb = 34 / 255.0;
        self.toolBarColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    }
    
    NSLog(@"预览 1");
    [self setupSingleTapBlock];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delaySetCustomeUI];
    });
}

- (void)delaySetCustomeUI {
    NSLog(@"预览 2");
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.selectNum = 0;
    for (PoporMediaImageEntity * entity in self.weakImageArray) {
        if (!entity.isIgnore) {
            self.selectNum ++;
        }
    }
    self.numberLabel.hidden     = self.selectNum <= 0;
    self.numberImageView.hidden = self.selectNum <= 0;
    self.numberLabel.text       = [NSString stringWithFormat:@"%i", self.selectNum];
    
    {
        self.showTopBottomBar = NO;
        self.naviBar.y      = -self.naviBar.height;
        self.toolBar.bottom = self.view.height;
        [self customeSingleTapEventDuration:0.1];
    }
    [self customeSvScrollBlockAction:self.index];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"预览 3");
    
    CGFloat naviBarHeight      = [UIDeviceScreen isIphoneXScreen] ? 88:64;

    self.naviBar.frame         = CGRectMake(0, 0, self.view.width, naviBarHeight);
    self.backButton.frame      = CGRectMake(10, naviBarHeight - 44, 44, 44);
    self.selectButton.frame    = CGRectMake(self.view.width - 54, self.backButton.y, 42, 42);

    // ???:
    CGFloat toolBarHeight      = 44;
    CGFloat toolBarTop         = self.view.height - toolBarHeight;
    self.toolBar.frame         = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);

    self.doneButton.frame      = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    self.numberImageView.frame = CGRectMake(self.view.width - 56 - 28, 7, 30, 30);
    self.numberLabel.frame     = self.numberImageView.frame;
    
    //    [self configCropView];
}

// 自己设置了单击事件
- (void)setupSingleTapBlock {
    __weak typeof(self) weakSelf = self;
    self.singleTapBlock = ^(PoporImageBrower *browerController, NSInteger index) {
        [weakSelf customeSingleTapEventDuration:0.1];
    };
}

- (void)customeSingleTapEventDuration:(float)duration {
    self.showTopBottomBar = !self.isShowTopBottomBar;
    [[UIApplication sharedApplication] setStatusBarHidden:!self.isShowTopBottomBar withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.isShowTopBottomBar) {
            self.naviBar.y      = 0;
            self.toolBar.bottom = self.view.height;
        }else{
            self.naviBar.y      = -self.naviBar.height;
            self.toolBar.y      = self.view.height;
        }
    } completion:nil];
}

- (void)customeSvScrollBlockAction:(NSInteger)index {
    PoporMediaImageEntity * entity = self.weakImageArray[index];
    self.selectButton.selected = !entity.isIgnore;
    NSLog(@"isIgnore:%li - %i", index, entity.isIgnore);
}

- (void)configCustomNaviBar {
    self.naviBar = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.toolBarColor;
        
        [self.view addSubview:view];
        view;
    });
    self.backButton = ({
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setImage:[UIImage imageNamed:@"TZImagePickerController.framework/TZImagePickerController.bundle/navi_back"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.naviBar addSubview:button];
        
        button;
    });
    
    self.selectButton = ({
        UIButton * button  = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setImage:[UIImage imageNamed:@"TZImagePickerController.framework/TZImagePickerController.bundle/photo_def_previewVc"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"TZImagePickerController.framework/TZImagePickerController.bundle/photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.naviBar addSubview:button];
        
        button;
    });
}

- (void)configBottomToolBar {
    self.toolBar = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.toolBarColor;
        
        [self.view addSubview:view];
        view;
    });
    self.doneButton = ({
        UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
        
        [self.toolBar addSubview:button];
        
        button;
    });
    
    self.numberImageView = ({
        UIImageView * iv  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TZImagePickerController.framework/TZImagePickerController.bundle/photo_number_icon"]];
        iv.backgroundColor = [UIColor clearColor];
        
        [self.toolBar addSubview:iv];
        
        iv;
    });
    self.numberLabel = ({
        UILabel * l= [[UILabel alloc] init];
        l.font = [UIFont systemFontOfSize:15];
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = [UIColor clearColor];
        
        [self.toolBar addSubview:l];
        l;
    });
}

- (void)backButtonClick {
    //[self singleTapViewEvent];
    NSLog(@"WKQ 返回事件");
    self.singleTapBlock(self, self.index);
}

- (void)doneButtonClick {
    NSLog(@"WKQ 完成事件");
    if (self.completeBlock) {
        self.completeBlock();
    }else{
        [self backButtonClick];
    }
}

- (void)selectButtonAction:(UIButton *)selectButton {
    PoporMediaImageEntity * entity = (PoporMediaImageEntity * )self.weakImageArray[self.index];
    selectButton.selected = !selectButton.isSelected;
    entity.ignore = !selectButton.isSelected;
    if (selectButton.isSelected) {
        self.selectNum ++;
    }else{
        self.selectNum --;
    }
    
    self.numberLabel.hidden     = self.selectNum <= 0;
    self.numberImageView.hidden = self.selectNum <= 0;
    self.numberLabel.text       = [NSString stringWithFormat:@"%i", self.selectNum];
    
    if (!entity.ignore) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:self.numberImageView.layer type:TZOscillatoryAnimationToSmaller];
}


@end
