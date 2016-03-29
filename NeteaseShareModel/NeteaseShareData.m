//
//  NeteaseShareData.m
//  NeteaseShareSDKDemo
//
//  Created by Liuyong on 14-8-8.
//  Copyright (c) 2014年 FlyWire. All rights reserved.
//

#import "NeteaseShareData.h"

@implementation NeteaseShareData

+ (id)message
{
    NeteaseShareData *data = [[[self class] alloc] init];
    return data;
}

@end


@implementation NeteaseBaseMediaObject

+ (id)object
{
    NeteaseBaseMediaObject *object = [[[self class] alloc] init];
    
    return object;
}

@end


@implementation NeteaseImageObject

+ (id)object
{
    NeteaseImageObject *imageObject = [[[self class] alloc] init];
    
    return imageObject;
}

- (UIImage *)image
{
    if (self.imageData) {
        return  [UIImage imageWithData:self.imageData];
    }
    
    return nil;
}
@end


@implementation NeteaseWebpageObject



@end