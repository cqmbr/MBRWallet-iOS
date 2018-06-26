//
//  UIButton+MBRElarge.m
//  WalletDemo
//
//  Created by liaofulin on 2018/3/25.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "UIButton+MBRElarge.h"
#import <objc/runtime.h>

@implementation UIButton (MBRElarge)
static const char NormalImageKey = '\0';
- (void)setNormalImage:(UIImage *)normalImage {
    if (normalImage != self.normalImage) {
        // 存储新的
        [self willChangeValueForKey:@"normalImage"]; // KVO
        objc_setAssociatedObject(self, &NormalImageKey,
                                 normalImage, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"normalImage"]; // KVO
    }
}

- (UIImage *)normalImage {
    return objc_getAssociatedObject(self, &NormalImageKey);
}

static const char HighLightImageKey = '\0';
- (void)setHighLightImage:(UIImage *)highLightImage {
    if (highLightImage != self.highLightImage) {
        // 存储新的
        [self willChangeValueForKey:@"highLightImage"]; // KVO
        objc_setAssociatedObject(self, &HighLightImageKey,
                                 highLightImage, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"highLightImage"]; // KVO
    }
}

- (UIImage *)highLightImage {
    return objc_getAssociatedObject(self, &HighLightImageKey);
}

static const char MBRHighLightKey = '\0';
#pragma mark 设置高亮
- (void)setMbrHighLight:(BOOL)mbrHighLight {
    if (mbrHighLight != self.mbrHighLight) {
        // 存储新的
        [self willChangeValueForKey:@"mbrHighLight"]; // KVO
        objc_setAssociatedObject(self, &MBRHighLightKey,
                                 [NSNumber numberWithBool:mbrHighLight], OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"mbrHighLight"]; // KVO
    }
    
    if(mbrHighLight){
        [self setImage:self.highLightImage forState:UIControlStateNormal];
        [self setImage:self.highLightImage forState:UIControlStateHighlighted];
    }else{
        [self setImage:self.normalImage forState:UIControlStateNormal];
        [self setImage:self.highLightImage forState:UIControlStateHighlighted];
    }
}

- (BOOL)mbrHighLight {
    return [objc_getAssociatedObject(self, &MBRHighLightKey) boolValue];
}

#pragma mark 设置图片
- (void)setImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage {
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:highLightImage forState:UIControlStateHighlighted];
    
    self.normalImage = normalImage;
    self.highLightImage = highLightImage;
}

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

#pragma mark 设置图片
-(void)setImage:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/**
 *  设置图片
 *
 *  @param normalImageName    普通图片名
 *  @param highLightImageName 高亮图片名
 */
-(void)setImage:(NSString *)normalImageName highLightImageName:(NSString *)highLightImageName {
    [self setImage:[UIImage imageNamed:normalImageName] highLightImage:[UIImage imageNamed:highLightImageName]];
}

- (void)setEnlargeEdge:(CGFloat) size {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
