//
//  SetPersonInfoViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/28.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "SetPersonInfoViewController.h"

@interface SetPersonInfoViewController ()
@property (nonatomic, strong) UITextField *firstname;
@property (nonatomic, strong) UITextField *lastname;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *tel;
@property (nonatomic, strong) UITextField *oldpassword;
@property (nonatomic, strong) UITextField *newpassword;
@property (nonatomic, strong) UITextField *retry;
@end

@implementation SetPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.headline;
    SET_NAV_MIDDLE
    if ([self.headline isEqualToString:@"Name"]) {
        [self createNameView];
    }else if ([self.headline isEqualToString:@"Email"]){
        [self createEmailView];
    }else if ([self.headline isEqualToString:@"Change Password"]){
        [self createChangePasswordView];
    }else{
        [self createTelView];
    }
}

- (void)createChangePasswordView {
    _oldpassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_oldpassword];
    _oldpassword.placeholder = @"Old password";

    _oldpassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _oldpassword.leftViewMode = UITextFieldViewModeAlways;
    _oldpassword.leftViewMode = UITextFieldViewModeAlways;
    _oldpassword.layer.borderWidth = 0.5;
    _oldpassword.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _newpassword = [[UITextField alloc] initWithFrame:CGRectMake(10, 111.5, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_newpassword];
    _newpassword.placeholder = @"New password";
    _newpassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _newpassword.leftViewMode = UITextFieldViewModeAlways;
    _newpassword.leftViewMode = UITextFieldViewModeAlways;
    _newpassword.layer.borderWidth = 0.5;
    _newpassword.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _newpassword.secureTextEntry = YES;
    
    _retry = [[UITextField alloc] initWithFrame:CGRectMake(10, 153, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_retry];
    _retry.placeholder = @"Confirm password";
    _retry.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _retry.leftViewMode = UITextFieldViewModeAlways;
    _retry.leftViewMode = UITextFieldViewModeAlways;
    _retry.layer.borderWidth = 0.5;
    _retry.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _retry.secureTextEntry = YES;
    
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(10, 214.5, SCREEN_W-20, 40.5)];
    [self.view addSubview:commit];
    commit.layer.cornerRadius = 3;
    commit.layer.masksToBounds = YES;
    commit.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    [commit setTitle:@"Submit" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    [commit addTarget:self action:@selector(submit4) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createNameView {
    _firstname = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_firstname];
    _firstname.placeholder = @"First Name";
    _firstname.text = _firstnamestr;
    _firstname.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _firstname.leftViewMode = UITextFieldViewModeAlways;
    _firstname.leftViewMode = UITextFieldViewModeAlways;
    _firstname.layer.borderWidth = 0.5;
    _firstname.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _lastname = [[UITextField alloc] initWithFrame:CGRectMake(10, 111.5, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_lastname];
    _lastname.placeholder = @"Last Name";
    _lastname.text = _lastnamestr;
    _lastname.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _lastname.leftViewMode = UITextFieldViewModeAlways;
    _lastname.leftViewMode = UITextFieldViewModeAlways;
    _lastname.layer.borderWidth = 0.5;
    _lastname.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(10, 173, SCREEN_W-20, 40.5)];
    [self.view addSubview:commit];
    commit.layer.cornerRadius = 3;
    commit.layer.masksToBounds = YES;
    commit.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    [commit setTitle:@"Submit" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    [commit addTarget:self action:@selector(submit4) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createEmailView {
    _email = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_email];
    _email.placeholder = @"Email";
    _email.text = _emailstr;
    _email.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _email.leftViewMode = UITextFieldViewModeAlways;
    _email.leftViewMode = UITextFieldViewModeAlways;
    _email.layer.borderWidth = 0.5;
    _email.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(10, 107, SCREEN_W-20, 40.5)];
    [self.view addSubview:commit];
    commit.layer.cornerRadius = 3;
    commit.layer.masksToBounds = YES;
    commit.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    [commit setTitle:@"Submit" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    [commit addTarget:self action:@selector(submit2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTelView {
    _tel = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, SCREEN_W - 20, 31.5)];
    [self.view addSubview:_tel];
    _tel.placeholder = @"Tel";
    _tel.text = _telstr;
    _tel.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tel.leftViewMode = UITextFieldViewModeAlways;
    _tel.layer.borderWidth = 0.5;
    _tel.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    UIButton *commit = [[UIButton alloc] initWithFrame:CGRectMake(10, 107, SCREEN_W-20, 40.5)];
    [self.view addSubview:commit];
    commit.layer.cornerRadius = 3;
    commit.layer.masksToBounds = YES;
    commit.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    [commit setTitle:@"Submit" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    [commit addTarget:self action:@selector(submit3) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submit1 {
    NSDictionary *dic = @{@"firstname":self.firstname.text,@"lastname":self.lastname.text,@"phone":@"",@"sex":@"",@"age":@"",@"birthday":@""};
    [self changeInfoWithDic:dic];
}

- (void)submit2 {
    NSDictionary *dic = @{@"email_new":_email.text};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:CHANGEEMAILINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"status_code"] integerValue]==0) {
            [MBManager showBriefAlert:@"Success"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Fail"];
    }];
}

- (void)submit3 {
    NSDictionary *dic = @{@"firstname":@"",@"lastname":@"",@"sex":@"",@"age":@"",@"birthday":@"",@"phone":_tel.text};
    [self changeInfoWithDic:dic];
}

- (void)submit4 {
    if (![_newpassword.text isEqualToString:_retry.text]) {
        [MBManager showBriefAlert:@"new password conflict"];
        return;
    }
    NSDictionary *dic = @{@"old_password":_oldpassword.text,@"new_password":_newpassword.text};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:CHANGEPASSWORD_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"status_code"] integerValue]==0) {
            [MBManager showBriefAlert:@"Success"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBManager showBriefAlert:@"Fail"];
        }
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Fail"];
    }];
}

- (void)changeInfoWithDic:(NSDictionary *)dic {
    [PHPNetwork PHPNetworkWithParam:dic andUrl:CHANGEPERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"status_code"] integerValue]==0) {
            [MBManager showBriefAlert:@"Success"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Fail"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
