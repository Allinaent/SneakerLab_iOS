//
//  EditView.m
//  SneakerLab
//
//  Created by edz on 2016/10/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "EditView.h"
#import "UIView+YZTCView.h"
@interface EditView ()<UICollectionViewDelegate>
{
NSInteger  _total;
}
@property (nonatomic,strong)UIButton * downView;
@property (nonatomic,strong)UIButton * downView1;
@property (nonatomic,strong)UIButton * downView2;
@property (nonatomic,strong)UIButton * downView3;
@property (nonatomic,strong)UIButton * downView4;
@property (nonatomic,strong)UIButton * downView5;
@property (nonatomic,strong)UIButton * downView6;
@property (nonatomic,strong)UIButton * downView7;
@property (nonatomic,strong)UIButton * downView8;
@property (nonatomic,strong)UIScrollView * screView;

@end

@implementation EditView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (UIButton  *)downView
//{
//    if (_downView ==nil) {
//        _downView  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, SCREEN_W, 20)] ;
//        _downView.backgroundColor = [UIColor  blackColor];
//        _downView.alpha = 1;
//        [_downView setTitle:@"12345678" forState:UIControlStateNormal];
//        [_downView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_downView addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//        [self  addSubview:_downView ];
//    }
//    return _downView  ;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createViews];
        
    }
    return self;
    
}

-(void)createViews{

 self.backgroundColor = [UIColor redColor];
    
    _screView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 50, 200)];
    _screView.bounces = NO;
    _screView.userInteractionEnabled = YES;
    _screView.pagingEnabled = YES;
    _screView.scrollEnabled = NO;
    _screView.delegate = self;
    _screView.showsVerticalScrollIndicator = YES;
    _screView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_screView];
    
    
    _downView = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView.frame= CGRectMake(0, 5, 50, 20);
    [_downView setTitle:@"1" forState:UIControlStateNormal];
    [_downView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView];
    _downView1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView1.frame= CGRectMake(0, _downView.yzBottom+3, 50, 20);
    [_downView1 setTitle:@"2" forState:UIControlStateNormal];
    [_downView1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView1.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView1.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView1];
    _downView2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView2.frame= CGRectMake(0, _downView1.yzBottom+3, 50, 20);
    [_downView2 setTitle:@"3" forState:UIControlStateNormal];
    [_downView2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView2.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView2.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView2];
    _downView3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView3.frame= CGRectMake(0, _downView2.yzBottom+3, 50, 20);
    [_downView3 setTitle:@"4" forState:UIControlStateNormal];
    [_downView3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView3.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView3.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView3];
    _downView4 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView4.frame= CGRectMake(0, _downView3.yzBottom+3, 50, 20);
    [_downView4 setTitle:@"5" forState:UIControlStateNormal];
    [_downView4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView4.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView4.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView4];
    _downView5 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView5.frame= CGRectMake(0, _downView4.yzBottom+3, 50, 20);
    [_downView5 setTitle:@"6" forState:UIControlStateNormal];
    [_downView5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView5.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView5.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView5];
    _downView6 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView6.frame= CGRectMake(0, _downView5.yzBottom+3, 50, 20);
    [_downView6 setTitle:@"7" forState:UIControlStateNormal];
    [_downView6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView6.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView6.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView6];
    _downView7 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView7.frame= CGRectMake(0, _downView6.yzBottom +3, 50, 20);
    [_downView7 setTitle:@"8" forState:UIControlStateNormal];
    [_downView7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView7.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView7.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    [_screView addSubview:_downView7];
    _downView8 = [UIButton buttonWithType:UIButtonTypeCustom];
    _downView8.frame= CGRectMake(0, _downView7.yzBottom, 50, 20);
    [_downView8 setTitle:@"9" forState:UIControlStateNormal];
    [_downView8 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    _downView8.titleLabel.font = [UIFont systemFontOfSize:22.0];
    _downView8.titleLabel.textAlignment= NSTextAlignmentCenter;
    [_screView addSubview:_downView];

}
@end
