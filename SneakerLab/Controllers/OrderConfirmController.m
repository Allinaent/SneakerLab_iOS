//
//  OrderConfirmController.m
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderConfirmController.h"
#import "RootViewController.h"
#import "OrderRatedCell.h"
#import "OrderRatedModel.h"
#import "DetailController.h"
@interface OrderConfirmController ()<UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataSource;
    UILabel *_priceLabel1;
    UILabel *_priceLabel2;
    UILabel *_priceLabel3;
}
@end

@implementation OrderConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"YEEZY";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self createUI];
    //[self reloadData];
    [self refreshUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(0, 15, SCREEN_W, 30) text:@"Order Confirmed!" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15]];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(85, 85, 110, 20) text:@"Powered by " textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UILabel *label3 = [FactoryUI createLabelWithFrame:CGRectMake(15, 85, 70, 20) text:@"Summary" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label3];
    
    UILabel *borderLabel = [FactoryUI createLabelWithFrame:CGRectMake(15, 115, SCREEN_W - 30, 100) text:nil textColor:nil font:nil];
    borderLabel.layer.borderWidth = 0.5;
    borderLabel.layer.borderColor = [UIColor colorWithHexString:@"#e0dfdf"].CGColor;
    [self.view addSubview:borderLabel];
    
    UILabel *label4 = [FactoryUI createLabelWithFrame:CGRectMake(22.5, 125.5, 80, 16.5) text:@"Item Total" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label4];
    
    UILabel *label5 = [FactoryUI createLabelWithFrame:CGRectMake(22.5, 156.5, 80, 16.5) text:@"Shippng" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label5];
    
    UILabel *label6 = [FactoryUI createLabelWithFrame:CGRectMake(22.5, 187.5, 80, 16.5) text:@"Order Total" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label6];
    
    _priceLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W - 105, 125.5, 80, 16.5) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_priceLabel1];
    
    _priceLabel2 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W - 105, 156.5, 80, 16.5) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_priceLabel2];
    
    _priceLabel3 = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W - 105, 187.5, 80, 16.5) text:nil textColor:[UIColor colorWithHexString:@"#de4536"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_priceLabel3];
    
    UIButton *viewOrderBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 240, SCREEN_W / 2 - 30, 40) title:@"View Orders" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(viewOrder)];
    viewOrderBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    viewOrderBtn.layer.cornerRadius = 3;
    viewOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:viewOrderBtn];
    
    UIButton *continueShoppingBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W / 2 + 15, 240, SCREEN_W / 2 - 30, 40) title:@"Continue Shopping" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(shopping)];
    continueShoppingBtn.backgroundColor = [UIColor colorWithHexString:@"#e7e7e7"];
    continueShoppingBtn.layer.cornerRadius = 3;
    continueShoppingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:continueShoppingBtn];
    
    UILabel *rateLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 307.5, SCREEN_W, 44.5) text:@"RATED" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont boldSystemFontOfSize:15]];
    rateLabel.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rateLabel];
    
    [self createRatedView];
}

- (void)createRatedView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 352, SCREEN_W, SCREEN_H - 332) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册cell
    [_collectionView registerClass:[OrderRatedCell class] forCellWithReuseIdentifier:@"OrderRatedCell"];

     [self.view addSubview:_collectionView];
}

#pragma mark -- collectionView协议 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderRatedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderRatedCell" forIndexPath:indexPath];
    if (_dataSource)
    {
        OrderRatedModel * model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_W/2 - 30, SCREEN_W/2 - 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DetailController *detailVC = [[DetailController alloc] init];
    OrderRatedModel *model = _dataSource[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshUI
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"page",@"equipment_id",@"limit"];
    NSDictionary *dic = @{@"page" : @"1",
                          @"limit" : @"10",
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time
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
    
    [[CWAPIClient sharedClient] POSTRequest:RATEPRODUCT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSArray *dataArr = responseObject[@"data"];
         for (NSDictionary *dic in dataArr)
         {
             OrderRatedModel *model = [[OrderRatedModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         [_collectionView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)reloadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"])
    {
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"token",@"equipment_id"];
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"token" : CWTOKEN,
                              @"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time
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
        
        [[CWAPIClient sharedClient] POSTRequest:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             
             NSDictionary *dic = responseObject[@"data"];
             NSArray *arr = dic[@"totals"];
             _priceLabel1.text = arr[0][@"text"];
             _priceLabel3.text = arr[1][@"text"];
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
    else
    {
        LoginController *vc = [[LoginController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)viewOrder
{
    
}

- (void)shopping
{
    RootViewController *rootVC = [[RootViewController alloc] init];
    [self.navigationController pushViewController:rootVC animated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
