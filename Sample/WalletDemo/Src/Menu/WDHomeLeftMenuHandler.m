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

@end
