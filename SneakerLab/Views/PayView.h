//
//  PayView.h
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayView : UIView <UITextFieldDelegate>
{
    UITextField *_creditCardTF;
    UITextField *_codeTF;
    UITextField *_dateTF;
    UITextField *_postalCodeTF;
}
@end
