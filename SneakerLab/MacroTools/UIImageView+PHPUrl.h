//
//  UIImageView+PHPUrl.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PHPUrl)
- (void)setPHPImageUrl:(NSString *)url;
- (void)setPHPImageUrl:(NSString *)url placeholder:(NSString *)placeholder;
@end
