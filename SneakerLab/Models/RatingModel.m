//
//  RatingModel.m
//  caowei
//
//  Created by Jason cao on 2016/9/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RatingModel.h"

@implementation RatingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    self.height = [_text boundingRectWithSize:CGSizeMake(SCREEN_W - 90, SCREEN_H) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
}
@end
