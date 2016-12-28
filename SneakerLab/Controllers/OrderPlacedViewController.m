//
//  OrderPlacedViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/25.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderPlacedViewController.h"
#import "ProductModel.h"
#import "ProductDetailViewController.h"
#import "OrderHistoryViewController.h"
@interface OrderPlacedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) UICollectionReusableView *header;
@property (nonatomic, strong) NSMutableArray <ProductModel *> *productArray;

@end

@implementation OrderPlacedViewController

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
#if PREDUPLICATE==0
    self.title = @"FOUNDED SOLE";
#elif PREDUPLICATE==1
    self.title = @"IVANKA JINGLE";
#elif PREDUPLICATE==5
    self.title = @"SNEAKER CRUNCH";
#elif PREDUPLICATE==6
    self.title = @"STYL";
#endif
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置滚动的方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置尺寸
    CGSize size = [UIScreen mainScreen].bounds.size;
    flowLayout.itemSize = size;
    // 设置cell之间的间距
    flowLayout.minimumInteritemSpacing = 15;
    // 设置行距
    flowLayout.minimumLineSpacing = 10;
    flowLayout.footerReferenceSize = CGSizeMake(size.width, 0);
    flowLayout.headerReferenceSize = CGSizeMake(size.width, 330);
    _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) collectionViewLayout:flowLayout];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionview.pagingEnabled = NO;
    _collectionview.backgroundColor = [UIColor whiteColor];
    // 是否有边距
    // self.collectionView.bounces = NO;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.view addSubview:self.collectionview];
    [self getData];
}

- (void)getData {
    NSDictionary *dic = @{@"page":@"1",@"limit":@"10"};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:RATEPRODUCT_URL andSignature:YES andLogin:NO finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in data) {
            ProductModel *model = [[ProductModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.productArray addObject:model];
        }
        [_collectionview reloadData];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productArray.count;
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = _header;
        [self setHeader];
    }
    reusableView.backgroundColor = [UIColor whiteColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor purpleColor];
        reusableView = footerview;
    }
    return reusableView;
}

- (void)setHeader {
    UILabel *order = [[UILabel alloc] init];
    [_header addSubview:order];
    [order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(19.5);
        make.left.equalTo(20);
        make.right.equalTo(-20);
    }];
    order.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    order.text = @"Order Placed!";
    order.textAlignment = 1;
    UILabel *summary = [[UILabel alloc] init];
    [_header addSubview:summary];
    [summary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(77.5);
        make.size.equalTo(CGSizeMake(60, 16.5));
    }];
    summary.text = @"Summary";
    summary.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    summary.textColor = COLOR_3;
    UIView *view = [[UIView alloc] init];
    [_header addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(104);
        make.height.equalTo(99.5);
    }];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithHexString:@"#E0DFDF"] CGColor];
    UILabel *item = [[UILabel alloc] init];
    [view addSubview:item];
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(7.5);
        make.top.equalTo(view).with.offset(10.5);
        make.size.equalTo(CGSizeMake(100, 16.5));
    }];
    item.textAlignment = 0;
    item.textColor = COLOR_9;
    item.text = @"Item Total";
    item.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UILabel *shipping = [[UILabel alloc] init];
    [view addSubview:shipping];
    [shipping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(7.5);
        make.top.equalTo(item.bottom).with.offset(14.5);
        make.size.equalTo(CGSizeMake(100, 16.5));
    }];
    shipping.textAlignment = 0;
    shipping.text = @"Shipping";
    shipping.textColor = COLOR_9;
    shipping.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UILabel *total = [[UILabel alloc] init];
    [view addSubview:total];
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(7.5);
        make.top.equalTo(shipping.bottom).with.offset(14.5);
        make.size.equalTo(CGSizeMake(100, 16.5));
    }];
    total.textAlignment = 0;
    total.text = @"Order Total";
    total.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UILabel *value1 = [[UILabel alloc] init];
    [view addSubview:value1];
    [value1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(item);
        make.right.equalTo(view.right).with.offset(-7.5);
        make.size.equalTo(CGSizeMake(150, 15.5));
    }];
    value1.textColor = COLOR_9;
    value1.textAlignment = 2;
    value1.text = self.value1;
    value1.font = FONT_13;
    UILabel *value2 = [[UILabel alloc] init];
    [view addSubview:value2];
    [value2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shipping);
        make.right.equalTo(view.right).with.offset(-7.5);
        make.size.equalTo(CGSizeMake(150, 15.5));
    }];
    value2.textColor = COLOR_9;
    value2.textAlignment = 2;
    value2.text = self.value2;
    value2.font = FONT_13;
    UILabel *value3 = [[UILabel alloc] init];
    [view addSubview:value3];
    [value3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(total);
        make.right.equalTo(view.right).with.offset(-7.5);
        make.size.equalTo(CGSizeMake(150, 15.5));
    }];
    value3.textColor = [UIColor colorWithHexString:@"#DE4536"];
    value3.textAlignment = 2;
    value3.text = self.value3;
    
    UIButton *vieworders = [[UIButton alloc] init];
    [_header addSubview:vieworders];
    [vieworders mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15);
        make.top.equalTo(view.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(160, 40));
    }];
    vieworders.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [vieworders setTitle:@"View Orders" forState:UIControlStateNormal];
    [vieworders setTitleColor:COLOR_6 forState:UIControlStateNormal];
    vieworders.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    vieworders.layer.cornerRadius = 4;
    vieworders.layer.masksToBounds = YES;
    
    UIButton *go = [[UIButton alloc] init];
    [_header addSubview:go];
    [go mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-15);
        make.top.equalTo(view.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(160, 40));
    }];
    go.layer.cornerRadius = 4;
    go.layer.masksToBounds = YES;
    [go setTitle:@"Continue Shopping" forState:UIControlStateNormal];
    [go setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    go.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    go.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    UILabel *related = [[UILabel alloc] init];
    [_header addSubview:related];
    [related mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(_header.bottom);
        make.height.equalTo(44.5);
    }];
    related.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    related.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
    related.textColor = COLOR_9;
    related.text = @"RELATED";
    related.textAlignment = 1;
    
    [vieworders addTarget:self action:@selector(viewordersAction) forControlEvents:UIControlEventTouchUpInside];
    [go addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewordersAction {
    OrderHistoryViewController *vc = [[OrderHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160.0f, 160.0f);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [[UIColor colorWithHexString:@"#E5E5E5"] CGColor];
    for (id view in cell.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, 159, 159)];
    [cell addSubview:image];
    [image setPHPImageUrl:self.productArray[indexPath.row].image];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inset = UIEdgeInsetsMake(15, 15, 15, 15);
    return inset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    ProductModel *model = self.productArray[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
