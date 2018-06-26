//
//  WDCommonTextField.m
//  WalletDemo
//
//  Created by zhanbin on 2018/4/7.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDCommonTextField.h"
#import "WDUIPrefix.h"

@implementation WDCommonTextField

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupStyle];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        [self setupStyle];
    }
    return self;
}

- (void)setupStyle {
    self.layer.borderColor = WD_TextBorderColor.CGColor;
    self.layer.borderWidth = 1;
    [self setReturnKeyType:UIReturnKeyDone];
    self.font = WDFont_14;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    //设置文本坐偏移量，默认紧挨左边框，与leftViewMode配合使用
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.leftViewMode = UITextFieldViewModeAlways;

}

@end
