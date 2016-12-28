//
//  EditPayInfoView.h
//  SneakerLab
//
//  Created by Jason cao on 2016/10/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"
@interface EditPayInfoView : UIView <UITextFieldDelegate>
{
    UITextField *_creditCardTF;
    UITextField *_codeTF;
    UITextField *_dateTF;
    UITextField *_dateTF2;
    UITextField *_postalCodeTF;

}
@property(nonatomic,strong)PayModel  *model;
@end
