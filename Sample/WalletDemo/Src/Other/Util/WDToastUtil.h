//
//  WDToastUtil.h
//  WalletDemo
//
//  Created by lfl on 2018/6/21.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WDToastUtil : NSObject

+ (void)showLoadingInView:(UIView*)view;

+ (void)hideInView:(UIView*)view;

+ (void)showToast:(NSString*)text InView:(UIView*)view;

+ (void)showError:(NSError*)error view:(UIView*)view;

@end
