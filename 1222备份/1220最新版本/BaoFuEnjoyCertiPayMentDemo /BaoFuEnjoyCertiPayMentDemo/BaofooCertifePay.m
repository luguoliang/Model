//
//  BaofooCertifePay.m
//  fang
//
//  Created by 路国良 on 16/9/20.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaofooCertifePay.h"
#import "CustomTimerButtom.h"
#import "BF_FangProgressHUD.h"
#import "TextView.h"
@interface BaofooCertifePay()<UITextFieldDelegate>
{
    UIAlertView*_alert;
}
@property (nonatomic, strong) NSLayoutConstraint *alertViewCenterYConstraint;

@property (nonatomic, assign) CGFloat alertViewCenterYOffset;

@end

@interface BaofooCertifePay(){
    CustomTimerButtom* _getmessageButton;
    UILabel*_pnumberLabel;
    UITextField*_textField;
}

@end
@implementation BaofooCertifePay

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor whiteColor];
        _pnumberLabel = [[UILabel alloc] init];
        [self loadView];
        
    }
    return self;
}

-(void)setMobile:(NSString *)mobile{
    _pnumberLabel.text = [NSString stringWithFormat:@"本次交易需要短信确认，校验码已经发送至您的手机%@",mobile];
}
-(void)loadView{
    UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [self addSubview:titleLabel];
    titleLabel.text = @"付款确认";
//    titleLabel.font = [UIFont systemFontOfSize:22];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    titleLabel.textColor = [UIColor colorWithRed:106.0/255.0f green:106.0/255.0f blue:106.0/255.0f alpha:1.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, 1.0)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    lineView.alpha = 0.5;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.1,0,0,0.1});
    {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.frame.size.height)/2, self.frame.size.width - 20, 55)];
    _textField.delegate = self;
    _textField.placeholder = @"请输入短信验证码";
    _textField.layer.borderColor= [UIColor grayColor].CGColor;
    [_textField.layer setBorderWidth:1.0];
    [_textField.layer setBorderColor:color];
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.leftViewMode =  UITextFieldViewModeAlways;
    UIView*rigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 55)];
    _textField.leftView  = rigView;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.clearButtonMode = UITextFieldViewModeNever;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.font = [UIFont systemFontOfSize:18];
    [_textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    {
    _pnumberLabel.frame = CGRectMake(5,  CGRectGetMaxY(lineView.frame), self.frame.size.width - 10, 80);
    _pnumberLabel.textColor = [UIColor colorWithRed:106.0/255.0f green:106.0/255.0f blue:106.0/255.0f alpha:1.0f];
    _pnumberLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_pnumberLabel];
    }
    
    {
    _getmessageButton = [CustomTimerButtom buttonWithType:UIButtonTypeCustom];
//    [_getmessageButton setTintColor:[UIColor colorWithRed:0.0/255.0f green:151.0/255.0f blue:209.0/255.0f alpha:1.0f]];
        [_getmessageButton setTintColor:[UIColor whiteColor]];
    [_getmessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getmessageButton addTarget:self action:@selector(getCode:)forControlEvents:UIControlEventTouchUpInside];
    [_getmessageButton setBackgroundColor:[UIColor colorWithRed:215.0/255.0f green:215.0/255.0f blue:215.0/255.0f alpha:1.0f]];
    [_getmessageButton setTitle:@"获取" forState:UIControlStateNormal];
    
    _getmessageButton.titleLabel.font =[UIFont systemFontOfSize:20.0f];
    _getmessageButton.frame = CGRectMake(0, 0, 80, 55);
    _textField.rightView = _getmessageButton;
    
    [self addSubview:_textField];
    }
    
    {
    UIButton*cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, self.frame.size.height - 55, (self.frame.size.width*0.5)-0.5, 55);
    cancelButton.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:241.0/255.0f blue:243.0/255.0f alpha:1.0];
    [cancelButton setTitleColor:[UIColor colorWithRed:106.0/255.0f green:106.0/255.0f blue:106.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
    

        
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize: 22.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor blackColor];
    [cancelButton setTitleColor:[UIColor colorWithRed:106.0/255.0f green:106.0/255.0f blue:106.0/255.0f alpha:0.2f] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.layer setBorderWidth:0.5];
    [cancelButton.layer setBorderColor:color];
    [self addSubview:cancelButton];
    UIButton*okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(CGRectGetMaxX(cancelButton.frame), self.frame.size.height - 55, (self.frame.size.width*0.5)+0.5, 55);
    okButton.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:241.0/255.0f blue:243.0/255.0f alpha:1.0];
    [okButton setTitleColor:[UIColor colorWithRed:239.0/255.0f green:98.0/255.0f blue:51.0/255.0f alpha:1.0] forState:UIControlStateNormal];
     okButton.titleLabel.font = [UIFont systemFontOfSize: 22.0];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okenButton:) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitleColor:[UIColor colorWithRed:239.0/255.0f green:98.0/255.0f blue:51.0/255.0f alpha:0.2] forState:UIControlStateHighlighted];
    [okButton.layer setBorderWidth:0.5];
    [okButton.layer setBorderColor:color];
    [self addSubview:okButton];
    }
}

-(void)cancelButton:(UIButton*)button{
    [_textField resignFirstResponder];
    [_delegate ClosedCashier];
}
-(void)okenButton:(UIButton*)button{
    if (_textField.text.length) {
        
        if (_textField.text.length < 6) {
             [self showAlertViewWitHMessage:@"请输入6位验证码！"];
        }
        else{
        
        
        if (button.enabled) {
            [_delegate okenButtonWithMessageCode:_textField.text andButton:button];
            button.enabled = NO;
        }
        }
    }
    
    
    
    else{
        [self showAlertViewWitHMessage:@"请输入短信验证码！"];
    }
}


-(void)showAlertViewWitHMessage:(NSString*)message{
   _alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.50 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [_alert show];
}
-(void) performDismiss:(NSTimer *)timer
{
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
}
-(void)valueChange:(UITextField*)text{
    if (text.text.length  > 6) {
        text.text = [text.text substringToIndex:6];
    }
}
-(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

-(void)getCode:(CustomTimerButtom*)btn{
    [btn startTimer];
    [_delegate getMessageCode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect f = self.frame;
    f.origin.y += 100/2;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = f;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
    return YES;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    CGRect f = self.frame;
//    f.origin.y += 100/2;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.frame = f;
//        [self layoutIfNeeded];
//        
//    } completion:^(BOOL finished) {
//    }];
//
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGRect f = self.frame;
    f.origin.y -= 100/2;
    if (h < 500) {
        f.origin.y -= 50;
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        }];

    return YES;
}

-(void)codeStart{
    [_getmessageButton startTimer];
     [_textField becomeFirstResponder];
}
-(void)codeStop{
    [_getmessageButton stopTimer];
}
@end
