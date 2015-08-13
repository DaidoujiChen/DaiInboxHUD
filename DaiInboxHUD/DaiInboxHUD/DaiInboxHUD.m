//
//  DaiInboxHUD.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxHUD.h"
#import <objc/runtime.h>
#import "DaiIndoxWindow.h"
#import "DaiInboxViewController.h"

@implementation DaiInboxHUD

#pragma mark - DaiIndoxWindowDelegate

+ (BOOL)shouldHandleTouchAtPoint:(CGPoint)point {
    return ![self allowUserInteraction];
}

#pragma mark - private class method

+ (DaiInboxViewController *)inboxViewControllerByType:(DaiInboxHUDType)type andMessage:(NSAttributedString *)message {
    DaiInboxViewController *inboxViewController = [DaiInboxViewController new];
    inboxViewController.hudColors = [self hudColors];
    inboxViewController.hudBackgroundColor = [self hudBackgroundColor];
    inboxViewController.hudMaskColor = [self hudMaskColor];
    inboxViewController.hudLineWidth = [self hudLineWidth];
    inboxViewController.hudCheckmarkColor = [self hudCheckmarkColor];
    inboxViewController.hudCrossColor = [self hudCrossColor];
    inboxViewController.hudMessage = message;
    inboxViewController.hudType = type;
    return inboxViewController;
}

#pragma mark - class method

+ (void)show {
    [self showMessage:nil];
}

+ (void)showSuccess {
    [self showSuccessMessage:nil];
}

+ (void)showFail {
    [self showFailMessage:nil];
}

+ (void)showMessage:(NSAttributedString *)message {
    [self hudWindow].rootViewController = [self inboxViewControllerByType:DaiInboxHUDTypeDefault andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
}

+ (void)showSuccessMessage:(NSAttributedString *)message {
    [self hudWindow].rootViewController = [self inboxViewControllerByType:DaiInboxHUDTypeSuccess andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
}

+ (void)showFailMessage:(NSAttributedString *)message {
    [self hudWindow].rootViewController = [self inboxViewControllerByType:DaiInboxHUDTypeFail andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
}

+ (void)hide {
    __weak id weakSelf = self;
    [[self hudWindow].rootViewController performSelector:@selector(hide:) withObject: ^{
        if (weakSelf) {
            __strong id strongSelf = weakSelf;
            [strongSelf hudWindow].hidden = YES;
            [strongSelf setHudWindow:nil];
            [[UIApplication sharedApplication].keyWindow makeKeyWindow];
        }
    }];
}

+ (void)setColors:(NSArray *)colors {
    
    //檢查每一個填入的元素是否都為 uicolor
    BOOL isLegal = YES;
    for (id objects in colors) {
        if (![objects isKindOfClass:[UIColor class]]) {
            isLegal = NO;
            break;
        }
    }
    
    //合法就讓他設定, 不合法則跳錯誤訊息
    if ([colors count] && isLegal) {
        [self setHudColors:colors];
    }
    else {
        NSLog(@"填入的顏色不被採用, 建議要填入一個以上的顏色, 或是元素不合法.");
    }
}

+ (void)setCheckmarkColor:(UIColor *)checkmarkColor {
    [self setHudCheckmarkColor:checkmarkColor];
}

+ (void)setCrossColor:(UIColor *)crossColor {
    [self setHudCrossColor:crossColor];
}

+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setHudBackgroundColor:backgroundColor];
}

+ (void)setMaskColor:(UIColor *)maskColor {
    [self setHudMaskColor:maskColor];
}

+ (void)setLineWidth:(CGFloat)lineWidth {
    [self setHudLineWidth:lineWidth];
}

+ (void)allowUserInteraction:(BOOL)allowUserInteraction {
    [self setAllowUserInteraction:allowUserInteraction];
}

#pragma mark - objects

#pragma mark hud 視窗

+ (DaiIndoxWindow *)hudWindow {
    if (!objc_getAssociatedObject(self, _cmd)) {
        DaiIndoxWindow *newWindow = [[DaiIndoxWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        newWindow.eventDelegate = (id <DaiIndoxWindowDelegate> )self;
        [self setHudWindow:newWindow];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudWindow:(DaiIndoxWindow *)hudWindow {
    objc_setAssociatedObject(self, @selector(hudWindow), hudWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 客製化變數

+ (void)setHudColors:(NSArray *)hudColors {
    objc_setAssociatedObject(self, @selector(hudColors), hudColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)hudColors {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudColors:@[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudCheckmarkColor:(UIColor *)hudCheckmarkColor {
    objc_setAssociatedObject(self, @selector(hudCheckmarkColor), hudCheckmarkColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudCheckmarkColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudCheckmarkColor:[UIColor greenColor]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudCrossColor:(UIColor *)hudCrossColor {
    objc_setAssociatedObject(self, @selector(hudCrossColor), hudCrossColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudCrossColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudCrossColor:[UIColor redColor]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor {
    objc_setAssociatedObject(self, @selector(hudBackgroundColor), hudBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudBackgroundColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudLineWidth:(CGFloat)hudLineWidth {
    objc_setAssociatedObject(self, @selector(hudLineWidth), @(hudLineWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)hudLineWidth {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudLineWidth:2.0f];
    }
    NSNumber *hudLineWidth = objc_getAssociatedObject(self, _cmd);
    return [hudLineWidth floatValue];
}

+ (void)setHudMaskColor:(UIColor *)hudMaskColor {
    objc_setAssociatedObject(self, @selector(hudMaskColor), hudMaskColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)hudMaskColor {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudMaskColor:[UIColor clearColor]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setAllowUserInteraction:(BOOL)allowUserInteraction {
    objc_setAssociatedObject(self, @selector(allowUserInteraction), @(allowUserInteraction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)allowUserInteraction {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setAllowUserInteraction:NO];
    }
    NSNumber *allowUserInteraction = objc_getAssociatedObject(self, _cmd);
    return allowUserInteraction.boolValue;
}

@end
