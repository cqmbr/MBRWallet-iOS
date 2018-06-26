//
//  WDViewControllerBase.m
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDViewControllerBase.h"
#import "UIButton+MBRElarge.h"

@interface WDViewControllerBase ()

@end

@implementation WDViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WDWhiteColor;
    [self initNavigationView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

// 初始化导航栏
- (void)initNavigationView {
    if ( _navigationView != nil) {
        return;
    }
    
    self.navigationController.navigationBarHidden = YES;
    _navigationView = [UIView new];
    _navigationView.userInteractionEnabled = YES;
    [self.view addSubview:_navigationView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.backgroundColor = [UIColor clearColor];
    _leftButton.hidden = YES;
    [_leftButton setTitleColor:WDColor_2 forState:UIControlStateNormal];
    [_leftButton setTitleColor:WDGrayColor forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setEnlargeEdgeWithTop:10.0 right:30.0 bottom:10.0 left:10.0];
    [_navigationView addSubview:_leftButton];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = WDColor_2;
    _titleLabel.hidden = YES;
    _titleLabel.font = WDFont_13;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navigationView addSubview:_titleLabel];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitleColor:WDColor_2 forState:UIControlStateNormal];
    _rightButton.hidden = YES;
    [_rightButton setTitleColor:WDGrayColor forState:UIControlStateHighlighted];
    _rightButton.titleLabel.font = WDFont_13;
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_rightButton];
    
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(-24);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.height.mas_equalTo(64);
        }else{
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.top.equalTo(self.view.mas_top).offset(0);
            make.height.mas_equalTo(64);
        }
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationView.mas_left).offset(11.0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(_navigationView.mas_top).offset(30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navigationView.mas_left).offset(65.0);
        make.right.equalTo(_navigationView.mas_right).offset(-65.0);
        make.top.equalTo(_navigationView.mas_top).offset(29.5);
        make.height.mas_equalTo(25);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_navigationView.mas_right).offset(0.0);
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.top.equalTo(_navigationView.mas_top).offset(20);
    }];
}

- (void)setNavTitle:(NSString *)title {
    if (_titleLabel != nil) {
        _titleLabel.hidden = NO;
        _titleLabel.text = title;
    }
}

- (void)setLeftBtnTitle:(NSString *)title {
    if (_leftButton != nil) {
        _leftButton.hidden = NO;
        [_leftButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setLeftBtnNomalImage:(UIImage*)nomalImg highlighted:(UIImage*)htImg {
    if (_leftButton != nil) {
        _leftButton.hidden = NO;
        [_leftButton setImage:nomalImg forState:UIControlStateNormal];
        [_leftButton setImage:htImg forState:UIControlStateHighlighted];
    }
}

- (void)setRightBtnTitle:(NSString *)title {
    if (_rightButton != nil) {
        _rightButton.hidden = NO;
        [_rightButton setTitle:title forState:UIControlStateNormal];
    }
}

-(void)setNavTitleColor:(UIColor *)color
{
    if (_titleLabel != nil) {
        [_titleLabel setTextColor:color];
    }
}

- (void)setRightBtnNomalImage:(UIImage*)nomalImg highlighted:(UIImage*)htImg {
    if (_rightButton != nil) {
        _rightButton.hidden = NO;
        [_rightButton setImage:nomalImg forState:UIControlStateNormal];
        [_rightButton setImage:htImg forState:UIControlStateHighlighted];
    }
}

-(void)setLeftBtnTitleColor:(UIColor *)color
{
    if (_leftButton != nil) {
        [_leftButton setTitleColor:color forState:UIControlStateNormal];
    }
}

-(void)setRightBtnTitleColor:(UIColor *)color
{
    if (_rightButton != nil) {
        [_rightButton setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
}

#pragma mark - 只允许竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

/**
 *  点击空白处收回键盘
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - other
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
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

@end
