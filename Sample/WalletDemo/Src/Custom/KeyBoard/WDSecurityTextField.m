//
//  WDSecurityTextField.m
//  MBRUIKit
//
//  Created by lfl on 2018/5/15.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDSecurityTextField.h"
#import "WDKeyBoard.h"


@interface WDSecurityTextField() <WDKeyBoardDelegate>
@property (nonatomic, strong) WDKeyBoard* securityKeyBoard;
@end

@implementation WDSecurityTextField

- (instancetype)init {
    if (self = [super init]) {
        [self setupSecurityBoard];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        [self setupSecurityBoard];
    }
    return self;
}

- (void)setupSecurityBoard {
    WDKeyBoard *securityKeyBoard = [WDKeyBoard keyBoardWithType:WDKeyBoardType_Letter];
    securityKeyBoard.sourceView = self;
    securityKeyBoard.delegate = self;
    self.securityKeyBoard = securityKeyBoard;
}

#pragma mark - WDKeyBoardDelegate
/**
 点击文本键
 */
- (void)keyBoard:(WDKeyBoard *)keyBoard pressKey:(NSString *)key {
    [self inputString:key];
}

/**
 点击清除键
 */
- (void)keyBoardPressClearKey:(WDKeyBoard *)keyBoard {
    [self deleteBackward];
}

/**
 点击确认键
 */
- (void)keyBoardPressComformKey:(WDKeyBoard *)keyBoard {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        [self.delegate textFieldShouldReturn:self];
    }
}

#pragma mark - Private Events
- (void)inputString:(NSString *)string
{
    UITextField * tmp = self;
    if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        NSRange range = NSMakeRange(tmp.text.length, 1);
        BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:string];
        if (ret)
        {
            [tmp insertText:string];
        }
    }
    else
    {
        [tmp insertText:string];
    }
    
}

@end
