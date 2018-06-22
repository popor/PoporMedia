//
//  PoporMediaViewController.m
//  PoporMedia
//
//  Created by wangkq on 06/20/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporMediaViewController.h"

#import <PoporMedia/NSObject+PickImage.h>

@interface PoporMediaViewController ()



@end

@implementation PoporMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"media";
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addImageAction)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (void)addImageAction {
    [self showImageACTitle:@"添加图片" message:nil vc:self maxCount:9 origin:YES block:^(NSArray *images, NSArray *assets, BOOL origin) {
        
    }];
    
}

@end
