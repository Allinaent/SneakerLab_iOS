//
//  RatingController.h
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingController : UIViewController
@property (nonatomic , strong) NSString *productID;
@property (nonatomic , strong) NSString *productName;
@property (nonatomic , strong) NSString *productImage;
@property (nonatomic , strong) NSString *bought;
@property (nonatomic , assign) NSInteger save;
@property (nonatomic , assign) NSInteger ratingNum;
@property(nonatomic,assign)CGFloat star;
@end
