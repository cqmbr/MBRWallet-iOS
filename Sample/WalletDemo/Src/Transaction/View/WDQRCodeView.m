//
//  WDQRCodeView.m
//  WalletDemo
//
//  Created by zhanbin on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDQRCodeView.h"
#import "WDUIPrefix.h"
#import "WDQRCodeTool.h"
#import <MBProgressHUD+BWMExtension/MBProgressHUD+BWMExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define WDQRCodeImageW WDFitablePixel(235)

@interface WDQRCodeView()

@property (nonatomic, copy) NSString* accountName;
@property (nonatomic, copy) NSString* address;

@property (nonatomic, weak) UILabel* titleLabel;
@property (nonatomic, weak) UILabel* addressLabel;
@property (nonatomic, weak) UIImageView* qrCodeImageView;

@end


@implementation WDQRCodeView

- (instancetype)initWithAccountName:(NSString *)accountName
                            address:(NSString *)address {
    self = [super init];
    if (self) {
        self.address = address;
        self.accountName = accountName;
        //初始化界面
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //容器view
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = WDWhiteColor;
    [self addSubview:containerView];
    
    UIButton * closeButton = [UIButton new];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(closeButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    
    //title
    NSString *title = [NSString stringWithFormat:@"账户名称： %@",self.accountName];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textColor = WDColor_2;
    titleLabel.font = WDFont_14;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //content
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = self.address;
    addressLabel.textColor = WDColor_5;
    addressLabel.font = WDFont_12;

    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.numberOfLines = 0;
    addressLabel.numberOfLines = 2;
    [containerView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    //qr code ImageView
    UIImageView *qrCodeImageView = [[UIImageView alloc] init];
    UIImage *qrCodeImage=[WDQRCodeTool createQRForString:self.address andSize:WDQRCodeImageW];
    qrCodeImageView.image = qrCodeImage;
    [containerView addSubview:qrCodeImageView];
    self.qrCodeImageView = qrCodeImageView;
    
    UIButton * copyButton = [UIButton new];
    [copyButton setTitle:@"复制地址" forState:UIControlStateNormal];
    copyButton.titleLabel.font = WDFont_13;
    [copyButton setTitleColor:WDWhiteColor forState:UIControlStateNormal];
    [copyButton setBackgroundImage:[self imageWithColor:WDColor_1] forState:(UIControlStateNormal)];
    [copyButton addTarget:self action:@selector(copyButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:copyButton];
    
    //设置约束
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WDFitablePixel(30));
        make.right.equalTo(self).offset(WDFitablePixel(-30));
        make.top.equalTo(self).offset(WDFitablePixel(96));
        make.height.mas_equalTo(WDFitablePixel(510));
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(WDFitablePixel(6));
        make.right.equalTo(containerView).offset(WDFitablePixel(-6));
        make.width.height.mas_equalTo(WDFitablePixel(26));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(WDFitablePixel(100));
        make.left.equalTo(containerView).offset(10);
        make.right.equalTo(containerView).offset(-10);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(WDFitablePixel(24));
        make.left.equalTo(containerView).offset(10);
        make.right.equalTo(containerView).offset(-10);
    }];
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(WDFitablePixel(21));
        make.width.height.mas_equalTo(WDQRCodeImageW);
        make.centerX.equalTo(containerView);
    }];
    
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(containerView);
        make.height.mas_equalTo(WDFitablePixel(60));
    }];
}

- (void)copyButtonTap:(UIButton *)sender{
    
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.address;

    [MBProgressHUD bwm_showTitle:@"复制成功" toView:self hideAfter:1.5];
}

- (void)closeButtonTap:(UIButton *)sender{
    
    [self removeFromSuperview];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(window);
    }];
}

- (UIImage*)imageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
