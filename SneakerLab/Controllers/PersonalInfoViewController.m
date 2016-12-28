//
//  PersonalInfoViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "SetPersonInfoViewController.h"
#import "ZHPickView.h"

@interface PersonalInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIView *bottom;
@property (nonatomic, strong) UIImageView *img;

@end

@implementation PersonalInfoViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Personal Info";
    SET_NAV_MIDDLE
    self.view.backgroundColor = COLOR_FA;
    [self setBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPersonInfo];
}

- (void)recreateView {
    for (id view in self.view.subviews) {
        [view removeFromSuperview];
    }
    UIView *line1 = [self lineWithTop:20 isLong:YES];
    [self.view addSubview:line1];
    self.headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 21, SCREEN_W, 68.5)];
    _headerBtn.selected = NO;
    [_headerBtn addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerBtn];
    UILabel *profile = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 25, 100, 18.5)];
    profile.textAlignment = 0;
    profile.text = @"Profile Photo";
    profile.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    profile.textColor = COLOR_3;
    [_headerBtn addSubview:profile];
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-86.5, 9, 50.5, 50.5)];
    _img.layer.cornerRadius = 25.25;
    _img.layer.masksToBounds = YES;
    [_headerBtn addSubview:_img];
    [_img sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:headImg];
    _headerBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-26, 28.5, 6.5, 11)];
    right.image = [UIImage imageNamed:@"setting-jinru"];
    right.contentMode = UIViewContentModeCenter;
    [_headerBtn addSubview:right];
    UIView *line2 = [self lineWithTop:89.5 isLong:NO];
    [self.view addSubview:line2];
    UIButton *button2 = [self viewWithTitle:@"Name" text:self.name target:@selector(button2Action)];
    button2.frame = CGRectMake(0, 90.5, SCREEN_W, 43.5);
    [self.view addSubview:button2];
    UIView *line3 = [self lineWithTop:133.5 isLong:NO];
    [self.view addSubview:line3];
    UIButton *button3 = [self viewWithTitle:@"Sex" text:self.sex target:@selector(button3Action)];
    button3.frame = CGRectMake(0, 134.5, SCREEN_W, 43.5);
    [self.view addSubview:button3];
    UIView *line4 = [self lineWithTop:178 isLong:NO];
    [self.view addSubview:line4];
    UIButton *button4 = [self viewWithTitle:@"Age" text:self.age target:@selector(button4Action)];
    button4.frame = CGRectMake(0, 179, SCREEN_W, 43.5);
    [self.view addSubview:button4];
    UIView *line5 = [self lineWithTop:222.5 isLong:NO];
    [self.view addSubview:line5];
    UIButton *button5 = [self viewWithTitle:@"Email" text:self.email target:@selector(button5Action)];
    button5.frame = CGRectMake(0, 223.5, SCREEN_W, 43.5);
    [self.view addSubview:button5];
    UIView *line6 = [self lineWithTop:267 isLong:NO];
    [self.view addSubview:line6];
    UIButton *button6 = [self viewWithTitle:@"Tel" text:self.tel target:@selector(button6Action)];
    button6.frame = CGRectMake(0, 268, SCREEN_W, 43.5);
    [self.view addSubview:button6];
    UIView *line7 = [self lineWithTop:311.5 isLong:YES];
    [self.view addSubview:line7];
    /*
    UIView *line7 = [self lineWithTop:311.5 isLong:NO];
    [self.view addSubview:line7];
    UIButton *button7 = [self viewWithTitle:@"City" text:self.city target:@selector(button7Action)];
    button7.frame = CGRectMake(0, 312.5, SCREEN_W, 43.5);
    [self.view addSubview:button7];
    UIView *line8 = [self lineWithTop:356 isLong:YES];
    [self.view addSubview:line8];
     */
}

- (void)loadPersonInfo {
    [PHPNetwork PHPNetworkWithParam:nil andUrl:PERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject valueForKey:@"status_code"] integerValue] == 0) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            self.name = [NSString stringWithFormat:@"%@ %@", [data valueForKey:@"firstname"], [data valueForKey:@"lastname"]];
            if ([[data valueForKey:@"sex"] integerValue] == 0) {
                self.sex = @"Secret";
            }else if ([[data valueForKey:@"sex"] integerValue] == 1) {
                self.sex = @"Male";
            }else{
                self.sex = @"Female";
            }
            self.age = [data valueForKey:@"age"];
            self.email = [data valueForKey:@"email"];
            self.imageUrl = [data valueForKey:@"avatar"];
            self.tel = [data valueForKey:@"telephone"];
            [self recreateView];
        }
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Error"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIView *)lineWithTop:(CGFloat)top isLong:(BOOL)is {
    CGFloat width;
    UIView *view;
    if (is) {
        width = SCREEN_W;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, top, width, 1)];
        view.backgroundColor = COLOR_D;
    }else{
        width = SCREEN_W - 17.5;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, top, SCREEN_W, 1)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(17.5, 0, SCREEN_W-17.5, 1)];
        bview.backgroundColor = COLOR_D;
        [view addSubview:bview];
    }
    return view;
}

- (UIButton *)viewWithTitle:(NSString *)title text:(NSString *)text target:(SEL)selector {
    UIButton *button = [[UIButton alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 11.5, 100, 18.5)];
    [button addSubview:label];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    label.textColor = COLOR_3;
    label.text = title;
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 19.5-6.5, 16, 6.5, 11)];
    right.image = [UIImage imageNamed:@"setting-jinru"];
    right.contentMode = UIViewContentModeCenter;
    [button addSubview:right];
    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 36-300, 12, 300, 18.5)];
    value.text = text;
    value.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    value.textColor = COLOR_9;
    value.textAlignment = 2;
    [button addSubview:value];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

- (void)button1Action {
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

- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        _bottom.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    }];
    _headerBtn.selected = NO;
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
            _img.image = [UIImage imageWithData:imageData];
            [MBManager showBriefAlert:@"You have successfully modified customers!"];
            [self dismiss];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"Something error"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)button2Action {
    SetPersonInfoViewController *vc = [[SetPersonInfoViewController alloc] init];
    vc.headline = @"Name";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)button3Action {
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:@[@"Secret",@"Male",@"Female"] title:@"Sex"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *sex){
        NSString *num;
        if ([sex isEqualToString:@"Secret"]) {
            num = @"0";
        }else if ([sex isEqualToString:@"Male"]){
            num = @"1";
        }else{
            num = @"2";
        }
        NSDictionary *dic = @{@"firstname":@"",@"lastname":@"",@"phone":@"",@"sex":num,@"age":@"",@"birthday":@""};
        [PHPNetwork PHPNetworkWithParam:dic andUrl:CHANGEPERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject valueForKey:@"status_code"] integerValue]==0) {
                [MBManager showBriefAlert:@"Success"];
                self.sex = sex;
                [self recreateView];
            }
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            [MBManager showBriefAlert:@"Fail"];
        }];
    };
}

- (void)button4Action {
    ZHPickView *pickView = [[ZHPickView alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 101; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    NSArray *array = [arr copy];
    [pickView setDataViewWithItem:array title:@"Age"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *age){
        NSDictionary *dic = @{@"firstname":@"",@"lastname":@"",@"phone":@"",@"sex":@"",@"birthday":@"",@"age":age};
        [PHPNetwork PHPNetworkWithParam:dic andUrl:CHANGEPERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([[responseObject valueForKey:@"status_code"] integerValue]==0) {
                [MBManager showBriefAlert:@"Success"];
                self.age = age;
                [self recreateView];
            }
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            [MBManager showBriefAlert:@"Fail"];
        }];
    };
}

- (void)button5Action {
    SetPersonInfoViewController *vc = [[SetPersonInfoViewController alloc] init];
    vc.headline = @"Email";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)button6Action {
    SetPersonInfoViewController *vc = [[SetPersonInfoViewController alloc] init];
    vc.headline = @"Tel";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
