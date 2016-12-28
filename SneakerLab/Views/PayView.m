//
//  PayView.m
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PayView.h"
#import "AddressInfoView.h"
@implementation PayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
 
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(15, 20, 80, 16.5) text:@"Miscellaneous" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:label1];
    
    UIButton *cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 55, 15, 40, 20) title:@"cancel" titleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] imageName:nil backgroundImageName:nil target:self selector:@selector(cancelAction)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:cancelBtn];
    
    UIButton *creditCardBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, 35, SCREEN_W, 60) title:nil titleColor:nil imageName:nil backgroundImageName:@"visa" target:self selector:nil];
    [self addSubview:creditCardBtn];
    
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(15, 105, 80, 20) text:@"Credit Card" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    [self addSubview:label2];
    
    _creditCardTF= [[UITextField alloc] initWithFrame:CGRectMake(15, 50, SCREEN_W - 30, 32)];
    _creditCardTF.placeholder = @"Miscellaneous";
    _creditCardTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _creditCardTF.layer.borderWidth = 0.5;
    _creditCardTF.delegate = self;
    _creditCardTF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_creditCardTF];
    
    UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W - 70, 50, 40, 32) imageName:@""];
    [self addSubview:imageView];
    
    UILabel *label3 = [FactoryUI createLabelWithFrame:CGRectMake(15, 97, 100, 30) text:@"Security Code" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self addSubview:label3];
    
    UILabel *label4 = [FactoryUI createLabelWithFrame:CGRectMake(15, 137, 220, 30) text:@"The 3 or 4 digit security code on the front or back of your credit card" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    label4.numberOfLines = 0;
    [self addSubview:label4];
    
    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 97, SCREEN_W - 220, 30)];
    _codeTF.placeholder = @"  CVV";
    _codeTF.delegate = self;
    _codeTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _codeTF.layer.borderWidth = 0.5;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_codeTF];
    
    UILabel *label5 = [FactoryUI createLabelWithFrame:CGRectMake(15, 182, 100, 15) text:@"Expirty date" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self addSubview:label5];
    
    _dateTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 182, SCREEN_W - 220, 30)];
    _dateTF.placeholder = @"  MM/YY";
    _dateTF.delegate = self;
    _dateTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _dateTF.layer.borderWidth = 0.5;
    _dateTF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_dateTF];
    
    UILabel *label6 = [FactoryUI createLabelWithFrame:CGRectMake(15, 228, 150, 30) text:@"Billing Zip/Postal Code" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    label6.numberOfLines = 0;
    [self addSubview:label6];
    
    UILabel *label7 = [FactoryUI createLabelWithFrame:CGRectMake(15, 265.5, 220, 30) text:@"The zip postal code from the address registered for this credit card" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    label7.numberOfLines = 0;
    [self addSubview:label7];
    
    _postalCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 228, SCREEN_W -220, 30)];
    _postalCodeTF.placeholder = @"  Zip/Postal Code";
    _postalCodeTF.delegate = self;
    _postalCodeTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _postalCodeTF.layer.borderWidth = 0.5;
    [self addSubview:_postalCodeTF];
    
    UIButton *saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(17, 335.5, SCREEN_W - 34, 40) title:@"Save payment Info" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(saveInfo)];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:saveBtn];
    
    UIImageView *imageView1 = [FactoryUI createImageViewWithFrame:CGRectMake(24.5, 390, 15, 20) imageName:@"锁"];
    [self addSubview:imageView1];
    
    UILabel *label8 = [FactoryUI createLabelWithFrame:CGRectMake(45, 390, 100, 15) text:@"Secure Payment" textColor:[UIColor lightGrayColor] font:[UIFont boldSystemFontOfSize:12]];
    [self addSubview:label8];
    
    UILabel *label9 = [FactoryUI createLabelWithFrame:CGRectMake(45, 410, 300, 15) text:@"Trusted by over 100 milllion shoppers in 50 countries" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    label9.numberOfLines = 0;
    [self addSubview:label9];
}

- (void)saveInfo
{
    [self loadData];
    
    AddressInfoView *addressInfo = [[AddressInfoView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_W, SCREEN_H)];
    [self addSubview:addressInfo];
    [UIView animateWithDuration: 0.35 animations: ^{
        addressInfo.center = self.center;
        addressInfo.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion: nil];
}

- (void)loadData
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"token",@"email",@"equipment_id",@"number",@"thru",@"cvc2"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"token" : CWTOKEN,
                          @"number" : _creditCardTF.text,
                          @"thru" : _dateTF.text,
                          @"cvc2" : _codeTF.text
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    
    [[CWAPIClient sharedClient] POSTRequest:ADDCREDITCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];

}

- (void)cancelAction
{
    [self removeFromSuperview];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger length = textField.text.length - range.length + string.length;
    if (textField == _creditCardTF)
    {
        if (length > 16)
        {
            return NO;
        }
    }
    if (textField == _dateTF)
    {
        if (length > 5)
        {
            return NO;
        }
        else
        {
            //NSString *str = _dateTF.text;
            
        }
    }
    if (textField == _codeTF)
    {
        if (length > 3)
        {
            return NO;
        }
    }
    return YES;
}
@end
