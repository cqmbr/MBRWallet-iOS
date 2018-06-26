//
//  WDAccountCreateViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDAccountCreateViewController.h"
#import <MBProgressHUD+BWMExtension.h>
#import "WDTransactionPwdViewController.h"
#import <MBProgressHUD+BWMExtension.h>
#import <MBRWallet/MBRWWallet.h>

@interface WDAccountCreateViewController() <
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *accountName; // 账户名
@property (weak, nonatomic) IBOutlet UIButton *btnCreate; // 创建按钮

@end

@implementation WDAccountCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"创建"];
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
    
    [_accountName setReturnKeyType:UIReturnKeyDone];
    _accountName.autocorrectionType = UITextAutocorrectionTypeNo;
    _accountName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _accountName.leftViewMode = UITextFieldViewModeAlways;
}

// 创建按钮点击
-(IBAction)createAction:(UIButton *)sender {
    
    // 是否设置密码校验
    if (![MBRWWallet haveSetPassword]) {
        [MBProgressHUD bwm_showTitle:@"您还没有设置密码，请先设置密码" toView:self.view hideAfter:2];
        [self performSelector:@selector(goToSetPassword) withObject:nil afterDelay:2];
        return;
    }

    // 账户名不能为空
    NSString *accountName = _accountName.text;
    if (ISNULLSTR(accountName)) {
        [MBProgressHUD bwm_showTitle:@"请输入账户名" toView:self.view hideAfter:3];
        return;
    }
    
    // 密码输入
    // 密码输入
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
       [self doCreateAccountWithName:_accountName.text pwd:pwd];
        
    }];
}

// 跳转到设置密码界面
- (void)goToSetPassword {
    WDTransactionPwdViewController *transPWD = [[WDTransactionPwdViewController alloc] init];
    [self.navigationController pushViewController:transPWD animated:YES];
}

// 创建账户逻辑
- (void)doCreateAccountWithName:(NSString*)name pwd:(NSString*)pwd {
    [_btnCreate setEnabled:NO];
    [MBRWWallet addNewAccountWithName:name pwd:pwd success:^(MBRWAccount *account) {
        
        [_btnCreate setEnabled:YES];
        [MBProgressHUD bwm_showTitle:@"创建账户成功" toView:self.view hideAfter:3];
        [self popAction:3];
        
    } failure:^(NSError *error) {
        [_btnCreate setEnabled:YES];
        [WDToastUtil showError:error view:self.view];
    }];
}

-(void)popAction:(NSTimeInterval)timerInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timerInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_accountName resignFirstResponder];
    return YES;
}

@end
