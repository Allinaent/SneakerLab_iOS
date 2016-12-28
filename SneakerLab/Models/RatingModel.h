//
//  RatingModel.h
//  caowei
//
//  Created by Jason cao on 2016/9/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingModel : NSObject
@property (nonatomic , copy) NSString *author;
@property (nonatomic , copy) NSString *rating;
@property (nonatomic , copy) NSString *text;
@property (nonatomic , copy) NSString *data_added;
@property (nonatomic , copy) NSString *date_modified;
@property (nonatomic, assign) CGFloat height;
@end
