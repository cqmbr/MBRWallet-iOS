//
//  WDLetterKeyBoardView.m
//  MBRUIKit
//
//  Created by liaofulin on 2018/5/14.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDLetterKeyBoardView.h"
#import "NSArray+WDMas.h"
#import <Masonry/Masonry.h>
#import "WDUIPrefix.h"
#import "UIImage+WD.h"


// 键盘高度
#define KEYBOARD_HEIGHT ((WD_IsPhoneX) ? (253 + 34) : 253)
#define KEYBOARD_WIDTH WDScreenW
#define KEYBOARD_LETTER_W 30
#define KEYBOARD_BTN_H 36


@interface WDLetterKeyBoardView()

// 大写
@property (nonatomic, assign) BOOL isUper;

// 字母按钮
@property (nonatomic, strong) NSMutableArray* letterButtonArray;

// 功能键按钮
@property (nonatomic, strong) UIButton *uperShiftBtn;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *typeShiftBtn;
@property (nonatomic, strong) UIButton* confirmBtn;
@property (nonatomic, strong) UIButton* spaceBtn;

@end

@implementation WDLetterKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, KEYBOARD_WIDTH, KEYBOARD_HEIGHT)]) {
        [self setupViews];
    }
    return self;
}

- (void)setConfirmButtonEnabled:(BOOL)confirmButtonEnabled {
    [super setConfirmButtonEnabled:confirmButtonEnabled];
    self.confirmBtn.enabled = confirmButtonEnabled;
}

- (void)setTypeShiftFlag:(BOOL)typeShiftFlag {
    [super setTypeShiftFlag:typeShiftFlag];
    self.typeShiftBtn.hidden = !typeShiftFlag;
}

#pragma mark -
#pragma mark - 初始化UI
//初始化UI
- (void)setupViews {
    self.backgroundColor = WDColor_363A44;
    [self creatLetterButtons];
    [self createOtherBtns];
}

#pragma mark -
#pragma mark - 创建按钮
- (void)creatLetterButtons{
    
    NSArray<NSString*> *letterArray = [self getRandomLetterArray];
    NSInteger count = letterArray.count;
    // 添加按钮
    for (int i = 0 ; i < count; i++) {
        UIButton * bt = [self letterBtn:letterArray[i]];
        bt.tag = i;
        [self addSubview:bt];
        [self.letterButtonArray addObject:bt];
    }
    
    CGFloat btnW = KEYBOARD_LETTER_W;
    CGFloat btnH = KEYBOARD_BTN_H;
    CGFloat yOffset = 21;
    CGFloat margin = 15;
    CGFloat xPadding = (KEYBOARD_WIDTH-(10*btnW)-2*margin)/9;
    CGFloat xOffset = 21;
    // 第一行10个
    for (int i=0; i<10; i++) {
        xOffset = margin+i*(xPadding+btnW);
        UIButton *btn = self.letterButtonArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(yOffset));
            make.left.equalTo(@(xOffset));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
    }
    
    // 第二行9个
    yOffset = 84;
    margin = 37;
    xPadding = (KEYBOARD_WIDTH-(9*btnW)-2*margin)/8;
    for (int i=10; i<19; i++) {
        xOffset = margin+(i-10)*(xPadding+btnW);
        UIButton *btn = self.letterButtonArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(yOffset));
            make.left.equalTo(@(xOffset));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
    }
    
    // 第三行7个
    yOffset = 147;
    margin = 65;
    xPadding = (KEYBOARD_WIDTH-(7*btnW)-2*margin)/6;
    for (int i=19; i<count; i++) {
        xOffset = margin+(i-19)*(xPadding+btnW);
        UIButton *btn = self.letterButtonArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(yOffset));
            make.left.equalTo(@(xOffset));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
    }

}

- (void)createOtherBtns {
    
    CGFloat bottomOffset = WD_IsPhoneX ? 34 : 0;
    
    //添加确认按钮
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.equalTo(@(-12-bottomOffset));
        make.size.mas_equalTo(CGSizeMake(90, KEYBOARD_BTN_H));
    }];


    //添加清除按钮
    [self addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.bottom.equalTo(@(-70-bottomOffset));
        make.size.mas_equalTo(CGSizeMake(KEYBOARD_LETTER_W, KEYBOARD_BTN_H));
        
    }];

    //大小写切换按钮
    [self addSubview:self.uperShiftBtn];
    [self.uperShiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.equalTo(@(-70-bottomOffset));
        make.size.mas_equalTo(CGSizeMake(KEYBOARD_LETTER_W, KEYBOARD_BTN_H));
    }];

    //键盘类型切换按钮
    [self addSubview:self.typeShiftBtn];
    [self.typeShiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@(-12-bottomOffset));
        make.size.mas_equalTo(CGSizeMake(70, KEYBOARD_BTN_H));
    }];
    
    UIButton *btn = [UIButton new];
    [btn setBackgroundImage:[UIImage wd_imageWithColor:UIColorHex(#3E4556)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(spaceBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.confirmBtn);
        make.left.equalTo(self.typeShiftBtn.mas_right).offset(20);
        make.right.equalTo(self.confirmBtn.mas_left).offset(-20);
    }];
    self.spaceBtn = btn;
    
}

#pragma mark - getter/setter
- (NSMutableArray *)letterButtonArray {
    if (!_letterButtonArray) {
        _letterButtonArray = [NSMutableArray array];
    }
    return _letterButtonArray;
}

- (UIButton*)uperShiftBtn {
    if (!_uperShiftBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"wd_keyboard_shift"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(upShiftBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        _uperShiftBtn = btn;
    }
    return _uperShiftBtn;
}

- (UIButton*)clearBtn {
    if (!_clearBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"wd_keyboard_backspace"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(delButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn = btn;
    }
    return _clearBtn;
}

- (UIButton*)typeShiftBtn {
    if (!_typeShiftBtn) {
        UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setBackgroundImage:nil forState:UIControlStateNormal];
        [bt setBackgroundImage:nil forState:UIControlStateDisabled];
        [bt setBackgroundImage:[UIImage wd_imageWithColor:WDColor_34A9FF] forState:UIControlStateHighlighted];
        [bt setTitleColor:WDWhiteColor forState:UIControlStateNormal];
        bt.titleLabel.font = WDFont_20;
        [bt addTarget:self action:@selector(typeShiftBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [bt setTitle:@"123" forState:UIControlStateNormal];
        _typeShiftBtn = bt;
    }
    return _typeShiftBtn;
}

- (UIButton*)confirmBtn {
    if (!_confirmBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        btn.titleLabel.font = WDFont_13;
        [btn setBackgroundImage:[UIImage wd_imageWithColor:WDColor_34A9FF] forState:(UIControlStateNormal)];
        [btn setBackgroundImage:[UIImage wd_imageWithColor:WDColor_363A44] forState:(UIControlStateDisabled)];
        [btn addTarget:self action:@selector(confirmButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

#pragma mark - 按钮点击事件
- (void)spaceBtnTap:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:pressKey:)]) {
        [self.delegate keyBoardView:self pressKey:@" "];
    }
}

- (void)letterBtnTap:(UIButton *)sender{
    NSString *text = [sender titleForState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:pressKey:)]) {
        [self.delegate keyBoardView:self pressKey:text];
    }
}

- (void)delButtonTap:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(keyBoardViewPressClearKey:)]) {
        [self.delegate keyBoardViewPressClearKey:self];
    }
}

- (void)confirmButtonTap:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(keyBoardViewPressComformKey:)]) {
        [self.delegate keyBoardViewPressComformKey:self];
    }
}

- (void)upShiftBtnTap:(UIButton *)sender{
    self.isUper = !self.isUper;
    for (UIButton *btn in self.letterButtonArray) {
        NSString *text = [btn titleForState:UIControlStateNormal];
        text = self.isUper?[text uppercaseString]:[text lowercaseString];
        [btn setTitle:text forState:UIControlStateNormal];
    }
}

- (void)typeShiftBtnTap:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(keyBoardViewPressShiftTypeKey:)]) {
        [self.delegate keyBoardViewPressShiftTypeKey:self];
    }
}


#pragma mark - helper
- (UIButton*)letterBtn:(NSString*)title {
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setBackgroundImage:nil forState:UIControlStateNormal];
    [bt setBackgroundImage:nil forState:UIControlStateDisabled];
    [bt setBackgroundImage:[UIImage wd_imageWithColor:WDColor_34A9FF] forState:UIControlStateHighlighted];
    [bt setTitleColor:WDWhiteColor forState:UIControlStateNormal];
    bt.titleLabel.font = WDFont_20;
    [bt addTarget:self action:@selector(letterBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:title forState:UIControlStateNormal];
    return bt;
}

- (NSMutableArray*)getRandomLetterArray {
    NSString *text = @"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
    NSArray *arr = [text componentsSeparatedByString:@","];
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}

@end
