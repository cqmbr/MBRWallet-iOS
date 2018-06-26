//
//  WDBalanceSingleDCTableViewCell.m
//  WalletDemo
//
//  Created by autoround-032 on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBalanceSingleDCTableViewCell.h"
#import "WDResource.h"
@implementation WDBalanceSingleDCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.icomImageView.layer setBorderColor:WDColor_6.CGColor];
    self.icomImageView.layer.borderWidth = 1;
    [self.icomImageView.layer setCornerRadius:24];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
