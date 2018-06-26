//
//  WDBalanceSingleDCTableViewCell.h
//  WalletDemo
//
//  Created by autoround-032 on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBalanceSingleDCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icomImageView;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *toAddress;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end
