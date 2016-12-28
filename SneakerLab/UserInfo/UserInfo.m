//
//  UserInfo.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (instancetype)sharedUserInfo
{
    static UserInfo *info = nil;
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        info = [UserInfo new];
    });
    return info;
}
@end
