//
//  RequestRefundViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/24.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RequestRefundViewController.h"

@interface RequestRefundViewController ()

@end

@implementation RequestRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Request Refund";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, 20, SCREEN_W - 40, 100) text:@"We sincerely apologize for your unsatisfication!If you want to apply for refund,please send your refund application to our customer service email account.We shall reply you and handle your application ASAP." textColor:COLOR_9 font:[UIFont systemFontOfSize:16]];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+20, SCREEN_W - 40, 40)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"customer@fangzhich.com"];
    text.textAlignment = 1;
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#444444"] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:strRange];
    [text setAttributedText:str];
    text.dataDetectorTypes = UIDataDetectorTypeLink;
    text.editable = NO;
    text.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
