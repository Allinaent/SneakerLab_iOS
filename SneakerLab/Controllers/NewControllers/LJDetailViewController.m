//
//  LJDetailViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "LJDetailViewController.h"
#import <SDCycleScrollView.h>

typedef enum _SCROLLTAG {
    MAINSCROLLVIEWTAG  = 100,
    BANNERTAG
}SCROLLTAG;


@interface LJDetailViewController ()<UIScrollViewDelegate>
/**
 baseViews
 */
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *mainContentView;
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@property (strong, nonatomic) UIView *btView;
@property (strong, nonatomic) UIView *infoView;
/**
 networkDatas
 */
@property (strong, nonatomic) NSString *originalPrice;
@property (strong, nonatomic) NSString *specialPrice;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *discount;
@property (strong, nonatomic) NSString *saleVolume;


@end

@implementation LJDetailViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DETAIL";
    self.view.backgroundColor = [UIColor whiteColor];
    [self LJDetailViewNetwork];
}

#pragma mark - 网络请求
- (void)LJDetailViewNetwork {
    NSDictionary *dic = @{@"product_id":self.productID};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:PRODUCTDETAIL_URL andSignature:YES andLogin:NO finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        self.bannerScrollView.imageURLStringsGroup = [dataDic objectForKey:@"images"];
        self.originalPrice = [dataDic valueForKey:@"original_price"];
        self.specialPrice = [dataDic valueForKey:@"special_price"];
        self.productName = [dataDic valueForKey:@"name"];
        self.discount = [dataDic valueForKey:@"discount"];
        self.saleVolume = [dataDic valueForKey:@"sales_volume"];
#pragma makr - 创建UI
        [self creatViews];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        LJLog(@"!!!%@", error);
    }];
}

#pragma mark - 视图
- (void)creatViews {
    //分为四个部分
    [self setUpBaseView];
    
    [self createDescriptionView];
}

- (void)setUpBaseView {
    
    [self.view addSubview:self.bannerScrollView];
    _bannerScrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W);
    self.bannerScrollView.autoScroll = NO;
    self.bannerScrollView.currentPageDotColor = COLOR_8;
    _bannerScrollView.pageDotColor = COLOR_D8;
    
    self.mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.mainScrollView];
    
    _mainScrollView.frame = CGRectMake(0, SCREEN_W, SCREEN_W, SCREEN_H - SCREEN_W - 64 - 49 -1 - 1);
    _mainScrollView.backgroundColor = [UIColor grayColor];
    self.mainScrollView.showsVerticalScrollIndicator = YES;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_W, 1200);
    _mainContentView = [[UIView alloc] init];
    _mainContentView.frame = CGRectMake(0, 0, SCREEN_W, 1200);
    _mainContentView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:_mainContentView];
    
    UIView *blueView = [[UIView alloc] init];
    blueView.frame = CGRectMake(0, 0, SCREEN_W, 400);
    [_mainContentView addSubview:blueView];
    blueView.backgroundColor = [UIColor blueColor];
    [self createBtView];
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 400)];
    [_mainContentView addSubview:self.infoView];
    _infoView.backgroundColor = [UIColor blueColor];
    UILabel *name = [[UILabel alloc] init];
    [blueView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView.mas_left).with.offset(20);
        make.right.equalTo(_infoView.mas_right).with.offset(-20);
        make.top.equalTo(_infoView.mas_top).with.offset(1);
    }];
    name.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    name.textColor = COLOR_3;
    name.text = _productName;
    
    UILabel *priceLB = [[UILabel alloc] init];
    [blueView addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).with.offset(12);
        make.left.equalTo(_infoView.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    priceLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    priceLB.textColor = [UIColor colorWithHexString:@"#DE4536"];
    
    priceLB.text = [NSString stringWithFormat:@"$%@", self.specialPrice];
    
    UILabel *oriPrice = [[UILabel alloc] init];
    [blueView addSubview:oriPrice];
    [oriPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.mas_right).with.offset(8);
        make.centerY.equalTo(priceLB.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",self.originalPrice]
                                    attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    oriPrice.attributedText = attrStr;
    
    UIView *sale = [[UIView alloc] init];
    [blueView addSubview:sale];
    [sale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oriPrice.mas_right).with.offset(7.5);
        make.centerY.equalTo(oriPrice.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(41, 18));
    }];
    sale.layer.borderWidth = 0.5;
    sale.layer.borderColor = COLOR_D.CGColor;
    sale.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    UILabel *saleLB = [[UILabel alloc] init];
    [sale addSubview:saleLB];
    [saleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(sale.center);
    }];
    saleLB.text = [NSString stringWithFormat:@"%@", self.discount];
    saleLB.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    saleLB.textColor = [UIColor colorWithHexString:@"#FFA057"];
    
    UILabel *bought = [[UILabel alloc] init];
    [_infoView addSubview:bought];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_infoView.mas_right).with.offset(-20);
        make.centerY.equalTo(saleLB.mas_centerY);
    }];
    bought.textColor = COLOR_9;
    bought.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    bought.text = [NSString stringWithFormat:@"%@ bought", self.saleVolume];
    
    LJCellLine *line1 = [[LJCellLine alloc] init];
    [_infoView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView.mas_left).with.offset(SCREEN_MARGIN);
        make.top.equalTo(priceLB.mas_bottom).with.offset(20);
    }];
    LJLog(@"%@", _infoView.description);
    [blueView setNeedsLayout];
    [blueView layoutIfNeeded];
}

- (void)createBtView {
    _btView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49 - 4.5 - 64, SCREEN_W, 49 + 4.5)];
    _btView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_btView];
    LJButton *heart = [[LJButton alloc] init];
    [_btView addSubview:heart];
    [heart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btView.mas_left).with.offset(17.5);
        make.top.equalTo(_btView.mas_top).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(22.5, 18.5));
    }];
    [heart setSelectedImageStr:@"保存填充" andUnselectImageStr:@"保存-拷贝"];
    [heart addTapBlock:^(UIButton *btn) {
        if (btn.selected)
        {
            btn.selected = NO;
        }
        else
        {
            btn.selected = YES;
        }
    }];
    UIView *span = [[UIView alloc] init];
    [_btView addSubview:span];
    [span mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heart.mas_right).with.offset(17);
        make.top.equalTo(_btView.mas_top).with.offset(8);
        make.bottom.equalTo(_btView.mas_bottom).with.offset(-11);
        make.width.mas_equalTo(1);
    }];
    span.backgroundColor = COLOR_D;
    
    UIImageView *tagSelf = [[UIImageView alloc] init];
    [_btView addSubview:tagSelf];
    [tagSelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(span.mas_right).with.offset(4.5);
        make.top.equalTo(_btView.mas_top);
        make.bottom.equalTo(_btView.mas_bottom);
        make.width.mas_equalTo(55);
    }];
    tagSelf.image = [UIImage imageNamed:@"标签 copy"];
    tagSelf.contentMode = UIViewContentModeCenter;
    UILabel *price = [[UILabel alloc] init];
    [_btView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagSelf.mas_right).with.offset(3);
        make.centerY.equalTo(tagSelf.mas_centerY);
    }];
    price.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    price.textColor = [UIColor colorWithHexString:@"#DA4937"];
    price.text = [NSString stringWithFormat:@"$%@", self.specialPrice];
    UIButton *commit = [[UIButton alloc] init];
    [_btView addSubview:commit];
    [commit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btView.mas_right);
        make.top.equalTo(_btView.mas_top);
        make.bottom.equalTo(_btView.mas_bottom);
        make.width.mas_equalTo(168.5);
    }];
    commit.backgroundColor = [UIColor colorWithHexString:@"#DA4937"];
    commit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [commit setTitle:@"Buy" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)createInfoView {
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 400)];
    [self.mainContentView addSubview:self.infoView];
    self.infoView.backgroundColor = [UIColor blueColor];
    UILabel *name = [[UILabel alloc] init];
    [_infoView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView.mas_left).with.offset(20);
        make.right.equalTo(_infoView.mas_right).with.offset(-20);
        make.top.equalTo(_infoView.mas_top).with.offset(1);
    }];
    name.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    name.textColor = COLOR_3;
    name.text = _productName;
    
    UILabel *priceLB = [[UILabel alloc] init];
    [_infoView addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).with.offset(12);
        make.left.equalTo(_infoView.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    priceLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    priceLB.textColor = [UIColor colorWithHexString:@"#DE4536"];
    
    priceLB.text = [NSString stringWithFormat:@"$%@", self.specialPrice];
    
    UILabel *oriPrice = [[UILabel alloc] init];
    [_infoView addSubview:oriPrice];
    [oriPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.mas_right).with.offset(8);
        make.centerY.equalTo(priceLB.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",self.originalPrice]
                                    attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    oriPrice.attributedText = attrStr;
    
    UIView *sale = [[UIView alloc] init];
    [_infoView addSubview:sale];
    [sale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oriPrice.mas_right).with.offset(7.5);
        make.centerY.equalTo(oriPrice.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(41, 18));
    }];
    sale.layer.borderWidth = 0.5;
    sale.layer.borderColor = COLOR_D.CGColor;
    sale.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    UILabel *saleLB = [[UILabel alloc] init];
    [sale addSubview:saleLB];
    [saleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(sale.center);
    }];
    saleLB.text = [NSString stringWithFormat:@"%@", self.discount];
    saleLB.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    saleLB.textColor = [UIColor colorWithHexString:@"#FFA057"];
    
    UILabel *bought = [[UILabel alloc] init];
    [_infoView addSubview:bought];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_infoView.mas_right).with.offset(-20);
        make.centerY.equalTo(saleLB.mas_centerY);
    }];
    bought.textColor = COLOR_9;
    bought.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    bought.text = [NSString stringWithFormat:@"%@ bought", self.saleVolume];
    
    LJCellLine *line1 = [[LJCellLine alloc] init];
    [_infoView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoView.mas_left).with.offset(SCREEN_MARGIN);
        make.top.equalTo(priceLB.mas_bottom).with.offset(20);
    }];
}

- (void)createDescriptionView {
    
}

- (void)createBanner {
    [_mainScrollView addSubview:_bannerScrollView];
    [_bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mainScrollView.mas_left);
        make.right.equalTo(_mainScrollView.mas_right);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_W));
    }];
    self.bannerScrollView.autoScroll = NO;
    self.bannerScrollView.currentPageDotColor = COLOR_8;
    _bannerScrollView.pageDotColor = COLOR_D8;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 懒加载
- (SDCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[SDCycleScrollView alloc] init];
    }
    return _bannerScrollView;
}



@end
