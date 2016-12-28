//
//  GEditAddressViewController.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEditAddressViewController : UIViewController
//type:billing,shipping
@property (nonatomic, strong) NSString *type;
//判段是否需要继续填写信息
@property (nonatomic, assign) BOOL next;
@property (nonatomic, assign) BOOL add;
@property (nonatomic, strong) NSString *address_id;
@end
