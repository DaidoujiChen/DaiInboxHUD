//
//  UIColor+MixColor.m
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/11.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "UIColor+MixColor.h"
#import <objc/runtime.h>

@implementation UIColor (MixColor)

@dynamic r, g, b, a;

- (CGFloat)r {
    return [[self rgba][@"r"] floatValue];
}

- (CGFloat)g {
    return [[self rgba][@"g"] floatValue];
}

- (CGFloat)b {
    return [[self rgba][@"b"] floatValue];
}

- (CGFloat)a {
    return [[self rgba][@"a"] floatValue];
}

- (UIColor *)mixColor:(UIColor *)otherColor {
    //混色的公式
    //http://stackoverflow.com/questions/726549/algorithm-for-additive-color-mixing-for-rgb-values
    CGFloat newAlpha = 1 - (1 - self.a) * (1 - otherColor.a);
    CGFloat newRed = self.r * self.a / newAlpha + otherColor.r * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newGreen = self.g * self.a / newAlpha + otherColor.g * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newBlue = self.b * self.a / newAlpha + otherColor.b * otherColor.a * (1 - self.a) / newAlpha;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

- (NSDictionary *)rgba {
    NSDictionary *rgba = objc_getAssociatedObject(self, _cmd);
    if (!rgba) {
        CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
        if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
            [self setRgba:@{ @"r":@(red), @"g":@(green), @"b":@(blue), @"a":@(alpha) }];
        }
        else {
            //http://stackoverflow.com/questions/4700168/get-rgb-value-from-uicolor-presets
            CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            unsigned char resultingPixel[3];
            CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNone);
            CGContextSetFillColorWithColor(context, [self CGColor]);
            CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
            CGContextRelease(context);
            CGColorSpaceRelease(rgbColorSpace);
            [self setRgba:@{ @"r":@(resultingPixel[0]), @"g":@(resultingPixel[1]), @"b":@(resultingPixel[2]), @"a":@(1.0f) }];
        }
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRgba:(NSDictionary *)rgba {
    objc_setAssociatedObject(self, @selector(rgba), rgba, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
