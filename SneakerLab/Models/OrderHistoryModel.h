//
//  OrderHistoryModel.h
//  SneakerLab
//
//  Created by edz on 2016/11/1.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryModel : NSObject
@property(nonatomic,copy)NSString *date_added;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_status;
@property(nonatomic,copy)NSArray *product;
@property(nonatomic,copy)NSString *total;

@end
