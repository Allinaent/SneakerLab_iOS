//
//  GShippingCartViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GShippingCartViewController.h"
#import "ShippingCartCell1.h"
#import "ShippingCartCell2.h"
#import "GEditAddressViewController.h"
#import "GPlaceOrderViewController.h"
#import "NSAttributedString+CommonSets.h"
#import "GProductDetailViewController.h"
#import "GEditCardViewController.h"

@interface GShippingCartViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) NSDictionary *all;
@property (nonatomic, strong) NSArray *cart;
@property (nonatomic, strong) NSArray *cartback;
@end

//bottom
@interface GShippingCartViewController ()
@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) UILabel *save;
@end

@implementation GShippingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.title = @"Shopping Cart";
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64- 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.tableFooterView = foot;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.allowsSelection = YES;
    self.tableview.backgroundColor = COLOR_FA;
    [self.tableview registerClass:[ShippingCartCell1 class] forCellReuseIdentifier:@"cell1"];
    [self.tableview registerClass:[ShippingCartCell2 class] forCellReuseIdentifier:@"cell2"];
    
    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    self.bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottom];
    UIButton *checkout = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-110.5, 0, 110.5, 49)];
    checkout.backgroundColor = COLOR_RED;
    [checkout setTitle:@"Checkout" forState:UIControlStateNormal];
    checkout.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    _total = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-110.5-15-150, 6, 150, 17.5)];
    _total.font = FONT_15;
    _total.textColor = COLOR_RED;
    _total.textAlignment = 2;
    
    _save = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-110.5-15-150, 24.5, 150, 17.5)];
    _save.font = FONT_12;
    _save.textColor = COLOR_9;
    _save.textAlignment = 2;
    [_bottom addSubview:checkout];
    [_bottom addSubview:_total];
    [_bottom addSubview:_save];
    
    [checkout addTarget:self action:@selector(checkoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self requestdatas];
    __weak typeof(self) weakSelf = self;
    self.reloadBlock = ^ {
        [weakSelf requestdatas];
    };
}

- (void)requestdatas {
    [PHPNetwork PHPNetworkWithParam:nil andUrl:SHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        self.all = [responseObject valueForKey:@"data"];
        self.cart = [_all valueForKey:@"cart"];
        self.cartback = [_all valueForKey:@"cartback"];
        [self.tableview reloadData];
        double total=0;
        double save=0;
        for (NSDictionary *dic in self.cart) {
            total = total + ([[dic valueForKey:@"special_price"] doubleValue] * [[dic valueForKey:@"quantity"] intValue]);
            save = save + ([[dic valueForKey:@"original_price"] doubleValue] - [[dic valueForKey:@"special_price"] doubleValue])* [[dic valueForKey:@"quantity"] intValue];
        }
        _total.text = [NSString stringWithFormat:@"Total:$%.2f", total];
        _save.text = [NSString stringWithFormat:@"Cost saving:$%.2f", save];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    //测试用例
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [manager POST:SHOPPINGCART_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DebugLog(@"%@", dic);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DebugLog(@"%@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 55)];
    sectionview.backgroundColor = COLOR_FA;
    if (section==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, SCREEN_W-60, 40)];
        label.numberOfLines = 0;
        label.font = FONT_12;
        label.textColor = [UIColor colorWithHexString:@"#FF8922"];
        label.text = @"You should checkout items you left in your shopping cart quickly and these gonna sold out !";
        label.textAlignment = 0;
        [sectionview addSubview:label];
    }else if (section==1){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 22, SCREEN_W-30, 0.5)];
        line.backgroundColor = COLOR_9;
        [sectionview addSubview:line];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-150)/2, 15, 150, 18)];
        label.font = FONT_15;
        label.textColor = COLOR_9;
        label.text = @"later for shopping";
        label.textAlignment = 1;
        label.backgroundColor = COLOR_FA;
        [sectionview addSubview:label];
    }
    
    return sectionview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (_cart.count==0) {
            return 1;
            
        }
        return _cart.count;
    }else if (section==1){
        return _cartback.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果section 0的行数为0，section 3 height为0，section 0覆盖view
    if (_cart.count==0&&indexPath.section==0) {
        return 352;
    }
    return 195;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        if (_cart.count==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 352)];
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-70.5)/2, 127.5, 70.5, 52)];
            imageview.image = [UIImage imageNamed:@"shopping-空"];
            imageview.contentMode = UIViewContentModeCenter;
            [cell addSubview:imageview];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 184.5, SCREEN_W-40, 15.5)];
            label.textAlignment = 1;
            label.text = @"Your cart is empty Go pick some cool goods";
            label.font = FONT_13;
            label.textColor = COLOR_9;
            [cell addSubview:label];
            cell.userInteractionEnabled = NO;
            return cell;
        }
        ShippingCartCell1 *cell = [ShippingCartCell1 cellWithTableView:tableView];
        NSDictionary *item = _cart[indexPath.row];
        cell.head = [item valueForKey:@"image"];
        cell.name = [item valueForKey:@"name"];
        cell.cart_id = [item valueForKey:@"cart_id"];
        cell.product_id = [item valueForKey:@"product_id"];
        cell.colorL.hidden = YES;
        cell.sizeL.hidden = YES;
        cell.minimum = [[item valueForKey:@"minimum"] integerValue];
        NSArray *options = [item valueForKey:@"option"];
        for (NSDictionary *dic in options) {
            if ([[dic valueForKey:@"name"] isEqualToString:@"color"]) {
                cell.color = [dic valueForKey:@"name"];
                if ([[dic valueForKey:@"name"] isEqual:[NSNull null]]) {
                    cell.colorL.hidden = YES;
                }
                cell.colorL.hidden = NO;
            }
            if ([[dic valueForKey:@"name"] isEqualToString:@"size"]) {
                cell.size = [dic valueForKey:@"value"];
                if ([[dic valueForKey:@"size"] isEqual:[NSNull null]]) {
                    cell.sizeL.hidden = YES;
                }
                cell.sizeL.hidden = NO;
            }
        }
        cell.lowprice = [NSString stringWithFormat:@"$%@", [item valueForKey:@"special_price"]];
        cell.highprice = [NSString stringWithFormat:@"$%@", [item valueForKey:@"original_price"]];
        cell.num = [item valueForKey:@"quantity"];
        return cell;
    }else{
        ShippingCartCell2 *cell = [ShippingCartCell2 cellWithTableView:tableView];
        NSDictionary *item = _cartback[indexPath.row];
        cell.head = [item valueForKey:@"image"];
        cell.name = [item valueForKey:@"name"];
        cell.cart_id = [item valueForKey:@"cart_back_id"];
        cell.product_id = [item valueForKey:@"product_id"];
        cell.colorL.hidden = YES;
        cell.sizeL.hidden = YES;
        NSArray *options = [item valueForKey:@"option"];
        for (NSDictionary *dic in options) {
            if ([[dic valueForKey:@"name"] isEqualToString:@"color"]) {
                cell.color = [dic valueForKey:@"value"];
                if ([[dic valueForKey:@"name"] isEqual:[NSNull null]]) {
                    cell.colorL.hidden = YES;
                }
                cell.colorL.hidden = NO;
            }
            if ([[dic valueForKey:@"name"] isEqualToString:@"size"]) {
                cell.size = [dic valueForKey:@"value"];
                if ([[dic valueForKey:@"size"] isEqual:[NSNull null]]) {
                    cell.sizeL.hidden = YES;
                }
                cell.sizeL.hidden = NO;
            }
        }
        cell.lowprice = [NSString stringWithFormat:@"$%@", [item valueForKey:@"special_price"]];
        cell.highprice = [NSString stringWithFormat:@"$%@", [item valueForKey:@"original_price"]];
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 55;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)checkoutAction {
    /*
    [PHPNetwork PHPNetworkWithParam:nil andUrl:CHECKOUT_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        //跳转到Edit Shipping info
        GEditAddressViewController *vc = [[GEditAddressViewController alloc] init];
        vc.next = YES;
        vc.add = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [manager POST:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DebugLog(@"%@", dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
     */
    if (_cart.count==0) {
        [MBManager showBriefAlert:@"Please pick out some goods first"];
        return;
    }
    [MBManager showLoading];
    [PHPNetwork PHPNetworkWithUrl:CHECKOUT_URL finish:^(NSURLSessionDataTask *task, id responseObject) {
        [MBManager hideAlert];
        NSDictionary *result = [NSDictionary dictionaryWithJsonString:responseObject];
        NSDictionary *dict = [result valueForKey:@"data"];
        NSDictionary *dic = [dict valueForKey:@"payment"];
        
        NSNumber *type = [dic valueForKey:@"type"];
        //if (![dic isEqual:[NSNull null]]||[[NSUserDefaults standardUserDefaults] boolForKey:UD_PAY]==YES) {//调试时改为NO
        if (!([type integerValue] == 0)) {
            GPlaceOrderViewController *vc = [[GPlaceOrderViewController alloc] init];
            vc.from = MENU;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[dic valueForKey:@"address"] isEqual:[NSNull null]]) {
            GEditAddressViewController *vc = [[GEditAddressViewController alloc] init];
            vc.next = YES;
            vc.add = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[dict valueForKey:@"payment"] isEqual:[NSNull null]]) {
            GEditCardViewController *vc = [[GEditCardViewController alloc] init];
            vc.next = YES;
            vc.add = YES;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_PAY];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type integerValue] == 0) {
            GEditAddressViewController *vc = [[GEditAddressViewController alloc] init];
            vc.next = YES;
            vc.add = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager hideAlert];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        ShippingCartCell1 *cell = (ShippingCartCell1 *)[tableView cellForRowAtIndexPath:indexPath];
        GProductDetailViewController *detailVC = [[GProductDetailViewController alloc] init];
        if (cell.product_id!=nil) {
            detailVC.productID = cell.product_id;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ShippingCartCell2 *cell = (ShippingCartCell2 *)[tableView cellForRowAtIndexPath:indexPath];
        GProductDetailViewController *detailVC = [[GProductDetailViewController alloc] init];
        detailVC.productID = cell.product_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSDictionary *)all {
    if (!_all) {
        _all = [NSDictionary dictionary];
    }
    return _all;
}

- (NSArray *)cart {
    if (!_cart) {
        _cart = [NSArray array];
    }
    return _cart;
}

- (NSArray *)cartback {
    if (!_cartback) {
        _cartback = [NSArray array];
    }
    return _cartback;
}

@end
