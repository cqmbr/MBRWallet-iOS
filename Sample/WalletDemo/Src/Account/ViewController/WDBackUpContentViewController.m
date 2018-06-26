//
//  WDBackUpContentViewController.m
//  WalletDemo
//
//  Created by sean on 2018/4/9.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBackUpContentViewController.h"
#import "WDBackUpConfirmViewController.h"
#import <MBRWallet/MBRWWallet.h>

@interface WDBackUpContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mnemonicWords;
@property (weak, nonatomic) IBOutlet UILabel *backUpTips;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation WDBackUpContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];

    NSError *error = nil;
    NSString *mnemonic = [MBRWWallet getMnemonic:self.account.accountAddress pwd:self.tmpPwd error:&error];
    self.mnemonicWords.text = mnemonic;
    if (error) {
        [WDToastUtil showError:error view:nil];
    }
}

-(void)setupView {
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
    [self setNavTitle:@"备份"];
    _backUpTips.text = @"-请备份你的助记词，它可以恢复你的钱包账户。";
    [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
}

- (IBAction)nextAction:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Balance" bundle:nil];
    WDBackUpConfirmViewController *confirmVC = [board instantiateViewControllerWithIdentifier:@"WDBackUpConfirmViewController"];
    confirmVC.mnemonicString = _mnemonicWords.text;
    confirmVC.address        = self.account.accountAddress;
    confirmVC.tmpPwd = self.tmpPwd;
    [self.navigationController pushViewController:confirmVC animated:YES];
}


@end
