//
//  WDKeyBoardView.h
//  MBRUIKit
//
//  Created by liaofulin on 2018/5/14.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDKeyBoardView;
@protocol WDKeyBoardViewDelegate <NSObject>

@optional
/**
 点击文本键
 */
- (void)keyBoardView:(WDKeyBoardView *)keyBoard pressKey:(NSString *)key;

/**
 点击清除键
 */
- (void)keyBoardViewPressClearKey:(WDKeyBoardView *)keyBoard;

/**
 点击确认键
 */
- (void)keyBoardViewPressComformKey:(WDKeyBoardView *)keyBoard;

/**
 点击键盘类型键
 */
- (void)keyBoardViewPressShiftTypeKey:(WDKeyBoardView *)keyBoard;

@end

@interface WDKeyBoardView : UIView

// 是否允许切换键盘
@property (nonatomic, assign) BOOL typeShiftFlag;
@property(nonatomic,assign) BOOL confirmButtonEnabled;
@property (nonatomic, weak) id<WDKeyBoardViewDelegate> delegate;

@end
