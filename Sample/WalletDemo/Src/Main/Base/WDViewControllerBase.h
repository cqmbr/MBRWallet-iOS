//
//  WDViewControllerBase.h
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDUIPrefix.h"

@interface WDViewControllerBase : UIViewController

// 自定义导航栏view
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

/**
 设置导航栏标题
 */
- (void)setNavTitle:(NSString *)title;

/**
 设置左按钮文本
 */
- (void)setLeftBtnTitle:(NSString *)title;

/**
 设置左按钮图片
 */
- (void)setLeftBtnNomalImage:(UIImage*)nomalImg highlighted:(UIImage*)htImg;

/**
 设置右按钮文本
 */
- (void)setRightBtnTitle:(NSString *)title;

/**
 设置右按钮图片
 */
- (void)setRightBtnNomalImage:(UIImage*)nomalImg highlighted:(UIImage*)htImg;

/**
 设置左按钮文本颜色
 */

- (void)setLeftBtnTitleColor:(UIColor *)color;

/**
 设置右按钮文本颜色
 */

- (void)setRightBtnTitleColor:(UIColor *)color;

/**
 设置标题文本颜色
 */

- (void)setNavTitleColor:(UIColor *)color;


/**
 左按钮点击
 */
- (void)leftAction;

/**
 右按钮点击
 */
- (void)rightAction;

#pragma mark - other
- (void)inputTextWithTitle:(NSString*)title callback:(void(^)(NSString* text))callBack;

@end
