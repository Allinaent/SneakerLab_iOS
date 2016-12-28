//
//  PersonlityController.m
//  caowei
//
//  Created by Jason cao on 2016/9/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PersonlityController.h"
#import "DatePickerView.h"
#import "MyPickView.h"
#import "RootViewController.h"
#import "WelcomeController.h"
@interface PersonlityController () <UITextFieldDelegate>
{
    UILabel *_genderLabel;
    DatePickerView *_datePickerView;
}
@property (nonatomic , strong) UITextField *birthdayText;
@end

@implementation PersonlityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Personalize";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skipAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 75, 10, 150, 20) text:@"Tell us about youself" textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] font:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:label1];
    
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 100, 40, 200, 20) text:@"We'll find products you'll love!" textColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label2];
    
    UILabel *birthdayTitle = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 25, 90, 80, 15) text:@"Birthday" textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] font:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:birthdayTitle];
    
    _genderLabel = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 65, 250, 130, 30) text:nil
    textColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] font:[UIFont systemFontOfSize:16]];
    [_genderLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGenderPickerView)]];
    _genderLabel.textAlignment = NSTextAlignmentCenter;
    _genderLabel.userInteractionEnabled = YES;
    _genderLabel.layer.borderWidth = 1;
    [self.view addSubview:_genderLabel];
    
//    UIButton *changeBtn = [FactoryUI createButtonWithFrame:CGRectMake(self.view.center.x - 65, 225, 130, 30) title:@"Change" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(changeAction)];
//    changeBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.72 blue:0.92 alpha:1];
//    [self.view addSubview:changeBtn];
    
    UILabel *genderTitle = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 20, 205, 60, 30) text:@"Gender" textColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] font:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:genderTitle];
    
    _birthdayText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.center.x - 50, 115, 100, 30)];
    _birthdayText.delegate = self;
    _birthdayText.textAlignment = NSTextAlignmentCenter;
    _birthdayText.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    _birthdayText.font = [UIFont systemFontOfSize:14];
    _birthdayText.borderStyle = UITextBorderStyleRoundedRect;
    _birthdayText.layer.borderColor = [UIColor blackColor].CGColor;
    
    _datePickerView = [[DatePickerView alloc] initWithCustomeHeight:250];
    __weak typeof (self) weakSelf = self;
    _datePickerView.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
        weakSelf.birthdayText.text = choseDate;//选择的生日
    };
    _datePickerView.cannelBlock = ^()
    {
        [weakSelf.view endEditing:YES];
    };
    //设置textfield的键盘 替换为我们的自定义view
    _birthdayText.inputView = _datePickerView;

    [self.view addSubview:_birthdayText];
    
    UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x + 40, 255, 20, 20) imageName:@"下拉箭头@3x"];
    [self.view addSubview:imageView];

    UIButton *nextBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 295, SCREEN_W - 20, 40) title:@"NEXT" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(nextAction)];
    nextBtn.backgroundColor = [UIColor colorWithRed:0.85 green:0.29 blue:0.24 alpha:1];
    nextBtn.layer.cornerRadius = 4;
    [self.view addSubview:nextBtn];
}

#pragma mark ----按钮点击
- (void)changeAction
{
    [self.view endEditing:YES];
}

- (void)nextAction
{
    WelcomeController *welcomeVC = [[WelcomeController alloc] init];
    [self.navigationController pushViewController:welcomeVC animated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGenderPickerView
{
    NSArray *arr = @[@"Male",@"Female"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:arr andHeadTitle:@"Choose gender" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        _genderLabel.text = choiceString;
        [pickerView dismissPicker];
    }];
    [pickerView show];
}

- (void)skipAction
{
    RootViewController *rootVC = [[RootViewController alloc] init];
    [self.navigationController pushViewController:rootVC animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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
