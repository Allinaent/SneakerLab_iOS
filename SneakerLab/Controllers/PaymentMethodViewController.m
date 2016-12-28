//
//  PaymentMethodViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "EditCardTableViewCell.h"
#import "PayPalViewController.h"
#import "GEditCardViewController.h"

@interface PaymentMethodViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *paypal;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *footer;

@property (nonatomic, strong) NSArray *all;
@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Payment Method";
    self.view.backgroundColor = COLOR_FA;
    
    UIButton *method = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_W, 50)];
    method.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:method];
    [method addTarget:self action:@selector(methodAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *other = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 180, 16.5)];
    other.textColor = COLOR_9;
    other.font = FONT_14;
    other.text = @"The other payment method";
    [method addSubview:other];
    _paypal = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-36-43.5, 17, 43.5, 16.5)];
    _paypal.textColor = COLOR_3;
    _paypal.font = FONT_14;
    _paypal.text = @"PayPal";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UD_PAY]==NO) {
        _paypal.hidden = YES;
    }else{
        _paypal.hidden = NO;
    }
    [method addSubview:_paypal];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-10.5-15, 16, 10.5, 17.5)];
    [method addSubview:right];
    right.image = [UIImage imageNamed:@"向右箭头"];
    right.contentMode = UIViewContentModeCenter;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.allowsMultipleSelection = NO;
    [self.tableview registerClass:[EditCardTableViewCell class] forCellReuseIdentifier:@"cell"];
    _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    _footer.backgroundColor = [UIColor whiteColor];
    UIView *division = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    division.backgroundColor = COLOR_FA;
    [_footer addSubview:division];
    [_footer addSubview:method];
    self.tableview.tableFooterView = _footer;
    self.tableview.backgroundColor = COLOR_FA;
    [self.view addSubview:_tableview];
    
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    add.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    add.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    add.titleLabel.textColor = [UIColor whiteColor];
    add.titleLabel.text = @"+Add your card";
    [add setTitle:@"+Add your card" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestdatas];
}

- (void)requestdatas {
    [PHPNetwork PHPNetworkWithParam:nil andUrl:CARDLIST_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        _all = [responseObject valueForKey:@"data"];
        [self.tableview reloadData];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _all.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCardTableViewCell *cell = [EditCardTableViewCell cellWithTableView:tableView];
    NSDictionary *dict = _all[indexPath.row];
    cell.card_number = [dict valueForKey:@"card_number"];
    cell.card_year = [dict valueForKey:@"card_year"];
    cell.card_month = [dict valueForKey:@"card_month"];
    cell.credit_id = [dict valueForKey:@"credit_id"];
    cell.card_cvv = [dict valueForKey:@"card_cvv"];
    cell.is_default = [dict valueForKey:@"is_default"];
    cell.zip_code = [dict valueForKey:@"zip_code"];
    if ([cell.credit_id isEqualToString:self.card_id]&&[[[NSUserDefaults standardUserDefaults] valueForKey:@"payway"] boolValue]==NO) {
        [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

//需要防抖动，可以先不做
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCardTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = @{@"credit_id":cell.credit_id,@"card_number":cell.card_number,@"card_month":cell.card_month,@"card_year":cell.card_year,@"card_cvv":cell.card_cvv,@"zip_code":cell.zip_code,@"set_default":@"1"};
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_PAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //修改后端type
    [PHPNetwork PHPNetworkWithParam:dict andUrl:EDITCREDitCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"payway"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self changePaymentMethod:@"2"];
        [self.navigationController popViewControllerAnimated:YES];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    cell.selected = YES;
}

#pragma mark - 修改支付方式
- (void)changePaymentMethod:(NSString *)method {
    NSDictionary *dict = @{@"payment":method};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:SETPAYMENT_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)methodAction {
    PayPalViewController *vc = [[PayPalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addButtonAction {
    GEditCardViewController *vc = [[GEditCardViewController alloc] init];
    vc.add = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSArray *)all {
    if (!_all) {
        _all = [NSArray array];
    }
    return _all;
}

@end
