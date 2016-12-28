//
//  ForgetPasswdController.m
//  caowei
//
//  Created by Jason cao on 2016/9/13.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ForgetPasswdController.h"

@interface ForgetPasswdController ()

@end

@implementation ForgetPasswdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Forget Password";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, SCREEN_W - 20, 20) text:@"Let's reset your password" textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label];
    
    UITextField *emailTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, SCREEN_W - 20, 30)];
    emailTF.placeholder = @"Email";
    emailTF.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:emailTF];
    
    UIButton *btn = [FactoryUI createButtonWithFrame:CGRectMake(10, 95, SCREEN_W - 20, 40) title:@"Reset Password" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(btnClicked)];
    [self.view addSubview:btn];
}

- (void)btnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    
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
