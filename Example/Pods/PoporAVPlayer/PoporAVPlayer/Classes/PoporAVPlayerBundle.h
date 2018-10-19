//
//  PoporAVPlayerBundle.h
//  KVOController
//
//  Created by apple on 2018/7/17.
//

#import <Foundation/Foundation.h>

#define PoporAVImage(name) [PoporAVPlayerBundle imageName:name]

@interface PoporAVPlayerBundle : NSObject

+ (UIImage *)imageName:(NSString *)name;

@end
