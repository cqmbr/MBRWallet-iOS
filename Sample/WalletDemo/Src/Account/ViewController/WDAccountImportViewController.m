//
//  WDAccountImportViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDAccountImportViewController.h"
#import "WDTransactionPwdViewController.h"
#import <MBRWallet/MBRWWallet.h>
#import "WDCommonTextField.h"

// 导入类型
typedef enum : NSUInteger {
    IMPORT_BY_MNEMONIC,
    IMPORT_BY_KEYSTORE,
    
} actionTypes;

@interface WDAccountImportViewController ()<UITextFieldDelegate>

// 顶部tab切换栏
@property (weak, nonatomic) IBOutlet UIButton *btnMnemonic;
@property (weak, nonatomic) IBOutlet UIButton *btnKeyStore;
@property (weak, nonatomic) IBOutlet UIView *slidView;
@property (weak, nonatomic) IBOutlet UIView *tabView;

// 输入框
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextView *TFworlds;
@property (strong, nonatomic) UITextField *TFpassword;
@property (weak, nonatomic) IBOutlet UITextField *addressNameTF;

// 导入按钮
@property (weak, nonatomic) IBOutlet UIButton *btnImport;

@property (assign,nonatomic) NSInteger actionType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfPwdTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfPwdHeightConstrain;

@end

@implementation WDAccountImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"导入"];
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];

    [self setContentView];
    [self tapAction:self.btnMnemonic];
}

- (void)setContentView {

    // keystory密码输入框
    _TFpassword = [[WDCommonTextField alloc]init];
    [_passwordView addSubview:_TFpassword];
    [_TFpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(_passwordView).offset(0);
    }];
    _TFpassword.delegate = self;
    [_TFpassword setSecureTextEntry:YES];
    _TFpassword.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _TFpassword.leftViewMode = UITextFieldViewModeAlways;
    _TFpassword.layer.borderColor = WDColor_1.CGColor;
    _TFpassword.layer.borderWidth = 1;
    _TFpassword.placeholder = @"请输入keystory密码";

    // 地址名输入框
    _addressNameTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _addressNameTF.leftViewMode = UITextFieldViewModeAlways;
    _addressNameTF.placeholder = @"请输入账户名称";
    
    // keystory/助记词输入框
    _TFworlds.layer.borderColor = WDColor_1.CGColor;
    _TFworlds.layer.borderWidth = 1;
}

// topBar切换点击
- (IBAction)tapAction:(id)sender {
    
    NSInteger tags = [sender tag];
    if (tags == 1) { // 助记词
        _actionType = IMPORT_BY_MNEMONIC;
        [_btnMnemonic setTitleColor:WDColor_3 forState:UIControlStateNormal];
        [_btnKeyStore setTitleColor:WDColor_2 forState:UIControlStateNormal];
        [_slidView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tabView).offset(32);
            make.size.mas_equalTo(CGSizeMake(114, 2));
            make.centerX.mas_equalTo(_btnMnemonic);
        }];
        
        self.tfPwdTopConstrain.constant = 0;
        self.tfPwdHeightConstrain.constant = 0;
        self.TFpassword.hidden = YES;
        
    }else{ // keystore
        _actionType = IMPORT_BY_KEYSTORE;
        [_btnMnemonic setTitleColor:WDColor_2 forState:UIControlStateNormal];
        [_btnKeyStore setTitleColor:WDColor_3 forState:UIControlStateNormal];
        [_slidView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tabView).offset(32);
            make.size.mas_equalTo(CGSizeMake(114, 2));
            make.centerX.mas_equalTo(_btnKeyStore);
        }];
        
        self.tfPwdTopConstrain.constant = 24;
        self.tfPwdHeightConstrain.constant = 52;
        self.TFpassword.hidden = NO;
    }
}

// 导入按钮点击
- (IBAction)importAction:(id)sender {
    NSString *words = _TFworlds.text;
    NSString *address = _addressNameTF.text;
    NSString *pwd     = _TFpassword.text;
    
    // 是否设置密码校验
    if (![MBRWWallet haveSetPassword]) {
        [MBProgressHUD bwm_showTitle:@"您还没有设置密码，请先设置密码" toView:self.view hideAfter:2];
        [self performSelector:@selector(goToSetPassword) withObject:nil afterDelay:2];
        return;
    }
    
    // 输入校验
    if (ISNULLSTR(address)) {
        [MBProgressHUD bwm_showTitle:@"请输入账户名称" toView:self.view hideAfter:2];
        return;
    }
    
    if (_actionType == IMPORT_BY_MNEMONIC) {
        if (ISNULLSTR(words)) {
            [MBProgressHUD bwm_showTitle:@"请输入助记词" toView:self.view hideAfter:3];
            return;
        }
        
    }else{
        if (ISNULLSTR(words)) {
            [MBProgressHUD bwm_showTitle:@"请输入keystore" toView:self.view hideAfter:2];
            return;
        }
        
        if (ISNULLSTR(pwd)) {
            [MBProgressHUD bwm_showTitle:@"请输入keystore密码" toView:self.view hideAfter:2];
            return;
        }
    }
    
    // 密码输入
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        NSString *words = _TFworlds.text;
        NSString *address = _addressNameTF.text;
        NSString *pwdKs     = _TFpassword.text;
        
        if (_actionType == IMPORT_BY_MNEMONIC) {
            [self doImportByMnemontics:words pwd:pwd name:address];
        } else if (_actionType == IMPORT_BY_KEYSTORE) {
            [self doImportByKeystore:words pwd:pwd pwdKs:pwdKs name:address];
        }
        
    }];
}

// 跳转到设置密码界面
- (void)goToSetPassword {
    WDTransactionPwdViewController *transPWD = [[WDTransactionPwdViewController alloc] init];
    [self.navigationController pushViewController:transPWD animated:YES];
}

// 助记词导入
- (void)doImportByMnemontics:(NSString*)mnemonic pwd:(NSString*)pwd name:(NSString*)name {
    
    // 助记词单词之间用空格分割 @" "
    NSString *mneWords = mnemonic;
    mneWords = [mneWords stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    __block NSArray *sortArr = [mneWords componentsSeparatedByString:@" "];
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (int i = 0; i < sortArr.count; i++) {
        NSString *str = sortArr[i];
        if (!ISNULLSTR(str)) {
            [tmpArr addObject:str];
        }
    }
    NSString * mmnemonics = [tmpArr componentsJoinedByString:@" "];
    
    // 助记词导入方式创建账户
    [MBRWWallet importAccountByMnemonic:mmnemonics pwd:pwd name:name success:^(MBRWAccount *account) {
        [MBProgressHUD bwm_showTitle:@"账户导入成功" toView:self.view hideAfter:2];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2];
    } failure:^(NSError *error) {
        [WDToastUtil showError:error view:self.view];
    }];
}

// keystore导入
- (void)doImportByKeystore:(NSString*)keystore pwd:(NSString*)pwd pwdKs:(NSString*)pwdKs name:(NSString*)name {
    
    [WDToastUtil showLoadingInView:nil];
    [MBRWWallet importAccountByKeystore:keystore pwd:pwd pwdKS:pwdKs name:name success:^(MBRWAccount *account) {
        [WDToastUtil hideInView:nil];
        [MBProgressHUD bwm_showTitle:@"账户导入成功" toView:self.view hideAfter:2];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:2];
        
    } failure:^(NSError *error) {
        [WDToastUtil hideInView:nil];
        [WDToastUtil showError:error view:self.view];
    }];
}

-(void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
