//
//  RatingHeadModel.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingHeadModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *boughtNum;
@property (nonatomic, strong) NSString *saveNum;
@property (nonatomic, assign) CGFloat starNum;
@property (nonatomic, strong) NSString *ratingNum;
@property (nonatomic, strong) NSString *imageUrl;

@end
