//
//  WDTransferViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDTransferViewController.h"
#import "WDCommonTextField.h"
#import "WDFeeAdjustView.h"
#import "WDQRCodeScanViewController.h"
#import <math.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBRWallet/MBRWallet.h>

@interface WDTransferViewController ()<UITextFieldDelegate,WDQRCodeScanViewControllerDelegate>

// 矿工费
@property (nonatomic, weak) WDFeeAdjustView *feeView;
// 转入地址
@property (nonatomic, weak) WDCommonTextField *addressTextField;
// 转出数量
@property (nonatomic, weak) WDCommonTextField* amountTextField;
// 备注
@property (nonatomic, weak) WDCommonTextField* memoTextField;

@end

@implementation WDTransferViewController

#pragma mark - 初始页面
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupViews];
}

// 导航栏
- (void)setupNav {
    [self setNavTitle:@"转账"];
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
    [self setRightBtnNomalImage:[UIImage imageNamed:@"scan_dark"] highlighted:nil];
}

- (void)setupViews {
    
    //coin icon
    UIImageView *coinIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coins_default"]];
    [coinIconImageView sd_setImageWithURL:[NSURL URLWithString:self.coinData.avatarUrl] placeholderImage:[UIImage imageNamed:@"coins_default"]];
    [self.view addSubview:coinIconImageView];
    [coinIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(WDFitablePixel(20));
        make.width.height.mas_equalTo(WDFitablePixel(32));
        make.centerX.equalTo(self.view);
    }];
    
    //coid label
    UILabel *coinLabel = [UILabel new];
    coinLabel.text = self.coinData.abbr;
    coinLabel.textColor = WDColor_5;
    coinLabel.font = WDFont_12;

    [self.view addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinIconImageView.mas_bottom).offset(WDFitablePixel(10));
        make.centerX.equalTo(self.view);
    }];
    
    //Address TextField
    WDCommonTextField *addressTextField = [[WDCommonTextField alloc] init];
    addressTextField.placeholder = @"收款人地址";
    addressTextField.keyboardType = UIKeyboardTypeAlphabet;
    addressTextField.delegate = self;
    if (self.receiverAddress!=nil) {
        addressTextField.text = self.receiverAddress;
    }
    [self.view addSubview:addressTextField];
    self.addressTextField = addressTextField;
    [addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinLabel.mas_bottom).offset(WDFitablePixel(24));
        make.left.equalTo(self.view).offset(WDFitablePixel(38));
        make.right.equalTo(self.view).offset(WDFitablePixel(-38));
        make.height.mas_equalTo(WDFitablePixel(52));
    }];
    
    //amount TextField
    WDCommonTextField *amountTextField = [[WDCommonTextField alloc] init];
    amountTextField.placeholder = @"数量";
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    amountTextField.delegate = self;
    self.amountTextField = amountTextField;
    [self.view addSubview:amountTextField];
    [amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTextField.mas_bottom).offset(WDFitablePixel(24));
        make.left.equalTo(self.view).offset(WDFitablePixel(38));
        make.right.equalTo(self.view).offset(WDFitablePixel(-38));
        make.height.mas_equalTo(WDFitablePixel(52));
    }];
    
    //fee TextField
    WDCommonTextField *feeTextField = [[WDCommonTextField alloc] init];
    feeTextField.placeholder = @"矿工费";
    feeTextField.enabled = NO;
    [self.view addSubview:feeTextField];
    [feeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountTextField.mas_bottom).offset(WDFitablePixel(24));
        make.left.equalTo(self.view).offset(WDFitablePixel(38));
        make.right.equalTo(self.view).offset(WDFitablePixel(-38));
        make.height.mas_equalTo(WDFitablePixel(52));
    }];
    
    WDFeeAdjustView *feeView = [[WDFeeAdjustView alloc] init];
    feeView.fee =  [MBRWWallet defaultEthWithCoinId:self.coinData.coinId];
    feeView.minValue = [MBRWWallet minEthWithCoinId:self.coinData.coinId];
    feeView.maxValue = [MBRWWallet maxEthWithCoinId:self.coinData.coinId];

    [self.view addSubview:feeView];
    self.feeView = feeView;
    [feeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(feeTextField).offset(WDFitablePixel(-12));
        make.height.mas_equalTo(30);
        make.centerY.equalTo(feeTextField);
    }];
    
    //memo TextField
    WDCommonTextField *memoTextField = [[WDCommonTextField alloc] init];
    memoTextField.placeholder = @"备注";
    memoTextField.delegate = self;
    self.memoTextField = memoTextField;
    [self.view addSubview:memoTextField];
    [memoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feeTextField.mas_bottom).offset(WDFitablePixel(24));
        make.left.equalTo(self.view).offset(WDFitablePixel(38));
        make.right.equalTo(self.view).offset(WDFitablePixel(-38));
        make.height.mas_equalTo(WDFitablePixel(52));
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = WDFont_13;
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:@"Lato-Semibold" size:13]];
    [confirmBtn setTitleColor:WDColor_3 forState:UIControlStateSelected];
    [confirmBtn setTitleColor:WDWhiteColor forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.backgroundColor = WDColor_1;
    [confirmBtn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(WDFitablePixel(60));
    }];
}

/**
 *  点击空白处收回键盘
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Action
// 导航栏右按钮点击，扫描二维码获取地址
- (void)rightAction {
    WDQRCodeScanViewController *controller = [[WDQRCodeScanViewController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

// #pragma mark - WDQRCodeScanViewControllerDelegate
-(void)qRCodeScanViewController:(UIViewController *)controller value:(NSString *)value {
    self.addressTextField.text = value;
}


// 点击确认按钮
- (void)confirmButtonAction:(UIButton *)sender {
    
    // 输入校验
    if(self.addressTextField.text.length < 1){
        [MBProgressHUD bwm_showTitle:@"请输入收款人地址" toView:self.view hideAfter:2];
        return;
    }
    if(self.amountTextField.text.length < 1){
        [MBProgressHUD bwm_showTitle:@"请输入转出数量" toView:self.view hideAfter:2];
        return;
    }
    if ([self.amountTextField.text doubleValue]<=0) {
        [MBProgressHUD bwm_showTitle:@"转出数量需大于0" toView:self.view hideAfter:2];
        return;
    }
    
    // 交易密码输入
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        [self doTransaction:pwd];
    }];
}

/**
 转账业务逻辑
 */
- (void)doTransaction:(NSString*)pwd {
    
    [WDToastUtil showLoadingInView:nil];
    
    MBRWTransferParam *param = [MBRWTransferParam new];
    param.coin = self.coinData;
    param.addressFrom = [self.account.accountAddress lowercaseString];
    param.addressTo = [self.addressTextField.text lowercaseString];
    param.amountStr = self.amountTextField.text;
    param.feeStr = [self.feeView getChoiceFeeString];
    param.memo = self.memoTextField.text;
    param.coinId = param.coin.coinId;
    
    [MBRWWallet transferWithPrarm:param password:pwd success:^{
        [WDToastUtil hideInView:nil];
        [MBProgressHUD bwm_showTitle:@"转账成功，交易已广播" toView:self.navigationController.view hideAfter:2];
    } failure:^(NSError *error) {
        [WDToastUtil hideInView:nil];
        [WDToastUtil showError:error view:nil];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}


@end
