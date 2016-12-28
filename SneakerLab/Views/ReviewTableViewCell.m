//
//  ReviewTableViewCell.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/24.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "LEOStarView.h"
#import "BRPlaceholderTextView.h"
#import "ReviewModel.h"
@interface ReviewTableViewCell ()
@property (nonatomic, strong) LEOStarView *starView;
@property (nonatomic, strong) BRPlaceholderTextView *text;
@property (nonatomic,strong)UIView *viewLine;

@end

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"reviewcell";
    //先从缓存池中找可重用的cell
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //没找到就创建
    if (cell == nil) {
        cell = [[ReviewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//通过代码自定义cell需要重写以下方法,可以添加额外的控件.
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.viewLine = [[UIView alloc]init];
        self.viewLine.backgroundColor = [UIColor blackColor];
        self.viewLine.alpha = 0.2;
        [self createUI];
        [self.contentView addSubview:self.viewLine];
    }
    return self;
}

- (void)createUI {
    UILabel *star = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_W-20, 16.5)];
    [self.contentView addSubview:star];
    star.text = @"star rate";
    star.textAlignment = 1;
    star.textColor = COLOR_6;
    star.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.starView = [[LEOStarView alloc] initWithFrame:CGRectMake((SCREEN_W-182.5)/2, 50, 182.5, 33.5)];
    self.starView.markType = EMarkTypeInteger;
    self.starView.currentIndex = 3;
    self.starView.totalScore = 5;
    self.starView.markType = EMarkTypeInteger;
    self.starView.markComplete = ^(CGFloat score){
        _score = score;
    };
    [self.contentView addSubview:self.starView];
    _text = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(24, 117, SCREEN_W-48, 184)];
    _text.placeholder = @"Please enter your evaluation";
    [self.contentView addSubview:_text];
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-24-90, 318, 90, 35)];
    submit.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    submit.layer.cornerRadius = 5;
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submit];
}

- (void)submitAction {
    NSDictionary *dict = @{@"product_id":self.productID,@"rating":_text,@"rating":[NSString stringWithFormat:@"%ld", _score]};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:REVIEWPRODUCT_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        [MBManager showBriefAlert:@"reviewed!"];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Time out"];
    }];
}

//当父容器的frame发生改变时,会调用该方法,常常用来设置子控件的fram值
-(void)layoutSubviews{
    //这里一定要先调用父类的方法,否则你会很痛苦T_T
    [super layoutSubviews];
    self.viewLine.frame = CGRectMake(0, self.frame.size.height - 1, SCREEN_W, 1);
}

- (void)setModel:(ReviewModel *)model {
    _model = model;
}

@end
