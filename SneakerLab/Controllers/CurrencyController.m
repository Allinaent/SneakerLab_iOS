//
//  CurrencyController.m
//  caowei
//
//  Created by Jason cao on 16/9/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CurrencyController.h"
#import "MyPickView.h"
@interface CurrencyController ()
{
    UIButton *_confirmBtn;
}
@property (nonatomic , strong) UILabel *showLabel;
@end

@implementation CurrencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Currency Setting";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, self.view.frame.size.width - 20, 16.5)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.text = @"Please selected your prefered currency below";
    
    _showLabel = [[UILabel alloc] init];
    _showLabel.frame = CGRectMake(10, 61, self.view.frame.size.width - 20, 40);
    _showLabel.layer.borderWidth = 0.5;
    _showLabel.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.userInteractionEnabled = YES;
    _showLabel.font = [UIFont systemFontOfSize:13];
    [_showLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLabelText:)]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉@3x"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(self.view.frame.size.width - 40, 72.5, 15, 15);
    imageView.userInteractionEnabled = NO;
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(10, 122.5, self.view.frame.size.width - 20, 40);
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmBtn setTitle:@"Change Currency" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(changeCurrency) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    [self.view addSubview:imageView];
    [self.view addSubview:_showLabel];
    [self.view addSubview:titleLabel];
}

- (void)changeCurrency
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLabelText:(UITapGestureRecognizer *)tap
{
    NSArray *arr = @[@"USD",@"RMB",@"EOU",@"JAN"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:arr andHeadTitle:@" " Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        _showLabel.text = choiceString;
        if (_showLabel.text == nil)
        {
            _confirmBtn.enabled = NO;
            _confirmBtn.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            _confirmBtn.enabled = YES;
            _confirmBtn.backgroundColor = [UIColor colorWithRed:1.000 green:0.231 blue:0.194 alpha:1.000];
        }
        [pickerView dismissPicker];
    }];
    [pickerView show];
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
