//
//  UIButton+MBRElarge.h
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MBRElarge)
@property(assign,nonatomic)BOOL mbrHighLight; ///< 设置高亮
@property(strong,nonatomic)UIImage *normalImage;         ///< 普通状态的图片
@property(strong,nonatomic)UIImage *highLightImage;     ///< 高亮状态的图片

/**
 *  设置图片
 *
 *  @param imageName 图片名称
 */
-(void)setImage:(NSString *)imageName;


/**
 *  设置图片
 *
 *  @param normalImage    普通图
 *  @param highLightImage 高亮图
 */
-(void)setImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage;
/**
 *  设置图片
 *
 *  @param normalImageName    普通图片名
 *  @param highLightImageName 高亮图片名
 */
-(void)setImage:(NSString *)normalImageName highLightImageName:(NSString *)highLightImageName;

/**
 *  增加按钮的响应区域
 *
 *  @param size 增加的区域top,right,bottom,left都加size区域
 */
- (void)setEnlargeEdge:(CGFloat) size;

/**
 *  增加按钮到响应区域
 *
 *  @param top    顶部增加
 *  @param right  右边增加
 *  @param bottom 底部增加
 *  @param left   左边增加
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
