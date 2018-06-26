//
//  WDFeeAdjustView.h
//  WalletDemo
//
//  Created by zhanbin on 2018/4/11.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDFeeAdjustView : UIView

@property (nonatomic, strong) NSDecimalNumber * fee;
@property (nonatomic, strong) NSDecimalNumber * minValue;
@property (nonatomic, strong) NSDecimalNumber * maxValue;

- (double)getChoiceFee;

- (NSString *)getChoiceFeeString;

@end
