//
//  DetailModel.h
//  SneakerLab
//
//  Created by edz on 2016/10/27.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrductModel_OPTiON.h"
@interface DetailModel : NSObject

//             [0]	(null)	@"required" : @"1"
//[0]	(null)	@"required" : @"1"	数组
//                ／[1]	(null)	@"required" : @"12 elements"
//[2]	(null)	@"value" : @""
//
//         }[3]	(null)	@"type" : @"select"
//  [4]	(null)	@"product_option_id" : @"260"
//[5]	(null)	@"option_id" : @"14"
//[6]	(null)	@"name" : @"size"
//@property(nonatomic,copy)NSString * value;
//	@"product_option_value" : @"12 elements"
@property(nonatomic,copy)NSString * required;
@property(nonatomic,strong)PrductModel_OPTiON *product_option_value;
@property(nonatomic,copy)NSString * value;
@property(nonatomic,copy)NSString * product_option_id;
@property(nonatomic,copy)NSString * option_id;
@property(nonatomic,copy)NSString * name;


@end
