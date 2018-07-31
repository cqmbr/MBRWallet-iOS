//
//  WDTransactionPwdViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDTransactionPwdViewController.h"
#import "WDCommonTextField.h"
#import <MBProgressHUD+BWMExtension/MBProgressHUD+BWMExtension.h>
#import <MBRWalletNetworking/MBRAccount.h>
#import <MBRWallet/MBRWWallet.h>
#import "WDSecurityTextField.h"

@interface WDTransactionPwdViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView* scorllView;

// 旧密码
@property (nonatomic, strong) WDCommonTextField *moreTextField;
// 密码
@property (nonatomic, strong) WDCommonTextField *pwdTextField;
// 重复输入密码
@property (nonatomic, strong) WDCommonTextField *repeatPwdTextField;
// 密码提示
@property (nonatomic, strong) WDCommonTextField *pwdHindTextField;

//是否是修改密码 NO：设置交易密码  YES：修改交易密码
@property (nonatomic, assign) BOOL isResetPwd;

@end

@implementation WDTransactionPwdViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isResetPwd = [MBRWWallet haveSetPassword];
    [self setupNav];
    [self setupViews];
}

// 导航栏
- (void)setupNav {
    [self setNavTitle:@"交易密码"];
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
}

- (void)setupViews{
    
    // 确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = WDFont_13;
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:13]];
    [confirmBtn setTitleColor:WDColor_3 forState:UIControlStateSelected];
    [confirmBtn setTitleColor:WDWhiteColor forState:UIControlStateNormal];
    [confirmBtn setTitle:@"设置交易密码" forState:UIControlStateNormal];
    if (_isResetPwd) {
        [confirmBtn setTitle:@"修改交易密码" forState:UIControlStateNormal];
    }
    confirmBtn.backgroundColor = WDColor_1;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@60);
    }];
    
    // 页面容器
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scorllView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom).offset(0);
        make.bottom.equalTo(confirmBtn.mas_top);
    }];
    //隐藏键盘
    UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [scrollView addGestureRecognizer:scrollViewTap];
    
    // 设置输入框
    if (_isResetPwd) {
        [self setupModifyPwdInputViews];
    } else {
        [self setupSetPwdInputViews];
    }
}

- (void)setupSetPwdInputViews {
    
    // 输入密码
    WDCommonTextField *pwdTextField = [[WDSecurityTextField alloc] init];
    pwdTextField.placeholder = @"请输入密码";
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    [self.scorllView addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scorllView).offset(40);
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        make.height.mas_equalTo(52);
    }];
    
    // 重复密码
    WDCommonTextField *repeatPwdTextField = [[WDSecurityTextField alloc]init];
    repeatPwdTextField.placeholder = @"请再次输入密码";
    repeatPwdTextField.delegate = self;
    repeatPwdTextField.secureTextEntry = YES;
    [self.scorllView addSubview:repeatPwdTextField];
    self.repeatPwdTextField = repeatPwdTextField;
    [repeatPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTextField.mas_bottom).offset(24);
        make.left.right.height.equalTo(pwdTextField);
    }];
    
    // 密码提示
    WDCommonTextField *pwdHindTextField = [[WDCommonTextField alloc]init];
    pwdHindTextField.placeholder = @"请输入密码提示";
    pwdHindTextField.delegate = self;
    [self.scorllView  addSubview:pwdHindTextField];
    self.pwdHindTextField = pwdHindTextField;
    [pwdHindTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repeatPwdTextField.mas_bottom).offset(24);
        make.left.right.height.equalTo(pwdTextField);
    }];
}

- (void)setupModifyPwdInputViews {
    
    // 旧密码
    WDCommonTextField *pwdHindTextField2 = [[WDSecurityTextField alloc] init];
    pwdHindTextField2.placeholder = @"请输入旧密码";
    pwdHindTextField2.delegate = self;
    [self.scorllView addSubview:pwdHindTextField2];
    self.moreTextField = pwdHindTextField2;
    [_moreTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scorllView).offset(40);
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        make.height.mas_equalTo(52);
    }];

    // 输入新密码
    WDCommonTextField *pwdTextField = [[WDSecurityTextField alloc] init];
    pwdTextField.placeholder = @"请输入新密码";
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    [self.scorllView addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    [pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdHindTextField2.mas_bottom).offset(24);
        make.left.right.height.equalTo(pwdHindTextField2);
    }];
    
    // 重复密码
    WDCommonTextField *repeatPwdTextField = [[WDSecurityTextField alloc]init];
    repeatPwdTextField.placeholder = @"请再次输入密码";
    repeatPwdTextField.delegate = self;
    repeatPwdTextField.secureTextEntry = YES;
    [self.scorllView addSubview:repeatPwdTextField];
    self.repeatPwdTextField = repeatPwdTextField;
    [repeatPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTextField.mas_bottom).offset(24);
        make.left.right.height.equalTo(pwdTextField);
    }];
    
    // 密码提示
    WDCommonTextField *pwdHindTextField = [[WDCommonTextField alloc]init];
    pwdHindTextField.placeholder = @"请输入密码提示";
    pwdHindTextField.delegate = self;
    [self.scorllView  addSubview:pwdHindTextField];
    self.pwdHindTextField = pwdHindTextField;
    [pwdHindTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repeatPwdTextField.mas_bottom).offset(24);
        make.left.right.height.equalTo(pwdTextField);
    }];
}

#pragma mark - action
- (void)confirmAction:(UIButton *)sender {

    if (_isResetPwd) {
        [self doModifyPassward];
    }else{
        [self doSetPassword];
    }
}

#pragma mark - 业务逻辑
// 设置密码
- (void)doSetPassword {
    
    NSString* _tx1 = self.pwdTextField.text;
    NSString* _tx2 = self.repeatPwdTextField.text;
    NSString* _tx3 = self.pwdHindTextField.text;
    
    // 输入校验
    if(ISNULLSTR(_tx1) || _tx1.length < 8){
        [MBProgressHUD bwm_showTitle:@"密码至少8位" toView:self.view hideAfter:2];
        return;
    }
    
    if(![_tx1 isEqual:_tx2]){
        [MBProgressHUD bwm_showTitle:@"两次输入密码不一致" toView:self.view hideAfter:2];
        return;
    }
    
    if (ISNULLSTR(_tx3)) {
        [MBProgressHUD bwm_showTitle:@"请输入密码提示" toView:self.view hideAfter:2];
        return;
    }
    if ([_tx2 isEqualToString:_tx3]) {
        [MBProgressHUD bwm_showTitle:@"密码提示不能与密码相同" toView:self.view hideAfter:2];
        return;
    }
    
    // 设置密码
    NSError *error = nil;
    [MBRWWallet setPassword:_tx1 error:&error];
    if (error) {
        // 请根据错误码做相应提示
        [MBProgressHUD bwm_showTitle:[error mbrw_errorCode] toView:self.view hideAfter:2];
    } else {
        [MBRWWallet setPasswardHint:_tx3];
        [MBProgressHUD bwm_showTitle:@"密码设置成功" toView:self.view hideAfter:2];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2];
    }
}

// 修改密码
- (void)doModifyPassward {
    NSString* _tx0 = self.moreTextField.text;
    NSString* _tx1 = self.pwdTextField.text;
    NSString* _tx2 = self.repeatPwdTextField.text;
    NSString* _tx3 = self.pwdHindTextField.text;
    
    // 输入校验
    if(ISNULLSTR(_tx0)){
        [MBProgressHUD bwm_showTitle:@"请输入旧密码" toView:self.view hideAfter:2];
        return;
    }
    if(ISNULLSTR(_tx1)){
        [MBProgressHUD bwm_showTitle:@"请输入新密码" toView:self.view hideAfter:2];
        return;
    }
    if(ISNULLSTR(_tx1) || _tx1.length < 8){
        [MBProgressHUD bwm_showTitle:@"密码至少8位" toView:self.view hideAfter:2];
        return;
    }
    if(![_tx1 isEqual:_tx2]){
        [MBProgressHUD bwm_showTitle:@"两次输入密码不一致" toView:self.view hideAfter:2];
        return;
    }
    if (ISNULLSTR(_tx3)) {
        [MBProgressHUD bwm_showTitle:@"请输入密码提示" toView:self.view hideAfter:2];
        return;
    }
    if ([_tx2 isEqualToString:_tx3]) {
        [MBProgressHUD bwm_showTitle:@"密码提示不能与密码相同" toView:self.view hideAfter:2];
        return;
    }
    if ([_tx1 isEqualToString:_tx0]) {
        [MBProgressHUD bwm_showTitle:@"新旧密码不能一样" toView:self.view hideAfter:2];
        return;
    }
    
    // 修改密码
    [MBRWWallet modifyPasswordWithOldPwd:_tx0 newPwd:_tx1 success:^{
        [MBRWWallet setPasswardHint:_tx3];
        [MBProgressHUD bwm_showTitle:@"密码修改成功" toView:self.view hideAfter:2];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2];
        
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:[error mbrw_errorCode] toView:self.view hideAfter:2];
    }];
    
}

- (void)scrollTap:(id)sender {
    [self.view endEditing:YES];
}

//点击完成按钮键盘消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
