//
//  CollectionController.m
//  caowei
//
//  Created by Jason cao on 2016/9/27.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CollectionController.h"
#import "ProductCell.h"
#import "DetailController.h"
#import <MJRefresh.h>
#import "ProductDetailViewController.h"
#import "SettingsViewController.h"
#import "PersonalInfoViewController.h"
#import "UIImage+GSet.h"
#import <UIButton+WebCache.h>
#import "ShopViewController.h"
#import "OrderHistoryViewController.h"
#import "CollectController.h"
#import <UIView+WZLBadge.h>
#import "GPlaceOrderViewController.h"
#import "GShippingCartViewController.h"
#import "GProductDetailViewController.h"

static NSString *headerViewIdentifier = @"hederview";
@interface CollectionController ()<UICollectionViewDelegate , UICollectionViewDataSource, UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
{
    NSMutableArray *_dataSource;
    NSString *_productID;
    NSIndexPath *_path;
    UIImagePickerController *_imagePickerController;
}
@property (nonatomic , strong) UILabel *numLabel;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIButton *headerBtn;
@property (nonatomic , strong) UIView *myView;
@property (nonatomic , assign) NSUInteger page;
@property (nonatomic , strong) UIView *bottom;
@property (nonatomic , strong) UIImageView *contentLineImageView;
@end

@implementation CollectionController

- (void)editAction {
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setBottom {
    _bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H)];
    [self.navigationController.view addSubview:_bottom];
    _bottom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_H-185, SCREEN_W, 185)];
    view.backgroundColor = [UIColor whiteColor];
    [_bottom addSubview:view];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREEN_W-40, 20)];
    [view addSubview:title];
    title.font = [UIFont systemFontOfSize:17];
    title.text = @"Choose Avatar";
    title.textAlignment = 1;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_W, 0.5)];
    [view addSubview:line];
    line.backgroundColor = COLOR_9;
    UIButton *pic = [[UIButton alloc] initWithFrame:CGRectMake(100, 70, 50, 50)];
    [pic setBackgroundImage:[UIImage imageNamed:@"图片a"] forState:UIControlStateNormal];
    pic.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:pic];
    
    UIButton *camera = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-160, 73, 50, 44)];
    [view addSubview:camera];
    camera.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [camera setBackgroundImage:[UIImage imageNamed:@"相机a"] forState:UIControlStateNormal];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsEditing = YES;
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(15, 185 - 53.5, SCREEN_W-30, 43.5)];
    cancel.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [view addSubview:cancel];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel setTitleColor:COLOR_6 forState:UIControlStateNormal];
    [pic addTarget:self action:@selector(picAction) forControlEvents:UIControlEventTouchUpInside];
    [camera addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _headerBtn.selected = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_bottom addGestureRecognizer:tap];
}

- (void)picAction {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:^{
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Permission denied" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)cameraAction {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePickerController animated:YES completion:^{
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Permisson denied" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize size = CGSizeMake(60, 60);
    UIImage *sImage = [UIImage imageCompressForSize:image targetSize:size];
    NSData *imageData = UIImagePNGRepresentation(sImage);
    [PHPNetwork uploadImageWithImageData:imageData andUrl:MODIFYHEAD_URL progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } finish:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"status_code"] integerValue] == 0) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *avatar = [data valueForKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:UD_HEADURL];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.headerBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            [MBManager showBriefAlert:@"You have successfully modified customers!"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Something error"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SET_NAV_MIDDLE
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"MyLab";
    _contentLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self setBottom];
    UIBarButtonItem *editButton = [UIBarButtonItem itemWithImage:@"设置" highImage:nil target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#32303D"];
    UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W, 80) imageName:nil];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    _headerBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W/2-25.25, 6, 50.5, 50.5) title:nil titleColor:nil imageName:nil backgroundImageName:@"头像－抽屉" target:self selector:@selector(changeAvatar)];
    [_headerBtn setBackgroundImage:headImg forState:UIControlStateNormal];
    _headerBtn.layer.cornerRadius = _headerBtn.frame.size.height/2;
    _headerBtn.layer.masksToBounds = YES;
    [self.view addSubview:_headerBtn];
    UIImageView *camera = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headerBtn.frame)+19, CGRectGetMaxY(_headerBtn.frame)-15, 15, 15)];
    camera.image = [UIImage imageNamed:@"相机"];
    [self.view addSubview:camera];
    UILabel *nameLB = [[UILabel alloc] init];
    [self.view addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerBtn.bottom).with.offset(2.5);
        make.centerX.equalTo(self.view);
        make.height.equalTo(CGSizeMake(SCREEN_W, 26.5));
    }];
    nameLB.textColor = [UIColor whiteColor];
    nameLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];;
    nameLB.textAlignment = 1;
    UIButton *editBtn = [[UIButton alloc] init];
    [self.view addSubview:editBtn];
    [editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nameLB.bottom).with.offset(4.5);
        make.size.equalTo(CGSizeMake(50, 16));
    }];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"Edit info"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editInfoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *two = [[UIView alloc] init];
    [self.view addSubview:two];
    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(editBtn.bottom).with.offset(10);
        make.height.equalTo(101);
    }];
    two.backgroundColor = [UIColor whiteColor];
    UIButton *cart = [[UIButton alloc] init];
    [two addSubview:cart];
    [cart addTarget:self action:@selector(cartButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cart makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(47);
        make.top.equalTo(18.5);
        make.size.equalTo(CGSizeMake(48, 48));
    }];
    [cart setSelectedImageStr:@"mylab_shopping" andUnselectImageStr:@"mylab_hei_shopping"];
#pragma mark - 刷新小红点
    [PHPNetwork PHPNetworkWithParam:nil andUrl:SHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *all = [responseObject valueForKey:@"data"];
        NSArray *carts = [all valueForKey:@"cart"];
        NSArray *cartbacks = [all valueForKey:@"cartback"];
        [cart showBadgeWithStyle:WBadgeStyleNumber value:carts.count animationType:WBadgeAnimTypeNone];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    UIButton *history = [[UIButton alloc] init];
    [two addSubview:history];
    [history addTarget:self action:@selector(historyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [history makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(two);
        make.size.top.equalTo(cart);
    }];
    [history setSelectedImageStr:@"mylab_order" andUnselectImageStr:@"mylab_hei_order"];
    UIButton *wish = [[UIButton alloc] init];
    [two addSubview:wish];
    [wish addTarget:self action:@selector(wishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [wish makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-47);
        make.size.top.equalTo(cart);
    }];
    [wish setSelectedImageStr:@"mylab_wishlist" andUnselectImageStr:@"mylab_hei_wishlist"];
    UILabel *label1 = [[UILabel alloc] init];
    [two addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cart);
        make.top.equalTo(cart.bottom).with.offset(7);
    }];
    label1.text = @"Shopping Cart";
    label1.font = FONT_11;
    label1.textColor = COLOR_6;
    [label1 sizeToFit];
    
    UILabel *label2 = [[UILabel alloc] init];
    [two addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(history);
        make.top.equalTo(history.bottom).with.offset(7);
    }];
    label2.text = @"Order History";
    label2.font = FONT_11;
    label2.textColor = COLOR_6;
    [label2 sizeToFit];
    
    UILabel *label3 = [[UILabel alloc] init];
    [two addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wish);
        make.top.equalTo(wish.bottom).with.offset(7);
    }];
    label3.text = @"Wishlist";
    label3.font = FONT_11;
    label3.textColor = COLOR_6;
    [label3 sizeToFit];
    
    UIView *margin = [[UIView alloc] init];
    [self.view addSubview:margin];
    [margin makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(5);
        make.top.equalTo(two.bottom);
    }];
    margin.backgroundColor = COLOR_FA;
    UIView *three = [[UIView alloc] init];
    [self.view addSubview:three];
    [three makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(two.bottom).with.offset(5);
        make.bottom.equalTo(264.5);
    }];
    three.backgroundColor = [UIColor whiteColor];
    
    UILabel *may = [[UILabel alloc] init];
    [three addSubview:may];
    [may makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(three);
        make.top.equalTo(three).with.offset(12.5);
    }];
    may.text = @"Maybe you like";
    may.font = FONT_14;
    [may sizeToFit];
    UIView *line1 = [[UIView alloc] init];
    [three addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(may);
        make.left.equalTo(10);
        make.height.equalTo(1);
        make.right.equalTo(may.left).with.offset(-20);
    }];
    line1.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    UIView *line2 = [[UIView alloc] init];
    [three addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(may);
        make.right.equalTo(-10);
        make.height.equalTo(1);
        make.left.equalTo(may.right).with.offset(20);
    }];
    line2.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self createCollection];
    self.page = 1;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBottom];
     _contentLineImageView.hidden = YES;
    [PHPNetwork PHPNetworkWithParam:nil andUrl:PERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject valueForKey:@"status_code"] integerValue] == 0) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            for (NSString *key in data.allKeys) {
                if ([key isEqualToString:@"avatar"]) {
                    NSString *imageUrl = [data valueForKey:@"avatar"];
                    [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:headImg];
                }else{
                    
                }
            }
        }
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Error"];
    }];
    [self refreshUIwithPage:[NSString stringWithFormat:@"%lu", self.page]];
}

- (void)editInfoAction {
    PersonalInfoViewController *vc = [[PersonalInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---判断显示有无收藏的视图
- (void)showView
{
    if (_dataSource.count == 0)
    {
        UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80) imageName:@"箱包礼品"];
        UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, self.view.center.y + 40, SCREEN_W-40, 20) text:@"No Collection" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:20]];
        label.textAlignment = 1;
        [self.view addSubview:image];
        [self.view addSubview:label];
    }
}


#pragma mark -----创建collectionView
- (void)createCollection
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 264.5, SCREEN_W, SCREEN_H-264.5-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册cell
    [_collectionView registerClass:[ProductCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.backgroundColor = COLOR_FA;
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    _collectionView.mj_header = header;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshUIwithPage:@"1"];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_collectionView.mj_footer endRefreshing];
    }];
    [self.view addSubview:_collectionView];
}

#pragma mark -- 改变头像
#pragma mark ----collection协议
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
    cell.backgroundColor = [UIColor whiteColor];
    if (_dataSource.count != 0)
    {
        ProductModel *model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    _path = indexPath;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W -20) / 2, (SCREEN_W -20) / 2 + 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    GProductDetailViewController *detailVC = [[GProductDetailViewController alloc] init];
    ProductModel *model = _dataSource[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)refreshUIwithPage:(NSString *)page
{
    if (self.page == 1) {
        [_dataSource removeAllObjects];
    }
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
             ProductModel *model = [[ProductModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         self.numLabel.text = [NSString stringWithFormat:@"%lud",(unsigned long)self.dataSource.count];
         if (self.dataSource.count == 0) {
             [self showView];
         }
         [_collectionView reloadData];
         [_collectionView.mj_header endRefreshing];
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

#pragma mark ----长按手势
- (void)longClick:(UILongPressGestureRecognizer *)lpgr
{
    self.myView = [FactoryUI createViewWithFrame:CGRectMake(0, SCREEN_H - 60, SCREEN_W, 60)];
    self.myView.backgroundColor = [UIColor blackColor];
    UIButton *removeBtn = [FactoryUI createButtonWithFrame:CGRectMake(20, 10, SCREEN_W / 2 - 40, 40) title:@"Remove" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(removeAction)];
    UIButton *cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W / 2 + 20, 10, SCREEN_W / 2 - 40, 40) title:@"Cancel" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(cancelAction)];
    [self.myView addSubview:removeBtn];
    [self.myView addSubview:cancelBtn];
    [self.view addSubview:self.myView];
    _collectionView.allowsMultipleSelection = YES;
}

- (void)removeAction
{
    [self.collectionView performBatchUpdates:^{
        [self.dataSource removeObjectAtIndex:_path.item];
        [self.collectionView deleteItemsAtIndexPaths:@[_path]];
    } completion:^(BOOL finished) {
        
        [self.collectionView reloadData];
    }];
}

- (void)cancelAction
{
    [self.myView removeFromSuperview];
    _collectionView.allowsMultipleSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)changeAvatar {
    [self.navigationController.view bringSubviewToFront:_bottom];
    if (_headerBtn.selected==NO) {
        [UIView animateWithDuration:0.35 animations:^{
            _bottom.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        }];
    }else{
        [UIView animateWithDuration:0.35 animations:^{
            _bottom.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
        }];
    }
    _headerBtn.selected = !_headerBtn.selected;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _contentLineImageView.hidden = NO;
    [_bottom removeFromSuperview];
}

- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        _bottom.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    }];
    _headerBtn.selected = NO;
}

- (void)cartButtonAction {
    //ShopViewController *shopVC = [[ShopViewController alloc]init];
    GShippingCartViewController *shopVC = [[GShippingCartViewController alloc] init];
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)historyButtonAction {
    OrderHistoryViewController *orderVC = [[OrderHistoryViewController alloc] init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)wishButtonAction {
    CollectController *collect = [[CollectController alloc]init];
    [self.navigationController pushViewController:collect animated:YES];
}

@end
