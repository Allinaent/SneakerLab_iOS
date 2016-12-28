//
//  PayPalViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PayPalViewController.h"
#import "SelectButton.h"

@interface PayPalViewController ()
@property (nonatomic, strong) SelectButton *paypal;
@end

@implementation PayPalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Payment method";
    self.view.backgroundColor = COLOR_FA;
    self.paypal = [[SelectButton alloc] initWithImage:@"WechatIMG7" andTitle:@"PayPal"];
    self.paypal.frame = CGRectMake(0, 10, SCREEN_W, 50);
    _paypal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_paypal];
    [_paypal addTarget:self action:@selector(paypalAction) forControlEvents:UIControlEventTouchUpInside];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"payway"] boolValue]) {
        _paypal.selected = YES;
    }
}

- (void)paypalAction {
    _paypal.selected = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"payway"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 常用的应该抽成公共方法
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    [self changePaymentMethod:@"1"];
}

#pragma mark - 修改支付方式
- (void)changePaymentMethod:(NSString *)method {
    NSDictionary *dict = @{@"payment":method};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:SETPAYMENT_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
