//
//  WDKeyBoard.m
//  MBRUIKit
//
//  Created by liaofulin on 2018/5/14.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDKeyBoard.h"
#import "WDLetterKeyBoardView.h"
#import "WDNumberKeyBoardView.h"

@interface WDKeyBoard() <WDKeyBoardViewDelegate>
@end

@implementation WDKeyBoard

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWityType:(WDKeyBoardType)type {
    if (self=[super init]) {
        self.keyBoardType = type;
        self.confirmButtonEnabled = YES;
        self.typeShiftEnable = YES;
    }
    return self;
}

+ (instancetype)keyBoardWithType:(WDKeyBoardType)type {
    return [[WDKeyBoard alloc] initWityType:type];
}

/**
 设置键盘类型
 */
- (void)setKeyBoardType:(WDKeyBoardType)keyBoardType {
    if (_keyBoardType == keyBoardType && _keyboardView != nil) {
        return;
    }
    
    _keyBoardType = keyBoardType;
    _keyboardView.delegate = nil;
    _keyboardView = [self viewWithType:keyBoardType];
    _keyboardView.delegate = self;
    [self resetInputView];
}

/**
 设置sourceView
 */
- (void)setSourceView:(UIView *)sourceView {
    __weak typeof(sourceView) weakV = sourceView;
    _sourceView = weakV;
    [self resetInputView];
}

- (void)setConfirmButtonEnabled:(BOOL)confirmButtonEnabled {
    _confirmButtonEnabled = confirmButtonEnabled;
    self.keyboardView.confirmButtonEnabled = confirmButtonEnabled;
}

- (void)setTypeShiftEnable:(BOOL)typeShiftEnable {
    _typeShiftEnable = typeShiftEnable;
    self.keyboardView.typeShiftFlag = typeShiftEnable;
}

#pragma mark - WDKeyBoardViewDelegate
/**
 点击文本键
 */
- (void)keyBoardView:(WDKeyBoardView *)keyBoard pressKey:(NSString *)key {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoard:pressKey:)]) {
        [self.delegate keyBoard:self pressKey:key];
    }
}

/**
 点击清除键
 */
- (void)keyBoardViewPressClearKey:(WDKeyBoardView *)keyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardPressClearKey:)]) {
        [self.delegate keyBoardPressClearKey:self];
    }
}

/**
 点击确认键
 */
- (void)keyBoardViewPressComformKey:(WDKeyBoardView *)keyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardPressComformKey:)]) {
        [self.delegate keyBoardPressComformKey:self];
    }
}

/**
 点击键盘类型键
 */
- (void)keyBoardViewPressShiftTypeKey:(WDKeyBoardView *)keyBoard {
    if (self.keyBoardType == WDKeyBoardType_Letter) {
        self.keyBoardType = WDKeyBoardType_Number;
    } else if (self.keyBoardType == WDKeyBoardType_Number) {
        self.keyBoardType = WDKeyBoardType_Letter;
    }
}

#pragma mark - helper
// 创建具体键盘view
- (WDKeyBoardView*)viewWithType:(WDKeyBoardType)type {
    WDKeyBoardView *view = nil;
    switch (type) {
        case WDKeyBoardType_Letter:
            view = [[WDLetterKeyBoardView alloc] init];
            break;
            
        case WDKeyBoardType_Number:
            view = [[WDNumberKeyBoardView alloc] init];
            break;
        default:
            break;
    }
    
    view.typeShiftFlag = self.typeShiftEnable;
    view.confirmButtonEnabled = self.confirmButtonEnabled;
    
    return view;
}

// 重设输入框view的inputview
- (void)resetInputView {
    if (_sourceView == nil || _keyboardView == nil) {
        return;
    }
    
    if ([_sourceView isKindOfClass:[UITextView class]]) {
        UITextView *tv = (UITextView*)_sourceView;
        tv.inputView = _keyboardView;
        [tv reloadInputViews];
    } else if ([_sourceView isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField*)_sourceView;
        tf.inputView = _keyboardView;
        [tf reloadInputViews];
    }
}

@end
