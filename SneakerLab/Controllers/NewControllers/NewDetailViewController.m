//
//  NewDetailViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/9.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NewDetailViewController.h"
#import <SDCycleScrollView.h>
@interface NewDetailViewController ()
@property (strong, nonatomic) SDCycleScrollView *bannerScrollView;

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *oriPrice;
@property (strong, nonatomic) NSString *sale;
@property (strong, nonatomic) NSString *bought;
/**
 baseViews
 */
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *btView;
@property (strong, nonatomic) UIScrollView *upAndDown;
@property (strong, nonatomic) UIView *upAndDownContentView;
@property (strong, nonatomic) UIView *info;



@end

@implementation NewDetailViewController

#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DETAIL";
    self.view.backgroundColor = [UIColor whiteColor];
    [self newDetailRequestAndHandleDatas];
    
}

- (void)creatViews {
    
    [self setUpBaseViews];
    
    [self creatBtViews];
    
    [self creatInfoViews];
    
    [self setBanner];
    
}

- (void)setUpBaseViews {
    _bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    _bgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bgView];
    /*
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
     */
    [UIView showViewFrames:_bgView];
    
    self.btView = [[UIView alloc] init];
    self.btView.backgroundColor = [UIColor greenColor];
    self.btView.frame = CGRectMake(0, SCREEN_H-4.5, SCREEN_W, 49);
    [self.bgView addSubview:self.btView];
    /*
    [_btView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btView.mas_left);
        make.right.equalTo(_btView.mas_right);
        make.bottom.equalTo(_btView.mas_bottom).with.offset(-4.5);
        make.height.mas_equalTo(49);
    }];
     */
    
    [UIView showViewFrames:_btView];

    
    _upAndDown = [[UIScrollView alloc] init];
    [_bgView addSubview:_upAndDown];
    [_upAndDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView.mas_left);
        make.right.equalTo(_bgView.mas_right);
        make.bottom.equalTo(_btView.mas_top).with.offset(-1);
    }];
    
    [UIView showViewFrames:_upAndDown];
    
    _upAndDownContentView = [[UIView alloc] init];
    [_upAndDown addSubview:_upAndDownContentView];
    [_upAndDownContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_upAndDown.mas_left);
        make.right.equalTo(_upAndDown.mas_right);
        make.top.equalTo(_upAndDown.mas_top);
        make.height.mas_equalTo(1500);
    }];
    _bannerScrollView = [[SDCycleScrollView alloc] init];
    [_upAndDownContentView addSubview:_bannerScrollView];
    [_bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_upAndDownContentView.mas_left);
        make.right.equalTo(_upAndDownContentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, SCREEN_W));
    }];
    
    _info = [[UIView alloc] init];
    [_upAndDownContentView addSubview:_info];
    [_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_upAndDownContentView.mas_left);
        make.right.equalTo(_upAndDownContentView.mas_right);
        make.top.equalTo(_bannerScrollView.mas_bottom).with.offset(1);
        make.height.mas_equalTo(250);
    }];
    
}

- (void)creatInfoViews {
    UILabel *name = [[UILabel alloc] init];
    [_info addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_info.mas_left).with.offset(20);
        make.right.equalTo(_info.mas_right).with.offset(-20);
        make.top.equalTo(_info.mas_top).with.offset(1);
    }];
    name.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    name.textColor = COLOR_3;
    name.text = _productName;
    
    UILabel *priceLB = [[UILabel alloc] init];
    [_info addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).with.offset(12);
        make.left.equalTo(_info.mas_left).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    priceLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    priceLB.textColor = [UIColor colorWithHexString:@"#DE4536"];
    
    priceLB.text = [NSString stringWithFormat:@"$%@", self.price];
    
    UILabel *oriPrice = [[UILabel alloc] init];
    [_info addSubview:oriPrice];
    [oriPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.mas_right).with.offset(8);
        make.centerY.equalTo(priceLB.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",self.oriPrice]
                                   attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    oriPrice.attributedText = attrStr;
    
    UIView *sale = [[UIView alloc] init];
    [_info addSubview:sale];
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
    saleLB.text = [NSString stringWithFormat:@"%@", self.sale];
    saleLB.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    saleLB.textColor = [UIColor colorWithHexString:@"#FFA057"];
    
    UILabel *bought = [[UILabel alloc] init];
    [_info addSubview:bought];
    [_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_info.mas_right).with.offset(-20);
        make.centerY.equalTo(saleLB.mas_centerY);
    }];
    bought.textColor = COLOR_9;
    bought.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    bought.text = [NSString stringWithFormat:@"%@ bought", self.bought];
    
    LJCellLine *line1 = [[LJCellLine alloc] init];
    [_info addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_info.mas_left).with.offset(SCREEN_MARGIN);
        make.top.equalTo(priceLB.mas_bottom).with.offset(20);
    }];
}

- (void)creatBtViews {
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
    price.text = [NSString stringWithFormat:@"$%@", self.price];
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

- (void)setBanner {
    self.bannerScrollView.autoScroll = NO;
    self.bannerScrollView.currentPageDotColor = COLOR_8;
    _bannerScrollView.pageDotColor = COLOR_D8;
}

- (void)newDetailRequestAndHandleDatas {
    NSDictionary *dic = @{@"product_id":self.productID};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:PRODUCTDETAIL_URL andSignature:YES andLogin:NO finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        self.bannerScrollView.imageURLStringsGroup = [dataDic objectForKey:@"images"];
        self.oriPrice = [dataDic valueForKey:@"original_price"];
        self.price = [dataDic valueForKey:@"special_price"];
        self.productName = [dataDic valueForKey:@"name"];
        self.sale = [dataDic valueForKey:@"discount"];
        self.bought = [dataDic valueForKey:@"sales_volume"];
        [self creatViews];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        LJLog(@"!!!%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
