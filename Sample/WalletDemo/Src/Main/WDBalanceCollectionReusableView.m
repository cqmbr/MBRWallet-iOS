//
//  WDBalanceCollectionReusableView.m
//  WalletDemo
//
//  Created by sean on 2018/4/6.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBalanceCollectionReusableView.h"

@implementation WDBalanceCollectionReusableView
- (IBAction)moreAction:(id)sender {
    [_delegate addDC:self atIndexPath:self.cindexPath];
}

@end
