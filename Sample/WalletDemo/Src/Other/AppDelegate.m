//
//  AppDelegate.m
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "AppDelegate.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <MBRWallet/MBRWWallet.h>
#import "WDConfigManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 钱包环境
    [self setWalletEnvironment];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setRootController];
    [self.window makeKeyAndVisible];

    //修改SDWebImage的accept属性为*/*，服务端不接受image/*
    [SDWebImageDownloader.sharedDownloader setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    return YES;
}

- (void)setWalletEnvironment {
    MBRWWalletConfig *payConfig = [MBRWWalletConfig new];
    payConfig.channel = [WDConfigManager channel];
    payConfig.apiHost = [WDConfigManager apiHost];
    payConfig.privateKey = [WDConfigManager privateKey];
    payConfig.merchantId = [WDConfigManager merchantId];
    payConfig.walletMode = MBRWWalletModel_Muti;
    
    [MBRWWallet setupWithConfig:payConfig];
    [MBRWWallet setCurrentWalletWithId:@"12345" error:nil];

}

// 设置窗口根控制器
- (void)setRootController {

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Balance" bundle:nil];
    UIViewController *vc = [board instantiateViewControllerWithIdentifier:@"WDBlanceViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}


@end
