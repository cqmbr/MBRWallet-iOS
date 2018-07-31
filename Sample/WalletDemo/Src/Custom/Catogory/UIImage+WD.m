//
//  UIImage+WD.m
//  WalletDemo
//
//  Created by lfl on 2018/7/31.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "UIImage+WD.h"

@implementation UIImage (WD)

+ (UIImage*)wd_imageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
