//
//  OrderProduct.h
//  SneakerLab
//
//  Created by edz on 2016/11/1.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionModel.h"
@interface OrderProduct : NSObject
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSArray *option;
@property(nonatomic,copy)NSString *order_product_id;
@property(nonatomic,copy)NSString *price ;
@property(nonatomic,copy)NSString *quantity;
@property(nonatomic,copy)NSString *total;
@property(nonatomic,assign)CGFloat cellHeight;

@end
