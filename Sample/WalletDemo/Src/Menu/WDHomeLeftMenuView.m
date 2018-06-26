//
//  WDHomeLeftMenuView.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDHomeLeftMenuView.h"
#import "WDUIPrefix.h"

@interface WDHomeLeftMenuView()
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, strong) NSMutableArray *btns;
@end

@implementation WDHomeLeftMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf)]];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    // 容器
    UIView *leftView = [UIView new];
    leftView.backgroundColor = WDColor_1;
    leftView.userInteractionEnabled = YES;
    [self addSubview:leftView];
    self.leftView = leftView;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(280.0/375);
    }];
    
    // 图片
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_white"]];
    [leftView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView).offset(42);
        make.top.equalTo(leftView).offset(42);
        make.size.mas_equalTo(CGSizeMake(84, 30));
    }];
    
    NSString *locStr1 = @"设置/修改密码";
    NSString *locStr2 = @"新建账户";
    NSString *locStr3 = @"导入账户";
    
    // 按钮
    UIButton *btn1 = [self btnWithImg:[UIImage imageNamed:@"guard_white"] title:locStr1];
    UIButton *btn2 = [self btnWithImg:[UIImage imageNamed:@"create_white"] title:locStr2];
    UIButton *btn3 = [self btnWithImg:[UIImage imageNamed:@"import_white"] title:locStr3];
    [leftView addSubview:btn1];
    [leftView addSubview:btn2];
    [leftView addSubview:btn3];
    self.btns = [NSMutableArray array];
    [self.btns addObject:btn1];
    [self.btns addObject:btn2];
    [self.btns addObject:btn3];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView).offset(42);
        make.right.equalTo(leftView).offset(-10);
        make.height.mas_equalTo(30);
        make.top.equalTo(leftView).offset(131);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(btn1);
        make.top.equalTo(btn1.mas_bottom).offset(32);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(btn1);
        make.top.equalTo(btn2.mas_bottom).offset(32);
    }];
}

- (UIButton*)btnWithImg:(UIImage*)image title:(NSString*)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = WDFont_12;
    [btn setTitleColor:WDWhiteColor forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clickSelf {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuViewClick:)]) {
        [self.delegate menuViewClick:self];
    }
}

- (void)clickBtn:(UIButton*)btn {
    NSInteger index = [self.btns indexOfObject:btn];
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:clickItem:)]) {
        [self.delegate menuView:self clickItem:index];
    }
}

/**
 关闭
 */
- (void)closeView {
    [self removeFromSuperview];
}

@end
