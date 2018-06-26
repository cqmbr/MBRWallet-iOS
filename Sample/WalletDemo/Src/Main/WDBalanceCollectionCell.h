//
//  WDBalanceCollectionCell.h
//  WalletDemo
//
//  Created by sean on 2018/4/6.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBalanceCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *balanceLb;

@end
