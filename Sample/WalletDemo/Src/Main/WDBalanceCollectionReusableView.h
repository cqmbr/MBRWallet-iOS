//
//  WDBalanceCollectionReusableView.h
//  WalletDemo
//
//  Created by sean on 2018/4/6.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BalanceHeaderDelegate<NSObject>
@optional
-(void)addDC:(UICollectionReusableView *)resuableView atIndexPath:(NSIndexPath *)indexPath;
@end

@interface WDBalanceCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) NSIndexPath *cindexPath;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (assign, nonatomic) id<BalanceHeaderDelegate>delegate;
@end
