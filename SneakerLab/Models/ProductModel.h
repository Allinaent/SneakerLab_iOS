//
//  ProductModel.h
//  caowei
//
//  Created by Jason cao on 2016/9/22.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 data =     (
 {
 "date_added" = "2016-10-16 15:34:12";
 "date_modified" = "2016-10-17 10:56:11";
 image = "http://api.fangzhich.com/image/cache/catalog/Foamposite/paranorman/Nike%20Anfernee%20Hardaway%20Basketball%20Shoes%20Nike%20Air%20Foamposite%20One%20ParaNorman%20%2041-47%20(3)-750x750.jpg";
 name = "NIKE AIR FOAMPOSITE ONE Paranorman";
 "original_price" = "3250.00";
 points = 0;
 "product_id" = 79;
 quantity = "-15";
 "special_price" = "688.00";
 viewed = 0;
 }
 );
 


**/
@interface ProductModel : NSObject
@property (nonatomic , copy) NSString *product_id;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *image;
@property (nonatomic , copy) NSString *original_price;
@property (nonatomic , copy) NSString *special_price;
@property (nonatomic , copy) NSString *quantity;
@property (nonatomic , copy) NSString *point;// 点赞量
@property (nonatomic , copy) NSString *viewed;
@end
