//
//  ShoppingInfoController.m
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShoppingInfoController.h"

@interface ShoppingInfoController ()

@end

@implementation ShoppingInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(13, 80.5, 85, 42.5)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"Estimated Shipping";
    label1.font = [UIFont systemFontOfSize:13];
    label1.numberOfLines = 0;
    label1.layer.borderWidth = 0.5;
    label1.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(13, 123, 85, 28.5)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"Avaliability";
    label2.font = [UIFont systemFontOfSize:13];
    label2.numberOfLines = 0;
    label2.layer.borderWidth = 0.5;
    label2.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(13, 151.5, 85, 43)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"Estimated Arrival";
    label3.font = [UIFont systemFontOfSize:13];
    label3.numberOfLines = 0;
    label3.layer.borderWidth = 0.5;
    label3.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(13, 221.5, 85, 76.5)];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"Return Policy";
    label4.font = [UIFont systemFontOfSize:13];
    label4.numberOfLines = 0;
    label4.layer.borderWidth = 0.5;
    label4.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label4];
    
    UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(13, 194.5, 85, 27)];
    label9.textAlignment = NSTextAlignmentCenter;
    label9.text = @"Ships From";
    label9.font = [UIFont systemFontOfSize:13];
    label9.numberOfLines = 0;
    label9.layer.borderWidth = 0.5;
    label9.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label9];
    
    //钱
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(97.5, 80.5, SCREEN_W - 124, 42.5)];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = [self.shipping_info valueForKey:@"EstimatedShipping"];
    label5.font = [UIFont systemFontOfSize:13];
    label5.numberOfLines = 0;
    label5.layer.borderWidth = 0.5;
    label5.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(97.5, 123, SCREEN_W - 124, 28.5)];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = [_shipping_info valueForKey:@"Availability"];
    label6.font = [UIFont systemFontOfSize:13];
    label6.numberOfLines = 0;
    label6.layer.borderWidth = 0.5;
    label6.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label6];
    
    //时间
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(97.5, 151.5, SCREEN_W - 124, 43)];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.text = [_shipping_info valueForKey:@"EstimatedArrival"];
    label7.font = [UIFont systemFontOfSize:13];
    label7.numberOfLines = 0;
    label7.layer.borderWidth = 0.5;
    label7.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label7];
    
    //来源地
    UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(97.5, 194.5, SCREEN_W - 124, 27)];
    label10.textAlignment = NSTextAlignmentCenter;
    label10.text = [self.shipping_info valueForKey:@"ShipsFrom"];
    label10.font = [UIFont systemFontOfSize:13];
    label10.numberOfLines = 0;
    label10.layer.borderWidth = 0.5;
    label10.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label10];

    //policy
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(97.5, 221.5, SCREEN_W - 124, 76.5)];
    label8.textAlignment = NSTextAlignmentCenter;
    label8.text = [self.shipping_info valueForKey:@"ReturnPolicy"];
    label8.font = [UIFont systemFontOfSize:13];
    label8.numberOfLines = 0;
    label8.layer.borderWidth = 0.5;
    label8.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.view addSubview:label8];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
