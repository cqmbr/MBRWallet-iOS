//
//  WDKeyBoard.h
//  MBRUIKit
//
//  Created by liaofulin on 2018/5/14.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDKeyBoardView.h"

// 键盘类型
typedef NS_ENUM(NSInteger, WDKeyBoardType) {
    WDKeyBoardType_Number,       // 数字键盘键
    WDKeyBoardType_Letter      // 字母键盘
};

@class WDKeyBoard;
@protocol WDKeyBoardDelegate <NSObject>

@optional
/**
 点击文本键
 */
- (void)keyBoard:(WDKeyBoard *)keyBoard pressKey:(NSString *)key;

/**
 点击清除键
 */
- (void)keyBoardPressClearKey:(WDKeyBoard *)keyBoard;

/**
 点击确认键
 */
- (void)keyBoardPressComformKey:(WDKeyBoard *)keyBoard;

@end

@interface WDKeyBoard : NSObject

- (instancetype)initWityType:(WDKeyBoardType)type;
+ (instancetype)keyBoardWithType:(WDKeyBoardType)type;

// 确认按钮是否可用，默认YES
@property(nonatomic,assign) BOOL confirmButtonEnabled;

// 是否允许切换键盘,默认YES
@property(nonatomic,assign) BOOL typeShiftEnable;

/**
 键盘view
 */
@property (nonatomic, strong,readonly) WDKeyBoardView *keyboardView;

/**
 键盘类型
 */
@property (nonatomic, assign) WDKeyBoardType keyBoardType;

/**
 输入框view
 */
@property (nonatomic, weak) UIView *sourceView;

@property (nonatomic, weak) id<WDKeyBoardDelegate> delegate;

@end
