//
//  PoporVideoVC.m
//  PoporMedia_Example
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018 wangkq. All rights reserved.
//

#import "PoporVideoVC.h"

#import <Masonry/Masonry.h>

#import <PoporMedia/PoporMedia.h>

#import <PoporMedia/BurstShotImagePreviewCC.h>
#import <PoporFoundation/PrefixSize.h>
#import <PoporUI/UIView+Extension.h>
#import <PoporUI/UIImage+Tool.h>
#import <PoporFoundation/PrefixFun.h>
#import <PoporImageBrower/PoporImageBrower.h>

@interface PoporVideoVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * cv;
@property (nonatomic, strong) NSMutableArray<PoporMediaImageEntity *> * videoArray;
@property (nonatomic        ) CGSize         ccSize;

@property (nonatomic, strong) PoporMedia * poporMedia;

@end

@implementation PoporVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    self.view.backgroundColor = [UIColor whiteColor];

    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addImage1Action)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
    self.videoArray = [NSMutableArray new];
    self.cv         = [self addCV];
}

- (void)addImage1Action {
    [self addImageNum:1];
}

- (void)addImageNum:(int)num {
    if (num <= 0) {
        num = 1;
    }
    self.poporMedia = [PoporMedia new];
    __weak typeof(self) weakSelf = self;
    [self.poporMedia showVideoACTitle:@"添加视频" message:nil vc:self videoIconSize:self.ccSize block:^(NSString *videoPath, NSData *imageData, UIImage *image, PHAsset *phAsset, CGFloat time, CGFloat videoSize) {
        
    }];
}

- (UICollectionView *)addCV {
    float gap   = 10;
    int colume  = 4;
    float width = (ScreenSize.width - gap*(colume-1))/colume;
    self.ccSize = CGSizeMake(width, width);
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    UICollectionView * cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.ccSize.height+ 12) collectionViewLayout:layout];
    cv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    cv.indicatorStyle  = UIScrollViewIndicatorStyleWhite;
    cv.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -1.5, 0);
    
    [self.view addSubview:cv];
    //cv.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [cv registerClass:[BurstShotImagePreviewCC class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    //[cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    cv.delegate   = self;
    cv.dataSource = self;
    
    [cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    return cv;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BurstShotImagePreviewCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.selectBT.hidden = YES;
    
    PoporMediaImageEntity * entity = self.videoArray[indexPath.row];
    NSLog(@"cell index: %i", (int)indexPath.row);
    [cell setImageEntity:entity];
    return cell;
}

#pragma layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.ccSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showVideoDisplayVC:collectionView indexPath:indexPath];
}

- (void)showVideoDisplayVC:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    
}


@end
