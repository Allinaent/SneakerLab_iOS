//
//  GProductDetailViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//


#import "GProductDetailViewController.h"
#import "GRatingCell.h"
#import <GTMNSStringHTMLAdditions/GTMNSString+HTML.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MyStarView.h"
#import <CNPPopupController/CNPPopupController.h>
#import "ShoppingInfoController.h"
#import "RatingController.h"
#import "SignInController.h"
#import "ShopViewController.h"
#import "ChoseView.h"
#import "GShippingCartViewController.h"
#import "WZLBadgeImport.h"

@interface GProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,SDCycleScrollViewDelegate,TypeSeleteDelegete>
{
    ChoseView *choseView;
    NSArray *sizearr;//型号数组
    NSArray *colorarr;//分类数组
    NSDictionary *stockarr;//商品库存量
    NSString *_product_option_id;//尺寸
    NSString *_product_option_value_id;
    NSString *_product_option_id2;//颜色（没有设计只能简单实现）
    NSString *_product_option_value_id2;
    NSString *_size;
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) CGFloat cell2Height;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIWebView *describeview;
@property (nonatomic, strong) NSString *htmlcontent;
@property (nonatomic, strong) SDCycleScrollView *banerview;
@property (nonatomic, strong) NSDictionary *all;
@end

@interface GProductDetailViewController () <CNPPopupControllerDelegate>
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) NSDictionary *shipping_info;
@property (nonatomic, assign) NSInteger ratingNum;
@property (nonatomic, assign) NSArray *imagesUrlArr;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *bought;
@property (nonatomic, assign) NSInteger save;
@property (nonatomic, strong) NSNumber *star;
//add buy
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSMutableArray *sizeMutableArray;
@property (nonatomic, strong) NSMutableArray *colorMutableArray;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger minimum;

@end

@implementation GProductDetailViewController

#pragma mark - 声明周期
- (void)viewDidLoad {
    self.title = @"Product Details";
    SET_NAV_MIDDLE
    UIBarButtonItem *shareButton = [UIBarButtonItem itemWithImage:@"分享 copy" highImage:nil target:self action:@selector(shareAction)];
    //self.navigationItem.rightBarButtonItem = shareButton;
    
    [self createviews];
    [self requestdatas];
}


- (void)createviews {
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = COLOR_FA;
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.tableFooterView = foot;
    self.view.backgroundColor = COLOR_FA;
    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    self.bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottom];
    [self configBottom];
}

- (void)requestdatas {
    NSDictionary *dic = @{@"product_id":self.productID};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:PRODUCTDETAIL_URL andSignature:YES andLogin:NO finish:^(NSURLSessionDataTask *task, id responseObject) {
        _all = [responseObject objectForKey:@"data"];
        NSArray *array = [_all objectForKey:@"images"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *str in array) {
            [arr addObject:[NSString phpStr:str]];
        }
        self.banerview.imageURLStringsGroup = arr;
        self.banerview.placeholderImage = loadFailImg;
        _htmlcontent = [_all valueForKey:@"description"];
        _shipping_info = [_all valueForKey:@"shipping_info"];
        self.ratingNum = [[_all valueForKey:@"reviews"] integerValue];
        self.save = [[_all valueForKey:@"collections"] integerValue];
        self.bought = [_all valueForKey:@"sales_volume"];
        self.star = [_all valueForKey:@"rating"];
        self.quantity = [[_all valueForKey:@"quantity"] integerValue];
        self.productName = [_all valueForKey:@"name"];
        self.price = [_all valueForKey:@"special_price"];
        self.minimum = [[_all valueForKey:@"minimum"] integerValue];
        NSArray *options = [_all valueForKey:@"options"];
        NSMutableArray *arrsize = [NSMutableArray array];
        NSMutableArray *arrcolor = [NSMutableArray array];
        for (NSDictionary *dict in options) {
            _product_option_id = dict[@"product_option_id"];
            NSString *attr = dict[@"name"];
            NSArray *productOptionValueArray = dict[@"product_option_value"];
            //获取属性数组内容
            for (NSDictionary *productOptionValueDict in productOptionValueArray) {
                //放入对应的数组中
                if ([attr isEqualToString:@"size"]) {
                    [self.sizeMutableArray addObject:productOptionValueDict];
                    [arrsize addObject:[productOptionValueDict valueForKey:@"name"]];
                }
                if ([attr isEqualToString:@"color"]) {
                    [self.colorMutableArray addObject:productOptionValueDict];
                    [arrcolor addObject:[productOptionValueDict valueForKey:@"name"]];
                }
                
            }
        }
        sizearr = [NSArray arrayWithArray:arrsize];
        colorarr = [NSArray arrayWithArray:arrcolor];
        [self initChoseView];
        choseView.minimum = self.minimum;
        NSString *htmlcontentstring = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head><div id=\"webview_content_wrapper\">%@</div>", (SCREEN_W-20),self.htmlcontent.gtm_stringByUnescapingFromHTML];
        [self.describeview loadHTMLString:htmlcontentstring baseURL:nil];
        [self.view addSubview:self.tableview];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    view.backgroundColor = COLOR_FA;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        //return 448.5+SCREEN_W;
        return 448.5+SCREEN_W-175;
    }else if(indexPath.section==1){
        return MAX(49, _cell2Height);
    }else{
        return 119;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section==0) {
        cell.frame = CGRectMake(0, 0, SCREEN_W, 448.5+SCREEN_W);
        self.banerview.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W);
        [cell.contentView addSubview:self.banerview];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_W+1, SCREEN_W-40, 37)];
        name.font = FONT_16;
        name.textColor = COLOR_3;
        name.text = [_all valueForKey:@"name"];
        [cell.contentView addSubview:name];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_W+50, 100, 20)];
        price.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        price.textColor = COLOR_RED;
        price.text = [NSString stringWithFormat:@"$%@", [_all valueForKey:@"special_price"]];
        [price sizeToFit];
        [cell.contentView addSubview:price];
        
        UILabel *price2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price.frame)+8, SCREEN_W+53.5, 100, 14)];
        price2.font = FONT_12;
        NSString *origin = [_all valueForKey:@"original_price"];
        NSAttributedString *attrStr =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",origin]
                                        attributes:
         @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12],
           NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
           NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        price2.attributedText = attrStr;
        [price2 sizeToFit];
        [cell.contentView addSubview:price2];
        
        UILabel *sale = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(price2.frame)+8, SCREEN_W+ 51.5, 41, 18)];
        sale.backgroundColor = COLOR_FA;
        sale.layer.borderWidth = 0.5;
        sale.layer.borderColor = COLOR_D.CGColor;
        sale.font = FONT_12;
        sale.textColor = [UIColor colorWithHexString:@"#FFA057"];
        NSString *salestr = [_all valueForKey:@"discount"];
        sale.text = [NSString stringWithFormat:@"-%@", salestr];
        sale.textAlignment = 1;
        [cell.contentView addSubview:sale];
        
        UILabel *bought = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-20-100, 54+SCREEN_W, 100, 14)];
        bought.textAlignment = 2;
        bought.font = FONT_12;
        bought.textColor = COLOR_9;
        NSString *boughtstr = [_all valueForKey:@"sales_volume"];
        bought.text = [NSString stringWithFormat:@"%@ bought", boughtstr];
        [cell.contentView addSubview:bought];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 81.5+SCREEN_W, SCREEN_W-20, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:line];
        
        UILabel *off = [[UILabel alloc] initWithFrame:CGRectMake(20, 91.5+SCREEN_W, 150, 16.5)];
        off.textColor = COLOR_9;
        off.font = FONT_14;
        off.text = @"Price-off promotions";
        [off sizeToFit];
        [cell.contentView addSubview:off];
        
        UILabel *run = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-54.5-20, 91.5+SCREEN_W, 54.5, 20)];
        run.backgroundColor = [UIColor colorWithHexString:@"#FF897D"];
        run.text = @"short run";
        run.textAlignment = 1;
        run.font = FONT_11;
        run.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:run];
        
        UIView *separate1 = [[UIView alloc] initWithFrame:CGRectMake(0, 117+SCREEN_W, SCREEN_W, 10)];
        separate1.backgroundColor = COLOR_FA;
        [cell.contentView addSubview:separate1];
        
        UIButton *size = [[UIButton alloc] initWithFrame:CGRectMake(0, 127+SCREEN_W, SCREEN_W, 47)];
        [size addTarget:self action:@selector(sizeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel *sizelb = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 100, 16.5)];
        sizelb.text = @"Size chart";
        sizelb.font = FONT_14;
        sizelb.textColor = COLOR_3;
        [sizelb sizeToFit];
        [size addSubview:sizelb];
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-47, 0, 47, 47)];
        right.contentMode = UIViewContentModeCenter;
        right.image = [UIImage imageNamed:@"向右箭头"];
        [size addSubview:right];
        [cell.contentView addSubview:size];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, 175+SCREEN_W, SCREEN_W-20, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:line2];
        
        UIButton *shipping = [[UIButton alloc] initWithFrame:CGRectMake(0, 175.5+SCREEN_W, SCREEN_W, 47)];
        [shipping addTarget:self action:@selector(shippingButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel *ship = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 16.5)];
        ship.text = @"Shipping info";
        ship.font = FONT_14;
        ship.textColor = COLOR_3;
        [ship sizeToFit];
        [shipping addSubview:ship];
        UIImageView *right2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-47, 0, 47, 47)];
        right2.contentMode = UIViewContentModeCenter;
        right2.image = [UIImage imageNamed:@"向右箭头"];
        [shipping addSubview:right2];
        UILabel *viewall = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-47-50, 15, 50, 14)];
        viewall.font = FONT_12;
        viewall.textColor = COLOR_9;
        viewall.text = @"View all";
        [shipping addSubview:viewall];
        [cell.contentView addSubview:shipping];
        
        UIView *separate2 = [[UIView alloc] initWithFrame:CGRectMake(0, 223+SCREEN_W, SCREEN_W, 10)];
        separate2.backgroundColor = COLOR_FA;
        [cell.contentView addSubview:separate2];
        
        UIButton *rating = [[UIButton alloc] initWithFrame:CGRectMake(0, 233+SCREEN_W, SCREEN_W, 44)];
        [rating addTarget:self action:@selector(ratingButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UILabel *rates = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 14.5, 100, 16.5)];
        rates.textColor = COLOR_3;
        rates.font = FONT_14;
        rates.text = @"Ratings";
        [rates sizeToFit];
        [rating addSubview:rates];
        MyStarView *starView = [[MyStarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rates.frame)+15, 14, 87.5, 12)];
        CGFloat star = [self.star floatValue];
        [starView withStar:star :87.5 :12];
        [rating addSubview:starView];
        UILabel *ratenum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starView.frame)+7.5, 14, 31, 16.5)];
        NSString *reviews = [_all valueForKey:@"reviews"];
        ratenum.text = [NSString stringWithFormat:@"(%@)", reviews];
        ratenum.font = FONT_14;
        ratenum.textColor = COLOR_9;
        [ratenum sizeToFit];
        [rating addSubview:ratenum];
        UIImageView *right3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-47, 0, 47, 47)];
        right3.contentMode = UIViewContentModeCenter;
        right3.image = [UIImage imageNamed:@"向右箭头"];
        [rating addSubview:right3];
        UILabel *viewal2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-47-50, 15, 50, 14)];
        viewal2.font = FONT_12;
        viewal2.textColor = COLOR_9;
        viewal2.text = @"View all";
        [rating addSubview:viewal2];
        [cell.contentView addSubview:rating];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(17.5, 277+SCREEN_W, SCREEN_W-17.5, 0.5)];
        line3.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:line3];
        
        UIView *cell1 = [[UIView alloc] initWithFrame:CGRectMake(0, 277.5+SCREEN_W, SCREEN_W, 90)];
        UIImageView *head1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17.5, 37, 37)];
        NSString *headstr1 = @"";
        [head1 setPHPImageUrl:headstr1 placeholder:@"头像_product rating"];
        [cell1 addSubview:head1];
        head1.hidden = YES;
        
        UILabel *cellname = [[UILabel alloc] initWithFrame:CGRectMake(72, 15.5, 100, 16.5)];
        cellname.font = FONT_14;
        cellname.textColor = COLOR_6;
        NSString *name1 = @"";
        cellname.text = name1;
        [cellname sizeToFit];
        [cell1 addSubview:cellname];
        
        MyStarView *cellstar1 = [[MyStarView alloc] initWithFrame:CGRectMake(SCREEN_W-24-87.5, 19, 87.5, 12)];
        CGFloat star1=0;
        [cellstar1 withStar:star1 :87.5 :12];
        [cell1 addSubview:cellstar1];
        cellstar1.hidden = YES;
        UILabel *comment1 = [[UILabel alloc] initWithFrame:CGRectMake(72, 42, SCREEN_W-72-32.5, 33)];
        NSString *commentstr1 = @"";
        comment1.text = commentstr1;
        comment1.font = FONT_14;
        comment1.textColor = COLOR_3;
        comment1.numberOfLines = 0;
        [cell.contentView addSubview:cell1];
        
        UIView *li = [[UIView alloc] initWithFrame:CGRectMake(72, 369+SCREEN_W, SCREEN_W-72, 0.5)];
        li.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [cell.contentView addSubview:li];
        li.hidden = YES;
        UIView *cell2 = [[UIView alloc] initWithFrame:CGRectMake(0, 369.5+SCREEN_W, SCREEN_W, 90)];
        UIImageView *head2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17.5, 37, 37)];
        NSString *headstr2 = @"";
        [head2 setPHPImageUrl:headstr2 placeholder:@"头像_product rating"];
        [cell2 addSubview:head2];
        head2.hidden = YES;
        UILabel *cellname2 = [[UILabel alloc] initWithFrame:CGRectMake(72, 15.5, 100, 16.5)];
        cellname2.font = FONT_14;
        cellname2.textColor = COLOR_6;
        NSString *name2 = @"";
        cellname2.text = name2;
        [cellname2 sizeToFit];
        [cell2 addSubview:cellname2];
        
        MyStarView *cellstar2 = [[MyStarView alloc] initWithFrame:CGRectMake(SCREEN_W-24-87.5, 19, 87.5, 12)];
        CGFloat star2=0;
        [cellstar2 withStar:star2 :87.5 :12];
        [cell2 addSubview:cellstar2];
        cellstar2.hidden = YES;
        UILabel *comment2 = [[UILabel alloc] initWithFrame:CGRectMake(72, 42, SCREEN_W-72-32.5, 33)];
        NSString *commentstr2 = @"";
        comment2.text = commentstr2;
        comment2.font = FONT_14;
        comment2.textColor = COLOR_3;
        comment2.numberOfLines = 0;
        [cell.contentView addSubview:cell2];
        
    }else if (indexPath.section == 1) {
        cell.tag = 123;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:_describeview];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 22.5, SCREEN_W-40, 0.5)];
        line.backgroundColor = COLOR_9;
        [cell.contentView addSubview:line];
        UILabel *product = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-150)/2, 15, 150, 14)];
        product.textAlignment = 1;
        product.font = FONT_12;
        product.text = @"product description";
        product.backgroundColor = [UIColor whiteColor];
        product.textColor = COLOR_6;
        [cell.contentView addSubview:product];
        [self.tableview bringSubviewToFront:cell];
    }else {
        cell.frame = CGRectMake(0, 0, SCREEN_W, 119);
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 19, SCREEN_W-40, 0.5)];
        line.backgroundColor = COLOR_9;
        [cell.contentView addSubview:line];
        
        UILabel *service = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-150)/2, 10, 150, 17)];
        service.backgroundColor = [UIColor whiteColor];
        service.font = FONT_14;
        service.text = @"Service Guarantee";
        service.textAlignment = 1;
        service.textColor = COLOR_9;
        [cell.contentView addSubview:service];
        
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-41*3)/4, 44.5, 41, 41)];
        img1.image = [UIImage imageNamed:@"secure"];
        [cell.contentView addSubview:img1];
        
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-41*3)/4 *2+41.5, 44.5, 41, 41)];
        img2.image = [UIImage imageNamed:@"quality"];
        [cell.contentView addSubview:img2];
        
        UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-41*3)/4 *3+41.5*2, 44.5, 41, 41)];
        img3.image = [UIImage imageNamed:@"fast"];
        [cell.contentView addSubview:img3];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-100*3)/4, 90.5, 100, 14)];
        label1.font = FONT_12;
        label1.textAlignment = 1;
        label1.textColor = COLOR_6;
        label1.text = @"Secure";
        label1.centerX = img1.frame.origin.x+20.5;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-100*3)/4 *2+100, 90.5, 100, 14)];
        label2.font = FONT_12;
        label2.textAlignment = 1;
        label2.textColor = COLOR_6;
        label2.text = @"Quality";
        label2.centerX = img2.frame.origin.x+20.5;
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-100*3)/4 *3+100*2, 90.5, 100, 14)];
        label3.font = FONT_12;
        label3.textAlignment = 1;
        label3.textColor = COLOR_6;
        label3.text = @"Fast";
        label3.centerX = img3.frame.origin.x+20.5;
        [cell.contentView addSubview:label3];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark - 一级方法
- (void)shareAction {
    
}

#pragma mark - 二级方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    height = height * frame.height / clientheight;
    webView.frame = CGRectMake(0, 49, self.view.frame.size.width, height);
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.scrollEnabled = NO;
    webView.opaque = NO;
    _cell2Height = height+49;
    _cell2Height = MAX(_cell2Height, 49);
    UITableViewCell *cell = [self.tableview viewWithTag:123];
    cell.frame = CGRectMake(0, 0, SCREEN_W, _cell2Height);
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"signInSuccessful"]boolValue]==NO ) {
        return;
    }
    [PHPNetwork PHPNetworkWithParam:nil andUrl:SHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *all = [responseObject valueForKey:@"data"];
        NSArray *carts = [all valueForKey:@"cart"];
        NSArray *cartbacks = [all valueForKey:@"cartback"];
        _cartnum = carts.count;
        [_cart showBadgeWithStyle:WBadgeStyleNumber value:_cartnum animationType:WBadgeAnimTypeNone];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)configBottom {
    UIButton *chat = [[UIButton alloc] initWithFrame:CGRectMake(18.5, 17, 22.5, 21)];
    [chat setBackgroundImage:[UIImage imageNamed:@"留言 (1)"] forState:UIControlStateNormal];
    [chat addTarget:self action:@selector(chatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:chat];
    
    UIButton *collect = [[UIButton alloc] initWithFrame:CGRectMake(65, 17, 22.5, 21)];
    [collect setBackgroundImage:[UIImage imageNamed:@"保存-拷贝"] forState:UIControlStateNormal];
    [collect setBackgroundImage:[UIImage imageNamed:@"保存填充"] forState:UIControlStateSelected];
    [collect addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _cart = [[UIButton alloc] initWithFrame:CGRectMake(115, 17, 22.5, 21)];
    [_cart setBackgroundImage:[UIImage imageNamed:@"购物车2"] forState:UIControlStateNormal];
    [_cart addTarget:self action:@selector(cartButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:_cart];
    //遍历收藏列表来确定button的选中状态
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"signInSuccessful"]boolValue]==YES) {
        [PHPNetwork PHPNetworkWithUrl:COllECTION_URL finish:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:responseObject];
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                if ([[dic valueForKey:@"product_id"] isEqualToString:_productID]) {
                    collect.selected = YES;
                }
            }
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else{
        //SignInController *vc = [[SignInController alloc] init];
        //[self.navigationController pushViewController:vc animated:YES];
    }
    [_bottom addSubview:collect];
    
    
    UIButton *buy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W*3/4, 0, SCREEN_W/4, 49)];
    buy.backgroundColor = COLOR_RED;
    [buy setTitle:@"Buy now" forState:UIControlStateNormal];
    buy.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [buy addTarget:self action:@selector(buyButtonAction) forControlEvents:UIControlEventTouchUpInside];
#warning 修改
    buy.hidden = YES;
    [_bottom addSubview:buy];
#warning 修改
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, 49)];
    add.backgroundColor = [UIColor colorWithHexString:@"#FFA057"];
    [add setTitle:@"Add cart" forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [add addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottom addSubview:add];
}

#pragma mark - 三级方法
- (void)chatButtonAction {
    
}

- (void)collectButtonAction:(UIButton *)btn {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES) {
        
        if (btn.selected)
        {
            //发送请求删除
            NSDictionary *dic = @{@"product_id":_productID};
            [PHPNetwork PHPNetworkWithParam:dic andUrl:DELCOLLECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
                btn.selected = NO;
            } err:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        else
        {
            NSDictionary *dic = @{@"product_id":_productID};
            [PHPNetwork PHPNetworkWithParam:dic andUrl:ADDCOLLECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
                btn.selected = YES;
            } err:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }else{
        //跳转到登录页面
        SignInController *vc = [[SignInController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cartButtonAction {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue]) {
        GShippingCartViewController *shipvc = [[GShippingCartViewController alloc] init];
        [self.navigationController pushViewController:shipvc animated:YES];
    }else{
        SignInController *vc = [[SignInController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addButtonAction {
    choseView.type = @"add";
    [choseView.button setTitle:@"Add cart" forState:UIControlStateNormal];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]boolValue] == YES)
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            [choseView bringSubviewToFront:choseView.whiteView];
        } completion: nil];
    }
    else
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        } completion: nil];
    }
}

- (void)buyButtonAction {
    choseView.type = @"buy";
    [choseView.button setTitle:@"Buy now" forState:UIControlStateNormal];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]boolValue] == YES)
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            [choseView bringSubviewToFront:choseView.whiteView];
        } completion: nil];
    }
    else
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        } completion: nil];
    }
}

- (void)sizeButtonAction {
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
}

- (void)shippingButtonAction {
    ShoppingInfoController *vc = [[ShoppingInfoController alloc] init];
    vc.shipping_info = self.shipping_info;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ratingButtonAction {
    RatingController *vc = [[RatingController alloc] init];
    vc.productID = self.productID;
    vc.ratingNum = self.ratingNum;
    vc.productImage = self.banerview.imageURLStringsGroup.firstObject;
    vc.productName = _productName;
    vc.bought = self.bought;
    vc.save = self.save;
    vc.star = [self.star floatValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-200-49)];
    scrollview.contentSize = CGSizeMake(SCREEN_W, 675);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 675)];
    scrollview.showsVerticalScrollIndicator = NO;
    [scrollview addSubview:view];
    UILabel *size = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-100)/2, 15, 100, 17.5)];
    size.textAlignment = 1;
    size.font = FONT_15;
    size.textColor = COLOR_3;
    size.text = @"Size Chart";
    [view addSubview:size];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 47.5, SCREEN_W-100, 28)];
    title.numberOfLines = 0;
    title.font = FONT_12;
    title.textColor = COLOR_9;
    title.text = @"This size chart is intended for reference only.Size can vary between brands.";
    [view addSubview:title];
    UIImageView *sizeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90.5, SCREEN_W-30, 675-90.5-15)];
    sizeImage.image = [UIImage imageNamed:@"尺码表"];
    sizeImage.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:sizeImage];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, SCREEN_H-200-49, SCREEN_W, 49)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [button setTitle:@"Continue" forState:UIControlStateNormal];
    button.backgroundColor = COLOR_RED;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    self.popupController = [[CNPPopupController alloc] initWithContents:@[scrollview,button]];
    self.popupController.theme.maxPopupWidth = SCREEN_H - 64 -200;
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.theme.popupContentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate
- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}


#pragma mark - 懒加载
- (NSMutableArray *)sizeMutableArray {
    if (!_sizeMutableArray) {
        _sizeMutableArray = [NSMutableArray array];
    }
    return _sizeMutableArray;
}

- (NSMutableArray *)colorMutableArray {
    if (!_colorMutableArray) {
        _colorMutableArray = [NSMutableArray array];
    }
    return _colorMutableArray;
}

- (UIWebView *)describeview {
    if (!_describeview) {
        _describeview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 100)];
        _describeview.delegate = self;
    }
    return _describeview;
}

- (SDCycleScrollView *)banerview {
    if (!_banerview) {
        _banerview = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W)];
        self.banerview.autoScroll=NO;
        self.banerview.delegate=self;
        self.banerview.currentPageDotColor = COLOR_8;
        self.banerview.pageDotColor = COLOR_D8;
    }
    return _banerview;
}

- (NSArray *)imagesUrlArr {
    if (!_imagesUrlArr) {
        _imagesUrlArr = [NSArray array];
    }
    return _imagesUrlArr;
}

-(void)initChoseView
{
    //选择尺码颜色的视图
    choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    
    choseView.productID = self.productID;
    choseView.product_option_id = self.product_option_id;
    choseView.images1 = self.banerview.imageURLStringsGroup.firstObject;
    
    //存货量
    choseView.stock = self.quantity;
    //颜色
    if (self.colorMutableArray.count==0) {
        choseView.colorView.frame = CGRectZero;
    }
    else{
        choseView.colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, choseView.frame.size.width, 50) andDatasource:colorarr :@"Color"];
        choseView.colorView.delegate = self;
        choseView.colorView.frame = CGRectMake(0, 0, choseView.frame.size.width, choseView.colorView.height);
    }
    [choseView.mainscrollview addSubview:choseView.colorView];
    
    //尺码
    if (self.sizeMutableArray.count==0) {
        choseView.sizeView.frame = CGRectZero;
    }
    else{
        choseView.sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, choseView.colorView.frame.size.height, choseView.frame.size.width, 50) andDatasource:sizearr :@"Size"];
        choseView.sizeView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.sizeView];
        choseView.sizeView.frame = CGRectMake(0, choseView.colorView.frame.size.height, choseView.frame.size.width, choseView.sizeView.height);
    }
    
    //购买数量
    choseView.countView.frame = CGRectMake(0, choseView.sizeView.frame.size.height+choseView.sizeView.frame.origin.y, choseView.frame.size.width, 50);
    choseView.mainscrollview.contentSize = CGSizeMake(self.view.frame.size.width, choseView.countView.frame.size.height+choseView.countView.frame.origin.y);
    choseView.lb_price.text = [NSString stringWithFormat:@"$%@",_price];
    //存货量
    choseView.lb_stock.text = [NSString stringWithFormat:@"Inventory:%ld",(long)self.quantity];
    choseView.lb_detail.text = @"Please choose color and size";
    [choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [choseView.alphaiView addGestureRecognizer:tap];
    //点击图片放大图片
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    choseView.img.userInteractionEnabled = YES;
    [choseView.img addGestureRecognizer:tap1];
}

#pragma mark - typeDelegate（这里是选择尺寸和颜色的点击方法）
-(void)btnindex:(int)tag
{
    //通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    if (choseView.colorView.frame.size.height!=0) {
        if (choseView.sizeView.seletIndex >-1&&choseView.colorView.seletIndex >-1) {
            //尺码和颜色都选择的时候
            NSString *size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
            NSString *color =[colorarr objectAtIndex:choseView.colorView.seletIndex];
            choseView.lb_stock.text = [NSString stringWithFormat:@"Stock %@ ",[[stockarr objectForKey: size] objectForKey:color]];
            choseView.lb_detail.text = [NSString stringWithFormat:@"Chosn \"%@\" \"%@\"",size,color];
            choseView.stock =[[[stockarr objectForKey: size] objectForKey:color] intValue];
            
            [self reloadTypeBtn:[stockarr objectForKey:color] :sizearr :choseView.sizeView :choseView.bt_sure];
            
            choseView.bt_sure.enabled = YES;
            choseView.bt_sure.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
            for (NSDictionary *dic in self.sizeMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:size]) {
                    choseView.product_option_value_id = [dic valueForKey:@"product_option_value_id"];
                }
            }
            for (NSDictionary *dic in self.colorMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:color]) {
                    choseView.product_option_value_id2 = [dic valueForKey:@"product_option_value_id"];
                }
            }
        }
        else{
            NSLog(@"Please choose color and size");
        }
    }
    else{
        if (choseView.sizeView.seletIndex >-1) {
            // 只选了尺码
            _size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
            // 根据所选尺码 取出该尺码对应所有颜色的库存字典
            [self resumeBtn:sizearr :choseView.sizeView];
            choseView.lb_detail.text = [NSString stringWithFormat:@"Chosn \"%@\"", _size];
            choseView.stock = 10;//先固定
            choseView.bt_sure.enabled = NO;
            choseView.bt_sure.backgroundColor = [UIColor redColor];
            for (NSDictionary *dic in self.sizeMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:_size]) {
                    choseView.product_option_value_id = [dic valueForKey:@"product_option_value_id"];
                }
            }
        }
        else{
            NSLog(@"Please choose size");
        }
    }
    
}

//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#de4536"]];
        }
    }
}

//根据所选的尺码或者颜色对应库存量 确定哪些按钮不可选
-(void)reloadTypeBtn:(NSDictionary *)dic :(NSArray *)arr :(TypeView *)view :(UIButton *)btnSure
{
    for (int i = 0; i<arr.count; i++)
    {
        int count = [[dic objectForKey:[arr objectAtIndex:i]] intValue];
        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        //库存为零 不可点击
        if (count == 0)
        {
            btn.enabled = NO;
            [btn setTitleColor:[UIColor colorWithHexString:@"#de4536"] forState:0];
        }
        else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor colorWithHexString:@"#de4536"] forState:0];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.seletIndex == i)
        {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
    
}

-(void)dismiss
{
    //center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        choseView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
    
}

-(void)showBigImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"放大图片");
}

@end
