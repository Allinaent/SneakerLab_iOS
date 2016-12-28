//
//  OrderViewController.m
//  SneakerLab
//
//  Created by edz on 2016/10/31.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderViewController.h"
#import "UIView+YZTCView.h"
#import "Tatals.h"
#import "ProductCell.h"
#import "OrderHistoryViewController.h"
@interface OrderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>
{

  Tatals *_talModel;
 UICollectionView *_collectionView;
NSMutableArray *_dataSource;

}

@property(nonatomic,strong)UILabel *OrderLabel;

@property(nonatomic,strong)UILabel *summary;
@property(nonatomic,strong)UILabel *itemtatal;
@property(nonatomic,strong)UILabel *Shipping;
@property(nonatomic,strong)UILabel *ordertatal;

@property(nonatomic,strong)NSMutableArray *tatalSource;
@property(nonatomic,strong)UILabel *subtotal;
@property(nonatomic,strong)UILabel *Total;
@property(nonatomic,strong)UILabel *Shiping;
@property(nonatomic,strong)UIButton*viewOrders;
@property(nonatomic,strong)UIButton*Shoping;
@property(nonatomic,strong)UIButton*RELATED;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if PREDUPLICATE==0
    self.title = @"FOUNDED SOLE";
#elif PREDUPLICATE==1
    self.title = @"IVANKA JINGLE";
#elif PREDUPLICATE==5
    self.title = @"SNEAKER CRUNCH";
#elif PREDUPLICATE==6
    self.title = @"STYL";
#endif
    _tatalSource = [[NSMutableArray alloc]init];
    [self creatUI];
    
    [self LoadData];
    
    
    
    
}
-(void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _OrderLabel = [FactoryUI createLabelWithFrame:CGRectMake(140, 19.5, 98.5, 18) text:@"Order Placed!" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:15.0f]];
    _OrderLabel.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:_OrderLabel];
    _summary = [FactoryUI createLabelWithFrame:CGRectMake(15, 77, 70, 16) text:@"Summary" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_summary];
    _itemtatal = [FactoryUI createLabelWithFrame:CGRectMake(23, 114,70 , 16) text:@"item Total"textColor:[UIColor colorWithHexString:@"#999999"]  font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_itemtatal];
    
    _Shipping = [FactoryUI createLabelWithFrame:CGRectMake(23,_itemtatal.yzBottom +18 ,65 , 16) text:@"Shipping" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_Shipping];
    _OrderLabel = [FactoryUI createLabelWithFrame:CGRectMake(23, _Shipping.yzBottom +18, 75, 16) text:@"Order Total" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:_OrderLabel];
    _viewOrders = [FactoryUI createButtonWithFrame:CGRectMake(15, _OrderLabel.yzBottom + 25 ,160, 40) title:@"View Orders" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(viewOrdrs1)];
    _viewOrders.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [self.view addSubview:_viewOrders];
    _Shoping = [FactoryUI createButtonWithFrame:CGRectMake(200, 218, 200, 40) title:@"Continue Shopping" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:@"Rectangle 3 Copy" target:self selector:@selector(continueShop)];
    [self.view addSubview:_Shoping];
    _RELATED = [FactoryUI createButtonWithFrame:CGRectMake(0, _viewOrders.yzBottom + 22.7, SCREEN_W, 44.5) title:@"RELATED" titleColor:[UIColor colorWithHexString:@"#999999"] imageName:nil backgroundImageName:nil target:self selector:nil];
   
    _RELATED.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
     [self.view addSubview:_RELATED];
    [self createRatedView];
}
-(void)LoadData{
    {   if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]){
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
        
        [[CWAPIClient sharedClient] POSTRequest:SHOPPINGCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             
             NSLog(@"%@",responseObject);
             
             
             NSDictionary *dic = responseObject[@"data"];
             NSArray *total = dic[@"totals"];
             _talModel = [[Tatals alloc]init];
             NSDictionary *shiping = dic[@"shiping"];
             // NSDictionary *shipping = dic[@"shiping"];
             for (NSDictionary *dic in total) {
                 [_talModel setValuesForKeysWithDictionary:dic];
                 [_tatalSource addObject:_talModel];
             }
             [self createHeaderView:total ship:shiping];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             
         }];}
    else
    {
        // if (_shopDelegate && [_shopDelegate respondsToSelector:@selector(shoppingNotLogin)]) {
        //     [_shopDelegate shoppingNotLogin];
        //  }
    }
        
    }
}
- (void)createHeaderView: (NSArray *)array ship:(NSDictionary *)shiping{
    
    
    _subtotal = [FactoryUI createLabelWithFrame:CGRectMake(280, 114, 100, 20) text:array[0][@"text"] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _subtotal.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_subtotal];
    _Shiping = [FactoryUI createLabelWithFrame:CGRectMake(280, _subtotal.yzBottom +15, 100, 20) text:shiping[@"text"] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    _Shiping.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_Shiping];
    _Total = [FactoryUI createLabelWithFrame:CGRectMake(280, _subtotal.yzBottom + 48,100, 15.5) text:array[1][@"text"]  textColor:[UIColor colorWithHexString:@"#DE4536"] font:[UIFont systemFontOfSize:14]];
    _Total.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_Total];
    
 

}

- (void)createRatedView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 350, SCREEN_W, SCREEN_H) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册cell
    [_collectionView registerClass:[ProductCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    [self refreshUI];

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
    
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataSource)
    {
        ProductModel * model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W -20) / 2, 300);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    DetailController *detailVC = [[DetailController alloc] init];
//    OrderRatedModel *model = _dataSource[indexPath.row];
//    detailVC.productID = model.product_id;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}
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
         NSLog(@"%@",responseObject);
         
         NSArray *dataArr = responseObject[@"data"];
         NSLog(@"%@",dataArr);
         for (NSDictionary *dic in dataArr)
         {
             ProductModel *model = [[ProductModel alloc] init];
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
-(void)viewOrdrs1{
    
  OrderHistoryViewController  *orderhis = [[OrderHistoryViewController alloc]init];
    
 [[self navigationController]pushViewController:orderhis animated:YES];
    
    
    
    
}
-(void)continueShop{

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
