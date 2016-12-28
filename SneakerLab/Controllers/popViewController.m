//
//  popViewController.m
//  弹框
//
//  Created by kr on 2016/10/31.
//  Copyright © 2016年 凯如科技. All rights reserved.
//

#import "popViewController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
@interface popViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)UIView *backView;
//名称
@property (nonatomic,strong)UILabel *nameLabel;
//显示个数
@property (nonatomic,strong)UILabel *numberLabel;
//下拉按钮
@property (nonatomic,strong)UIButton *downBtn;
//确认按钮
@property (nonatomic,strong)UIButton *doneBtn;
//取消按钮
@property (nonatomic,strong)UIButton *cancelBtn;
//toolBar
@property (nonatomic,strong)UIToolbar *pickerDateToolbar;
//pickerView
@property (nonatomic,strong)UIPickerView *pickerView;
//数据源
@property (nonatomic,strong)NSMutableArray *dataArray;
//选中行的数
@property (nonatomic,strong)NSString *selectStr;
@end

@implementation popViewController


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self  CreatUI];
    }
    return self;
    
}
-(void)CreatUI{

    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _dataArray = [[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil] mutableCopy];
    
    [self initLayoutView];
}
- (void)initLayoutView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.numberLabel];
    [self.backView addSubview:self.downBtn];
    [self.backView addSubview:self.doneBtn];
    [self.backView addSubview:self.cancelBtn];
    [self.downBtn addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)showPickerView
{
    [self addSubview:self.pickerDateToolbar];
    [self addSubview:self.pickerView];
    self.pickerDateToolbar.hidden=NO;
    self.pickerView.hidden=NO;
   
    
    
    
    
    
    
    
    
    
    
    
    
   
}
- (void)toolBarCanelClick{
    self.pickerDateToolbar.hidden = YES;
    self.pickerView.hidden = YES;
    self.numberLabel.text = @"0";
  
}
- (void)toolBarDoneClick{
    self.pickerDateToolbar.hidden = YES;
    self.pickerView.hidden = YES;
    self.numberLabel.text = self.selectStr;
}
- (void)doneAction
{
    [self removeFromSuperview];
    if (self.block) {
        self.block(self.numberLabel.text);
    }
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction
{
    [self removeFromSuperview];
   // [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - 代理
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectStr=_dataArray[row];
}

#pragma mark - 懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width-150,150)];
        _backView.center = self.center;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _backView.frame.size.width,20)];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"Quantity:";
    }
    return _nameLabel;
}
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, _backView.frame.size.width-40, 20)];
        _numberLabel.backgroundColor = [UIColor whiteColor];
        _numberLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _numberLabel.layer.borderWidth = 0.5;
        _numberLabel.text=@"0";
    }
    return _numberLabel;
}
- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downBtn.backgroundColor = [UIColor redColor];
        _downBtn.frame = CGRectMake(_numberLabel.frame.origin.x+_numberLabel.frame.size.width, 40, 20, 20);
    }
    return _downBtn;
}
- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        _doneBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(10,_numberLabel.frame.origin.y+_numberLabel.frame.size.height+10,_backView.frame.size.width-20, 20);
        _doneBtn.backgroundColor = [UIColor yellowColor];
        [_doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
    }
    return _doneBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(10,_doneBtn.frame.origin.y+_doneBtn.frame.size.height+10,_backView.frame.size.width-20, 20);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}
- (UIToolbar *)pickerDateToolbar
{
    if (!_pickerDateToolbar) {
        _pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,Main_Screen_Height-200,Main_Screen_Width, 44)];
        _pickerDateToolbar.userInteractionEnabled=YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.frame = CGRectMake(0, 5, 40, 35);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.layer.cornerRadius = 2;
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(toolBarCanelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.backgroundColor = [UIColor clearColor];
        chooseBtn.frame = CGRectMake(0,200, 40, 35);
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        chooseBtn.layer.cornerRadius = 2;
        chooseBtn.layer.masksToBounds = YES;
        [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chooseBtn setTitle:@"完成" forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(toolBarDoneClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        centerSpace.width = 70;
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
        _pickerDateToolbar.items=@[leftItem,centerSpace,rightItem];
        _pickerDateToolbar.backgroundColor = [UIColor blueColor];
    }
    return _pickerDateToolbar;
}
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        // 选择框
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,Main_Screen_Height-300,Main_Screen_Width,150)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        // 显示选中框
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}
@end
