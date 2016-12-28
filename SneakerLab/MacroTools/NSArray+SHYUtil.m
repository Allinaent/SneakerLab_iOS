//
//  NSArray+SHYUtil.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/16.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NSArray+SHYUtil.h"

@implementation NSArray (SHYUtil)
- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        NSAssert(NO, @"数组越界");
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end
