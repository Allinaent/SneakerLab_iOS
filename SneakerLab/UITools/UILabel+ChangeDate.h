//
//  UILabel+ChangeDate.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/23.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeDate)
- (void)setLabelWithText:(NSString *)text inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat;
@end
