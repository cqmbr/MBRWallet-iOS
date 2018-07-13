//
//  WDHomeLeftMenuHandler.m
//  WalletDemo
//
//  Created by lfl on 2018/5/21.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDHomeLeftMenuHandler.h"
#import "WDHomeLeftMenuView.h"
#import "WDTransactionPwdViewController.h"
#import <MBRWallet/MBRWWallet.h>


@interface WDHomeLeftMenuHandler() <WDHomeLeftMenuViewDelegate>

@property (nonatomic, strong) WDHomeLeftMenuView *leftMenuView;

@end

@implementation WDHomeLeftMenuHandler

/**
 显示左侧菜单
 */
- (void)showMenuView {
    if (self.leftMenuView == nil) {
        self.leftMenuView = [[WDHomeLeftMenuView alloc] init];
        self.leftMenuView.delegate = self;
    }
    if (self.leftMenuView.superview == nil) {
        UIView *superView = [UIApplication sharedApplication].delegate.window;
        [superView addSubview:self.leftMenuView];
        [self.leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
    }
    self.leftMenuView.hidden = NO;
}


#pragma mark - WDHomeLeftMenuViewDelegate
- (void)menuViewClick:(WDHomeLeftMenuView*)menu {
    [menu closeView];
}

- (void)menuView:(WDHomeLeftMenuView*)menu clickItem:(NSInteger)index {
    [menu closeView];

    switch (index) {
        case 0: // 设置/修改密码
            [self goToSetPassword];
            break;
        case 1: // 新建账户
            [self goToCreateAccount];
            break;
        case 2: // 导入账户
            [self goToImportAccount];
            break;
        case 3: // 切换账户
            [self changeUser];
            break;
        case 4: // 清除账户
            [self clearUserData];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 页面跳转
// 设置/修改密码
- (void)goToSetPassword {
    UIViewController *dst = [[WDTransactionPwdViewController alloc] init];
    [self.srcVc.navigationController pushViewController:dst animated:YES];
}

// 新建账户
- (void)goToCreateAccount {

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    UIViewController *dst = [board instantiateViewControllerWithIdentifier:@"WDAccountCreateViewController"];
    [self.srcVc.navigationController pushViewController:dst animated:YES];
}

// 导入账户
- (void)goToImportAccount {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    UIViewController *dst = [board instantiateViewControllerWithIdentifier:@"WDAccountImportViewController"];
    [self.srcVc.navigationController pushViewController:dst animated:YES];
}

- (void)changeUser {
    [self inputTextWithTitle:@"输入用户id" callback:^(NSString *uid) {
        NSError *error = nil;
        [MBRWWallet setCurrentWalletWithId:uid error:&error];
        if (error) {
            // WALLET_MODE_NOT_SUPPORTED_CODE,设置不正确，请检查[MBRWWallet setupWithConfig:payConfig];
            // MBRWWalletModel_Muti才能切换用户
            [WDToastUtil showError:error view:self.srcVc.view];
        }
    }];
}

- (void)clearUserData {
    [self inputTextWithTitle:@"确定要清空数据" callback:^(NSString *uid) {
        NSError *error = nil;
        [MBRWWallet clearCurrentWalletWithError:&error];
        if (error) {
            [WDToastUtil showError:error view:self.srcVc.view];
        }
    }];

}

- (void)inputTextWithTitle:(NSString*)title callback:(void(^)(NSString* text))callBack {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        UITextField *tf = alertController.textFields.firstObject;
        NSString *text = tf.text;
        if (text.length > 0) {
            callBack(text);
        }
    }]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    
    [self.srcVc presentViewController:alertController animated:true completion:nil];
    
}

@end
