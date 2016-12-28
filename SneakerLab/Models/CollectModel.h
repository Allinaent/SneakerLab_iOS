//
//  CollectModel.h
//  SneakerLab
//
//  Created by edz on 2016/10/21.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "date_added" = "2016-10-19 13:30:17";
 image = "http://api.fangzhich.com/image/cache/catalog/Foamposite/white/Nike%20Anfernee%20Hardaway%20Basketball%20Shoes%20Men%20Size%2041-476%20(4)-500x500.jpg";
 name = "NIKE AIR FOAMPOSITE ONE White";
 price = "250.00";
 "product_id" = 82;
 */
@interface CollectModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * date_added;
@property(nonatomic,copy)NSString * product_id;
@property(nonatomic,copy)NSString * price;

@end
