//
//  NSArray+SHYUtil.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/16.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SHYUtil)
/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;
@end
