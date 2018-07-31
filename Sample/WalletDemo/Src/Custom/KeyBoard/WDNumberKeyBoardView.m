//
//  WDNumberKeyBoardView.m
//  MBRUIKit
//
//  Created by liaofulin on 2018/5/14.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDNumberKeyBoardView.h"
#import <Masonry/Masonry.h>
#import "WDUIPrefix.h"
#import "NSArray+WDMas.h"
#import "UIImage+WD.h"

// 键盘高度
#define WD_KEYBOARD_HEIGHT ((WD_IsPhoneX) ? (217 + 34) : 217)
#define WD_KEYBOARD_WIDTH WDScreenW

@interface WDNumberKeyBoardView()

@property (nonatomic, strong) NSMutableArray* keyButtonArray;

@property (nonatomic, strong) UIButton* confirmButton;
@property (nonatomic, strong) UIButton *typeShiftBtn;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation WDNumberKeyBoardView

- (NSMutableArray *)keyButtonArray {
    if (!_keyButtonArray) {
        _keyButtonArray = [NSMutableArray array];
    }
    return _keyButtonArray;
}

- (void)setConfirmButtonEnabled:(BOOL)confirmButtonEnabled {
    [super setConfirmButtonEnabled:confirmButtonEnabled];
    self.confirmButton.enabled = confirmButtonEnabled;
}

- (void)setTypeShiftFlag:(BOOL)typeShiftFlag {
    [super setTypeShiftFlag:typeShiftFlag];
    self.typeShiftBtn.hidden = !typeShiftFlag;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, WD_KEYBOARD_WIDTH, WD_KEYBOARD_HEIGHT)]) {
        
        [self setupViews];
        
    }
    return self;
}

#pragma mark -
#pragma mark - 初始化UI
//初始化UI
- (void)setupViews {
    
    self.backgroundColor = WDColor_363A44;
    UIView *bgView = [UIView new];
    bgView.backgroundColor = WDColor_1E1C2A;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    CGFloat bottomOffset = WD_IsPhoneX ? 34 : 0;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(@(-bottomOffset));
    }];
    
    // 添加按钮
    [self creatButtons];
}

#pragma mark -
#pragma mark - 创建按钮
- (void)creatButtons{
    
    NSArray *numberArray = [self createRandomWithNumber:12];
    // 添加按钮
    for (int i = 0 ; i < 16; i++) {
        UIButton * bt = [UIButton new];
        
        bt.tag = i;
        [bt setBackgroundImage:[UIImage wd_imageWithColor:WDColor_363A44] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage wd_imageWithColor:WDColor_34A9FF] forState:(UIControlStateHighlighted)];
        [bt setBackgroundImage:[UIImage wd_imageWithColor:WDColor_363A44] forState:(UIControlStateDisabled)];
        if (i<12){
            NSNumber *number = numberArray[i];
            //10以内的数字才显示
            if (number.intValue < 10) {
                NSString *title = number.stringValue;
                [bt setTitle:title forState:UIControlStateNormal];
            } else {
                bt.enabled = NO;
            }
        } else {
            bt.enabled = NO;
        }
        [bt setTitleColor:WDWhiteColor forState:UIControlStateNormal];
        bt.titleLabel.font = WDFont_20;
        [bt addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:bt];
        [self.keyButtonArray addObject:bt];
        if (i==13) {
            //添加删除按钮
            UIButton * delButton = [UIButton new];
            [delButton setBackgroundImage:[UIImage imageNamed:@"wd_keyboard_backspace"] forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(delButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.bgView addSubview:delButton];
            [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(21);
                make.center.equalTo(bt);
            }];
        }
        
        if (i==12) {
            //键盘类型切换按钮
            [self.bgView addSubview:self.typeShiftBtn];
            [self.typeShiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(bt);
            }];
//            self.typeShiftBtn.hidden = YES;
        }
    }
    //九宫格自动布局
    [self.keyButtonArray mas_distributeSudokuViewsWithFixedLineSpacing:1 fixedInteritemSpacing:1 warpCount:4 topSpacing:0 bottomSpacing:2 leadSpacing:0 tailSpacing:0];
    
    //添加确认按钮
    UIButton * confirmButton = [UIButton new];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = WDFont_13;
    [confirmButton setBackgroundImage:[UIImage wd_imageWithColor:WDColor_34A9FF] forState:(UIControlStateNormal)];
    [confirmButton setBackgroundImage:[UIImage wd_imageWithColor:WDColor_363A44] forState:(UIControlStateDisabled)];
    [confirmButton addTarget:self action:@selector(confirmButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:confirmButton];
    self.confirmButton = confirmButton;
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        UIButton *lastButton = [self.keyButtonArray lastObject];
        make.top.bottom.right.equalTo(lastButton);
        make.width.equalTo(lastButton).multipliedBy(2).offset(1);
    }];
    self.confirmButtonEnabled = YES;
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
        [bt setTitle:@"ABC" forState:UIControlStateNormal];
        _typeShiftBtn = bt;
    }
    return _typeShiftBtn;
}

#pragma mark - 按钮点击事件
- (void)buttonTap:(UIButton *)sender{
    NSString *text = sender.titleLabel.text;
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

- (void)typeShiftBtnTap:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(keyBoardViewPressShiftTypeKey:)]) {
        [self.delegate keyBoardViewPressShiftTypeKey:self];
    }
}


- (NSArray *)createRandomWithNumber:(unsigned int)capacity {
    
    NSMutableArray *numberArray = [NSMutableArray array];
    for (int i = 0 ; i < capacity; i++) {
        int j = arc4random_uniform(capacity);
        
        NSNumber *number = [[NSNumber alloc] initWithInt:j];
        if ([numberArray containsObject:number]) {
            i--;
            continue;
        }
        [numberArray addObject:number];
    }
    return [numberArray copy];
}

@end
