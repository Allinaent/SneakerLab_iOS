//
//  ReviewModel.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/25.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewModel : NSObject
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *text;
@end
