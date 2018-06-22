//
//  PHAsset+data.m
//  linRunShengPi
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 艾慧勇. All rights reserved.
//

#import "PHAsset+data.h"

@implementation PHAsset (data)

+ (void)getImageFromPHAsset:(PHAsset *)asset finish:(void (^)(NSData *data))block {
    __block NSData *data;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version      = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous  = YES;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if ([dataUTI hasSuffix:@"heic"]) {
                // 假如发现为heic,那么不生成data,直接走默认的阿里上传压缩方式.
                data = nil;
            }else{
                data = imageData;
            }
        }];
    }
    
    if (block) {
        if (data.length <= 0) {
            block(nil);
        } else {
            block(data);
        }
    }
}

@end
