//
//  UILabel+ChangeDate.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/23.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UILabel+ChangeDate.h"

@implementation UILabel (ChangeDate)
- (void)setLabelWithText:(NSString *)text inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat
{
    if ([inputFormat isEqualToString:@"timeStemp"]) {
        NSTimeInterval time = [text doubleValue];
        if (text.length == 13) {
            time = [text doubleValue] / 1000;
        }
        NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
        
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:outputFormat];
        
        NSString *dateStr = [dateFormatter stringFromDate:detailDate];
        self.text = dateStr;
        
    }
    else
    {
        NSDateFormatter *informat = [[NSDateFormatter alloc]init];
        [informat setDateFormat:inputFormat];
        NSDate *date = [informat dateFromString:text];
        NSDateFormatter *outformat = [[NSDateFormatter alloc]init];
        [outformat setDateFormat:outputFormat];
        self.text = [outformat stringFromDate:date];
    }
}
@end
