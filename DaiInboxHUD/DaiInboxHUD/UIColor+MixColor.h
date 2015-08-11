//
//  UIColor+MixColor.h
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/11.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MixColor)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

- (UIColor *)mixColor:(UIColor *)otherColor;

@end
