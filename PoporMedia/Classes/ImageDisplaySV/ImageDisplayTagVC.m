//
//  ImageDisplayTagVC.m
//  linRunShengPi
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import "ImageDisplayTagVC.h"
#import <PoporFoundation/ColorPrefix.h>
#import <Masonry/Masonry.h>

@interface ImageDisplayTagVC ()

//@property (nonatomic, strong) UILabel * ivTitleL;
@property (nonatomic, strong) UIButton * tagBT;

@end

@implementation ImageDisplayTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupIVTitleL];
}

- (void)setupIVTitleL {
    self.tagBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = RGBA(0, 0, 0, 0.5);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(btAction) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    [self.tagBT.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.tagBT.titleLabel.numberOfLines = 0;
    [self.tagBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(52);
        make.bottom.mas_equalTo(-44);
    }];
    [self updateIvTitleText];
}

- (void)updateIvTitleText {
    ImageDisplayEntity * oneEntity = self.imageEntityArray[self.currentIndex];
    if (oneEntity.title) {
        [self.tagBT setTitle:[NSString stringWithFormat:@"　%@　", oneEntity.title] forState:UIControlStateNormal];
        self.tagBT.hidden = NO;
    }else{
        self.tagBT.hidden = YES;
    }
}

- (void)resetSVImageAt:(int)index {
    [super resetSVImageAt:index];
    
    [self updateIvTitleText];
}

- (void)btAction {
    if (self.tagBlock) {
        ImageDisplayEntity * oneEntity = self.imageEntityArray[self.currentIndex];
        
        __weak typeof(self) weakSelf = self;
        BlockPDic imageDisplayTagFinishBlock = ^(NSDictionary * dic) {
            oneEntity.title = dic[@"title"];
            
            [weakSelf updateIvTitleText];
        };
        
        NSDictionary * dic = @{@"view":self.navigationController.view,
                               @"ImageDisplayEntity":oneEntity,
                               @"imageDisplayTagFinishBlock":imageDisplayTagFinishBlock,
                               };
        self.tagBlock(dic);
    }
}

@end
