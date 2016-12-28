//
//  UIImage+GSet.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GSet)
+ (instancetype)setImageWithName:(NSString *)name;
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
