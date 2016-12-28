//
//  AddressModel.h
//  SneakerLab
//
//  Created by edz on 2016/10/25.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "address_1" = fghhfghhn;
 "address_id" = 35;
 city = fghbnfgnnn;
 company = "";
 country = Andorra;
 "country_id" = 5;
 fullname = sdfgfghhjm;
 phone = 123456;
 postcode = xvvbbnvbnn;
 suite = fghhjnfghjjn;
 zone = "Andorra la Vella";
 "zone_code" = ALV;
 "zone_id" = 122;
 */
@interface AddressModel : NSObject
@property(nonatomic,copy)NSString *address_1;
@property(nonatomic,copy)NSString *address_id;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *country_id;
@property(nonatomic,copy)NSString *fullname;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *postcode;
@property(nonatomic,copy)NSString *suite;
@property(nonatomic,copy)NSString *zone;
@property(nonatomic,copy)NSString *zone_code;
@property(nonatomic,copy)NSString *zone_id;
@end
