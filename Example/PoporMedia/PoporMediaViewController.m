//
//  PoporMediaViewController.m
//  PoporMedia
//
//  Created by wangkq on 06/20/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporMediaViewController.h"

#import <Masonry/Masonry.h>

#import <PoporMedia/NSObject+PickImage.h>

#import <PoporMedia/BurstShotImagePreviewCC.h>
#import <PoporFoundation/SizePrefix.h>
#import <PoporUI/UIView+Extension.h>
#import <PoporUI/UIImage+Tool.h>
#import <PoporMedia/ImageDisplayVC.h>

#import <PoporMedia/PoporImageBrowseVCRouter.h>

#import <PoporFoundation/FunctionPrefix.h>

//#define NSLogRect0(rect0)  NSLog(@"CGRect: = %@", NSStringFromCGRect(rect0))

//#define NSLogRect1(rect) NSLog(@"CGRect:%s = {(%f,%f),(%f,%f)}", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
//#define NSLogRect2(rect2)  NSLog(@"CGRect:%s = %@", #rect2, NSStringFromRect(rect2))
//#define NSLogRect(rect)  NSLog(@"CGRect:%s = %@", #rect, NSStringFromRect(rect))

@interface PoporMediaViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * cv;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic        ) CGSize         ccSize;
@property (nonatomic, strong) NSMutableArray * imageDisplaySVEntityArray;
@property (nonatomic, weak  ) ImageDisplayEntity * lastPhotoEntity;

@end

@implementation PoporMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;

    NSLogRect(self.view.frame);
    NSLogSize(self.view.size);
    NSLogPoint(self.view.origin);
    
    NSLogRange(NSMakeRange(12, 21));

    
    self.title = @"media";
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"多张" style:UIBarButtonItemStylePlain target:self action:@selector(addImageNAction)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"单张" style:UIBarButtonItemStylePlain target:self action:@selector(addImage1Action)];
        self.navigationItem.rightBarButtonItems = @[item1, item2];
    }
    self.imageArray = [NSMutableArray new];
    self.cv         = [self addCV];
}

- (void)addImage1Action {
    [self addImageNum:1];
}

- (void)addImageNAction {
    [self addImageNum:9];
}

- (void)addImageNum:(int)num {
    if (num <= 0) {
        num = 1;
    }
    __weak typeof(self) weakSelf = self;
    [self showImageACTitle:@"添加图片" message:nil vc:self maxCount:num origin:YES block:^(NSArray *images, NSArray *assets, BOOL origin) {
        if (assets) {
            // 可以使用原图上传的情况
            for (int i = 0; i<images.count; i++) {
                // somecode
                UIImage * image = images[i];
                [PHAsset getImageFromPHAsset:assets[i] finish:^(NSData *data) {
                    NSData * imageData;
                    imageData = data;
                }];
                
                ImageDisplayEntity * entity = [ImageDisplayEntity new];
                entity.originImage = image;
                entity.iconImage   = [UIImage imageFromImage:image size:CGSizeMake(weakSelf.ccSize.width * 2, weakSelf.ccSize.height * 2)];
                entity.ignore = NO;
                
                [weakSelf.imageArray addObject:entity];
            }
        }else{
            for (UIImage * image in images) {
                // somecode
                ImageDisplayEntity * entity = [ImageDisplayEntity new];
                entity.originImage = image;
                entity.iconImage   = [UIImage imageFromImage:image size:CGSizeMake(weakSelf.ccSize.width * 2, weakSelf.ccSize.height * 2)];
                entity.ignore = NO;
                
                [weakSelf.imageArray addObject:entity];
            }
        }
        
        [weakSelf.cv reloadData];
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
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BurstShotImagePreviewCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ImageDisplayEntity * entity = self.imageArray[indexPath.row];
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
    [self showImageDisplayVC:collectionView indexPath:indexPath];
}

- (void)showImageDisplayVC:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    //BurstShotImagePreviewCC *cell = (BurstShotImagePreviewCC *)[collectionView cellForItemAtIndexPath:indexPath];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    float y = [collectionView convertPoint:collectionView.frame.origin toView:window].y;

    self.imageDisplaySVEntityArray = [NSMutableArray new];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        BurstShotImagePreviewCC * tempCC = (BurstShotImagePreviewCC *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        ImageDisplayEntity * ccEntity = self.imageArray[i];
        
        CGRect frame = CGRectOffset(tempCC.frame, 0, y);
        ImageDisplayEntity *entity = [[ImageDisplayEntity alloc] initWithUrl:nil originImage:ccEntity.originImage rect:frame];
        [self.imageDisplaySVEntityArray addObject:entity];
        if (indexPath.row == i) {
            self.lastPhotoEntity = entity;
        }
    }
    
    ImageDisplayVC * oneVC = [[ImageDisplayVC alloc] init];
    //oneVC.needHiddenNVBar = @(YES);
    
    UIViewController *vc = self;
    
//    CGPoint center = [cell convertPoint:cell.frame.origin toView:vc.view];
//    center.y += 20;
//    __weak typeof(self) weakSelf = self;
//    [oneVC showInNC:vc.navigationController push:NO fromFrame:self.lastPhotoEntity.thumbnailImageRect offsetOpenY:100 offsetCloseY:0 entity:self.lastPhotoEntity entityArray:self.imageDisplaySVEntityArray openBlock:^{
//        //[weakSelf.view.vc.navigationController setNavigationBarHidden:YES animated:NO];
//    } willCloseBlock:^(BOOL isAtFirstChatView,int currentIndex) {
//        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
//    } didCloseBlock:^(BOOL isEditText, NSMutableArray *imageEntityArray) {
//
//    }];
    
    __weak typeof(self) weakSelf = self;
    ImageDisplayVCWillCloseBlock willCloseBlock = ^(BOOL isAtFirstChatView,int currentIndex) {
        [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
    };
    
    NSDictionary * dic = @{@"baseNC":self.navigationController,
                           @"startImageFrame":@(self.lastPhotoEntity.thumbnailImageRect),
                           @"currentImageEntity":self.lastPhotoEntity,
                           @"imageEntityArray":self.imageDisplaySVEntityArray,
                           @"willCloseBlock":willCloseBlock,
                           };
    [PoporImageBrowseVCRouter vcWithDic:dic];
}

@end
