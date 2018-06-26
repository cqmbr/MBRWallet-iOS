//
//  WDHomeLeftMenuView.h
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDHomeLeftMenuView;
@protocol WDHomeLeftMenuViewDelegate <NSObject>

/**
 点击自身
 */
- (void)menuViewClick:(WDHomeLeftMenuView*)menu;

/**
 点击按钮
 */
- (void)menuView:(WDHomeLeftMenuView*)menu clickItem:(NSInteger)index;

@end

@interface WDHomeLeftMenuView : UIView

@property (nonatomic, weak) id<WDHomeLeftMenuViewDelegate> delegate;

/**
 关闭
 */
- (void)closeView;

@end
