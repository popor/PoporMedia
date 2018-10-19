//
//  PoporAVPlayerBundle.m
//  KVOController
//
//  Created by apple on 2018/7/17.
//

#import "PoporAVPlayerBundle.h"

@implementation PoporAVPlayerBundle

+ (NSBundle *)bundle {
    static NSBundle *refreshBundle = nil;
    if (!refreshBundle) {
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[PoporAVPlayerBundle class]] pathForResource:@"icon" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)imageName:(NSString *)name {
    static int x = -1;
    if (x == -1) {
        x = (int )[UIScreen mainScreen].scale;
    }
    NSString * path = [self pathName:name x:x];
    if (!path) {
        switch (x) {
            case 2:
                path = [self pathName:name x:3];
                break;
            case 3:
                path = [self pathName:name x:2];
                break;
        }
    }
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }else{
        return nil;
    }
}

+ (NSString *)pathName:(NSString *)name x:(int)x {
    return [[self bundle] pathForResource:[NSString stringWithFormat:@"%@@%ix", name, x] ofType:@"png"];
}

@end
