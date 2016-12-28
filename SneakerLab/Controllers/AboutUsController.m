//
//  AboutUsController.m
//  caowei
//
//  Created by Jason cao on 2016/9/27.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@"xx"
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    self.title = @"About Us";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x - 50, 40, 100, 100) imageName:@"80x80"];
    image.layer.cornerRadius = 50;
    image.layer.masksToBounds = YES;
    image.image = iconImg;
    [self.view addSubview:image];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 40, CGRectGetMaxY(image.frame)+20, 80, 20) text:@"V1.0.2" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(label1.frame)+20, SCREEN_W - 40, SCREEN_H-250) text:@"SneakerLab is where you can make your perfect sneaker purchase at.SneakerLab offers you not only the hottest sneakers but also the exclusive ones.Heads up real Sneakerheads, wherever you go and whenever you want seize an outrageously cool sneaker, in your mobile phone there always waits SneakerLab. Enjoy yourself at SneakerLab!\n\nYour SneakerLab Your SuperShop" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    label2.numberOfLines = 0;
    label2.textAlignment = 0;
    [label2 sizeToFit];
    [self.view addSubview:label2];
#if PREDUPLICATE==0
    label2.text = @"SneakerLab is where you can make your perfect sneaker purchase at.SneakerLab offers you not only the hottest sneakers but also the exclusive ones.Heads up real Sneakerheads, wherever you go and whenever you want seize an outrageously cool sneaker, in your mobile phone there always waits SneakerLab. Enjoy yourself at SneakerLab!\n\nYour SneakerLab Your SuperShop";
#elif PREDUPLICATE==1
    label2.text = @"Ivanka Jingle is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at Ivanka Jingle!";
#elif PREDUPLICATE==2
    label2.text = @"Center Piece is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at Center Piece!";
#elif PREDUPLICATE==3
    label2.text = @"Exclusive is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at Exclusive!";
#elif PREDUPLICATE==4
    label2.text = @"Hilary Tear is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at Hilary Tear!";
#elif PREDUPLICATE==5
    label2.text = @"Sneaker Crunch is where you can make your perfect sneaker purchase at.SneakerLab offers you not only the hottest sneakers but also the exclusive ones.Heads up real Sneakerheads, wherever you go and whenever you want seize an outrageously cool sneaker, in your mobile phone there always waits SneakerLab. Enjoy yourself at Sneaker Crunch!\n\nYour SneakerLab Your SuperShop";
#elif PREDUPLICATE==6
    label2.text = @"STYL is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at STYL!";
#elif PREDUPLICATE==7
    label2.text = @"Wanted Sole is the best place for you to shop from. We offer not only great items but also secure fast good services.\n Happy shopping at Wanted Sole!";
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
