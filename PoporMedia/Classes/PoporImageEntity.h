//
//  PoporImageEntity.h
//  Masonry
//
//  Created by apple on 2018/10/17.
//

#import <PoporImageBrower/PoporImageBrower.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoporImageEntity : PoporImageBrowerEntity

@property (nonatomic, getter=isIgnore) BOOL ignore;  // 是否忽略,用于NSObject+PickImage

@end

NS_ASSUME_NONNULL_END
