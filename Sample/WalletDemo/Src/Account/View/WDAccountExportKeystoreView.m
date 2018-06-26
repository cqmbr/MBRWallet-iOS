//
//  WDAccountExportKeystoreView.m
//  WalletDemo
//
//  Created by sean on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDAccountExportKeystoreView.h"
#import <Masonry/Masonry.h>
#import "WDResource.h"
#import "WDToastUtil.h"

@interface WDAccountExportKeystoreView()
@property(strong,nonatomic)NSString *keystore;
@property(strong,nonatomic)UITextView *kv;
@end

@implementation WDAccountExportKeystoreView


-(void)showKeyStore:(NSString*)ks {
    self.keystore = ks;
    [self showKeyStoreView];
}

- (void)showKeyStoreView {
    UIView *keyStoreView = [[UIView alloc]init];
    [keyStoreView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:keyStoreView];
    [keyStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.with.height.equalTo(self);
    }];
    
    //标题
    UILabel *titileLaber = [[UILabel alloc]init];
    titileLaber.text = @"keystore内容";
    titileLaber.font = [UIFont systemFontOfSize:13];
    titileLaber.textAlignment = NSTextAlignmentCenter;
    [keyStoreView addSubview:titileLaber];
    [titileLaber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.top.equalTo(@64);
        make.right.equalTo(@-50);
        make.height.equalTo(@20);
    }];
  
    _kv = [[UITextView alloc]init];
    [_kv setEditable:NO];
    [keyStoreView addSubview:_kv];
    [_kv setText:_keystore];
    [_kv.layer setBorderColor:[UIColor grayColor].CGColor];
    [_kv.layer setBorderWidth:1];
    [_kv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19);
        make.right.equalTo(@-19);
        make.top.equalTo(titileLaber.mas_bottom).offset(60);
        make.bottom.equalTo(@-120);
    }];
    
    UIButton * copyButton = [UIButton new];
    [copyButton setTitle:@"复制keystore" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyButton setBackgroundColor:WDColor_1];
    [copyButton addTarget:self action:@selector(copyButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [keyStoreView addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_kv);
        make.top.equalTo(_kv.mas_bottom);
        make.height.equalTo(@40);
    }];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [keyStoreView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(@68);
        make.width.height.equalTo(@26);
        
    }];
    
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)closeAction {
    [self removeFromSuperview];
}

- (void)copyButtonTap:(UIButton *)sender {
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _kv.text;
    [WDToastUtil showToast:@"已复制到剪贴板" InView:nil];
    
}

@end
