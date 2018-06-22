//
//  BurstShotImagePreviewCC.m
//  linRunShengPi
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import "BurstShotImagePreviewCC.h"
#import <Masonry/Masonry.h>
#import <PoporUI/UIView+Extension.h>

@implementation BurstShotImagePreviewCC

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
        [self layoutSubviewsCustom];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviewsCustom {
    
    //__weak typeof(self) weakSelf = self;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.selectBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(-3);
        make.width.mas_equalTo(self.selectBT.width);
        make.height.mas_equalTo(self.selectBT.height);
    }];
}

- (void)addViews {
    self.iconIV = ({
        UIImageView * iv = [UIImageView new];
        //iv.backgroundColor =  RGB16(0XFE8809);
        [self addSubview:iv];
        iv;
    });
    
    self.selectBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //NSBundle * imageBundle = [self imagePickerBundle];
        UIImage *nImage = [UIImage imageNamed:@"TZImagePickerController.bundle/photo_def_previewVc"];
        UIImage *sImage = [UIImage imageNamed:@"TZImagePickerController.bundle/photo_sel_photoPickerVc"];
        
        [button setImage:nImage forState:UIControlStateNormal];
        [button setImage:sImage forState:UIControlStateSelected];
        
        button.frame = CGRectMake(0, 0, nImage.size.width, nImage.size.height);
        [self addSubview:button];
        
        [button addTarget:self action:@selector(selectBTAction) forControlEvents:UIControlEventTouchUpInside];
        //button.userInteractionEnabled = NO;
        button;
    });
}

- (void)selectBTAction {
    self.selectBT.selected = !self.selectBT.isSelected;
    self.weakEntity.ignore = !self.selectBT.isSelected;;
}

- (void)setImageEntity:(ImageDisplayEntity *)entity {
    self.weakEntity        = entity;
    self.iconIV.image      = entity.iconImage;
    self.selectBT.selected = !entity.isIgnore;
}
@end
