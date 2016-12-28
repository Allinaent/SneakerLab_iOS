//
//  HeaderView.m
//  caowei
//
//  Created by Jason cao on 16/9/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame withArr: (NSMutableArray *)images
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI:images];
    }
    return self;
}

- (void)createUI:(NSArray *)images
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, SCREEN_W)];
    scroller.contentSize = CGSizeMake(SCREEN_W * images.count, 0);
    scroller.showsVerticalScrollIndicator = NO;
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.bounces = NO;
    scroller.pagingEnabled = YES;
    for (int i = 0; i < images.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_W, 0, SCREEN_W, SCREEN_W)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        [scroller addSubview:imageView];
    }
    
    _likeBtn = [[UIButton alloc] init];
    _likeBtn.selected = self.likeBtnState;
    _likeBtn.frame = CGRectMake(0, SCREEN_W + 20, SCREEN_W / 2 - 2.5, 50);
    [_likeBtn setTitle:@"Like" forState:UIControlStateNormal];
    [_likeBtn setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    _likeBtn.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [_likeBtn setImage:[[UIImage imageNamed:@"保存-拷贝@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_likeBtn setImage:[[UIImage imageNamed:@"保存填充@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(collected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(SCREEN_W / 2 + 5, SCREEN_W + 20, SCREEN_W / 2 - 2.5, 50);
    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    shareBtn.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [shareBtn setImage:[[UIImage imageNamed:@"分享@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.5, SCREEN_W + 85, SCREEN_W, 17.5)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    _starView = [[MyStarView alloc] initWithFrame:CGRectMake(17.5, SCREEN_W + 107.5, 80, 14)];
    [self addSubview:_starView];
    
    _reviewedLabel = [FactoryUI createLabelWithFrame:CGRectMake(97.5, SCREEN_W + 107.5, 60, 14) text:@"()" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_reviewedLabel];
    
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(15, SCREEN_W + 136.5, 100, 16.5) text:@"Recent Views" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:14]];
    UIButton *button = [FactoryUI createButtonWithFrame:CGRectMake(120, SCREEN_W + 136.5, 80, 16.5) title:@"View all" titleColor:[UIColor colorWithHexString:@"#333333"] imageName:nil backgroundImageName:nil target:self selector:@selector(viewAll)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    [self addSubview:button];
    [self addSubview:_nameLabel];
    [self addSubview:shareBtn];
    [self addSubview:_likeBtn];
    [self addSubview:scroller];
}

- (void)collected
{
    //bug修改，2016-11-04 15:00:19，郭隆基
    if (_likeBtn.selected == NO) {
        
        _likeBtn.selected = YES;
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"token",@"product_id",@"equipment_id"];
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"token" : CWTOKEN,
                              @"product_id" : self.productID,
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
        
        [[CWAPIClient sharedClient] POSTRequest:ADDCOLLECTION_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             
         }];
    }
    else//取消收藏
    {
        _likeBtn.selected = YES;
        
    }
}

- (void)viewAll
{
    
}
@end
