//
//  ContactUsController.m
//  caowei
//
//  Created by Jason cao on 2016/9/27.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ContactUsController.h"

@interface ContactUsController ()
@end

@implementation ContactUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Contact Us";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, 20, SCREEN_W - 40, 40) text:@"You are welcome to contact us by this email address for any help." textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+20, SCREEN_W - 40, 40)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"service@fangzhich.com"];
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
