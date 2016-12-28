//
//  ShoppingCartModel.h
//  caowei
//
//  Created by Jason cao on 2016/9/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject
@property (nonatomic , copy) NSString *cart_id;
@property (nonatomic , copy) NSString *product_id;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSArray *options;
@property (nonatomic , copy) NSString *quantity;
@property (nonatomic , copy) NSString *stock;
@property (nonatomic , copy) NSString *shipping;
@property (nonatomic , copy) NSString *original_price;
@property (nonatomic , copy) NSString *special_price;
@property (nonatomic , copy) NSString *image;
@property (nonatomic , copy) NSString *rating; // 星级
@property (nonatomic , copy) NSString *reward; // 评价数
@property (nonatomic , copy) NSString *reviews;
@property (nonatomic , copy) NSString *tax_class_id;
@property (nonatomic , copy) NSString *model;
@end
