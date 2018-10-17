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

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface BurstShotImagePreviewVC (){
//    UICollectionView *_collectionView;
//    UICollectionViewFlowLayout *_layout;
//    NSArray *_photosTemp;
//    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    int _selectNum;
//    CGFloat _offsetItemCount;
}

@property (nonatomic, getter=isShowTopBottomBar) BOOL showTopBottomBar;

@end

@implementation BurstShotImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSingleTapBlock];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    _selectNum = 0;
    for (PoporMediaImageEntity * entity in self.weakImageArray) {
        if (!entity.isIgnore) {
            _selectNum ++;
        }
    }
    _numberLabel.hidden     = _selectNum <= 0;
    _numberImageView.hidden = _selectNum <= 0;
    _numberLabel.text       = [NSString stringWithFormat:@"%i", _selectNum];

    {
        self.showTopBottomBar = NO;
        _naviBar.y      = -_naviBar.height;
        _toolBar.bottom = self.view.height;
        [self customeSingleTapEventDuration:0.1];
    }
    [self customeSvScrollBlockAction:self.index];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat naviBarHeight = KIsiPhoneX ? 88:64;
    
    _naviBar.frame      = CGRectMake(0, 0, self.view.width, naviBarHeight);
    _backButton.frame   = CGRectMake(10, naviBarHeight - 44, 44, 44);
    _selectButton.frame = CGRectMake(self.view.width - 54, _backButton.y, 42, 42);
    
    CGFloat toolBarHeight = 44;
    CGFloat toolBarTop = self.view.height - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
    //    if (_tzImagePickerVc.allowPickingOriginalPhoto) {
    //        CGFloat fullImageWidth = [_tzImagePickerVc.fullImageBtnTitleStr tz_calculateSizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    //        _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
    //        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
    //    }
    _doneButton.frame = CGRectMake(self.view.width - 44 - 12, 0, 44, 44);
    _numberImageView.frame = CGRectMake(self.view.width - 56 - 28, 7, 30, 30);
    _numberLabel.frame = _numberImageView.frame;
    
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
            _naviBar.y      = 0;
            _toolBar.bottom = self.view.height;
        }else{
            _naviBar.y      = -_naviBar.height;
            _toolBar.y      = self.view.height;
        }
    } completion:nil];
}

- (void)customeSvScrollBlockAction:(NSInteger)index {
    PoporMediaImageEntity * entity = self.weakImageArray[index];
    _selectButton.selected = !entity.isIgnore;
    NSLog(@"isIgnore:%i - %i", index, entity.isIgnore);
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamed:@"TZImagePickerController.bundle/navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:[UIImage imageNamed:@"TZImagePickerController.bundle/photo_def_previewVc"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"TZImagePickerController.bundle/photo_sel_photoPickerVc"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(_selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //_selectButton.hidden = !tzImagePickerVc.showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    // 暂且屏蔽了原图部分
    //    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    //    if (_tzImagePickerVc.allowPickingOriginalPhoto) {
    //        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //        _originalPhotoButton.backgroundColor = [UIColor clearColor];
    //        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
    //        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
    //        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_tzImagePickerVc.photoPreviewOriginDefImageName] forState:UIControlStateNormal];
    //        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_tzImagePickerVc.photoOriginSelImageName] forState:UIControlStateSelected];
    //
    //        _originalPhotoLabel = [[UILabel alloc] init];
    //        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
    //        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
    //        _originalPhotoLabel.textColor = [UIColor whiteColor];
    //        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
    //        if (_isSelectOriginalPhoto) [self showPhotoBytes];
    //    }
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TZImagePickerController.bundle/photo_number_icon"]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    //[_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    //[_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
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

- (void)_selectButtonAction:(UIButton *)selectButton {
    PoporMediaImageEntity * entity = self.weakImageArray[self.index];
    selectButton.selected = !selectButton.isSelected;
    entity.ignore = !selectButton.isSelected;
    if (selectButton.isSelected) {
        _selectNum ++;
    }else{
        _selectNum --;
    }
    
    _numberLabel.hidden     = _selectNum <= 0;
    _numberImageView.hidden = _selectNum <= 0;
    _numberLabel.text       = [NSString stringWithFormat:@"%i", _selectNum];
    
    if (!entity.ignore) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:TZOscillatoryAnimationToSmaller];
}


@end
