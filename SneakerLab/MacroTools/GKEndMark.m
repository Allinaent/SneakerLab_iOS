//
//  GKEndMark.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/11.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GKEndMark.h"

@implementation GKEndMark
+ (instancetype)end {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}
@end
