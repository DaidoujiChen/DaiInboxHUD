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
    
    // 如果 allowUserInteraction = YES, 表示這個 window 不需要 handle touch event, 因此, 回傳是反相的
    DaiInboxViewController *inboxViewController = (DaiInboxViewController *)[self hudWindow].rootViewController;
    return !inboxViewController.allowUserInteraction;
}

#pragma mark - private class method

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

+ (DaiInboxViewController *)inboxViewControllerByCopied:(CopiedHUD)copied byType:(DaiInboxHUDType)type andMessage:(NSAttributedString *)message {
    DaiInboxHUD *inboxHUD = nil;
    if (copied) {
        inboxHUD = copied([[self shared] copy]);
    }
    else {
        inboxHUD = [self shared];
    }
    DaiInboxViewController *inboxViewController = [DaiInboxViewController new];
    inboxViewController.colors = inboxHUD.colors;
    inboxViewController.backgroundColor = inboxHUD.backgroundColor;
    inboxViewController.maskColor = inboxHUD.maskColor;
    inboxViewController.lineWidth = inboxHUD.lineWidth;
    inboxViewController.checkmarkColor = inboxHUD.checkmarkColor;
    inboxViewController.crossColor = inboxHUD.crossColor;
    inboxViewController.allowUserInteraction = inboxHUD.allowUserInteraction;
    inboxViewController.message = message;
    inboxViewController.type = type;
    return inboxViewController;
}

#pragma mark - class method

#pragma mark * 轉圈效果

+ (void)show {
    [self showMessage:nil];
}

+ (void)showThenHideAfterDelay:(NSTimeInterval)delay {
    [self showMessage:nil hideAfterDelay:delay];
}

+ (void)showMessage:(NSAttributedString *)message {
    [self showMessage:message hideAfterDelay:-1];
}

+ (void)showMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self showCopied:nil andMessage:message hideAfterDelay:delay];
}

+ (void)showCopied:(CopiedHUD)copied {
    [self showCopied:copied andMessage:nil];
}

+ (void)showCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay {
    [self showCopied:copied andMessage:nil hideAfterDelay:delay];
}

+ (void)showCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message {
    [self showCopied:copied andMessage:message hideAfterDelay:-1];
}

+ (void)showCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self hudWindow].rootViewController = [self inboxViewControllerByCopied:copied byType:DaiInboxHUDTypeDefault andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
    [self hideAfterDelay:delay];
}

#pragma mark * 打勾效果

+ (void)showSuccess {
    [self showSuccessMessage:nil];
}

+ (void)showSuccessThenHideAfterDelay:(NSTimeInterval)delay {
    [self showSuccessMessage:nil hideAfterDelay:delay];
}

+ (void)showSuccessMessage:(NSAttributedString *)message {
    [self showSuccessMessage:message hideAfterDelay:-1];
}

+ (void)showSuccessMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self showSuccessCopied:nil andMessage:message hideAfterDelay:delay];
}

+ (void)showSuccessCopied:(CopiedHUD)copied {
    [self showSuccessCopied:copied andMessage:nil];
}

+ (void)showSuccessCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay {
    [self showSuccessCopied:copied andMessage:nil hideAfterDelay:delay];
}

+ (void)showSuccessCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message {
    [self showSuccessCopied:copied andMessage:message hideAfterDelay:-1];
}

+ (void)showSuccessCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self hudWindow].rootViewController = [self inboxViewControllerByCopied:copied byType:DaiInboxHUDTypeSuccess andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
    [self hideAfterDelay:delay];
}

#pragma mark * 打叉效果

+ (void)showFail {
    [self showFailMessage:nil];
}

+ (void)showFailThenHideAfterDelay:(NSTimeInterval)delay {
    [self showFailMessage:nil hideAfterDelay:delay];
}

+ (void)showFailMessage:(NSAttributedString *)message {
    [self showFailMessage:message hideAfterDelay:-1];
}

+ (void)showFailMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self showFailCopied:nil andMessage:message hideAfterDelay:delay];
}

+ (void)showFailCopied:(CopiedHUD)copied {
    [self showFailCopied:copied andMessage:nil];
}

+ (void)showFailCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay {
    [self showFailCopied:copied andMessage:nil hideAfterDelay:delay];
}

+ (void)showFailCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message {
    [self showFailCopied:copied andMessage:message hideAfterDelay:-1];
}

+ (void)showFailCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay {
    [self hudWindow].rootViewController = [self inboxViewControllerByCopied:copied byType:DaiInboxHUDTypeFail andMessage:message];
    [[self hudWindow] makeKeyAndVisible];
    [self hideAfterDelay:delay];
}

#pragma mark * 隱藏 hud

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

+ (void)hideAfterDelay:(NSTimeInterval)delay {
    if (delay > 0) {
        id objectSelf = self;
        [objectSelf performSelector:@selector(hide) withObject:nil afterDelay:delay];
    }
}

#pragma mark * 共用實例

+ (DaiInboxHUD *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DaiInboxHUD *sharedHUD = [DaiInboxHUD new];
        sharedHUD.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]];
        sharedHUD.checkmarkColor = [UIColor greenColor];
        sharedHUD.crossColor = [UIColor redColor];
        sharedHUD.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f];
        sharedHUD.maskColor = [UIColor clearColor];
        sharedHUD.lineWidth = 2.0f;
        sharedHUD.allowUserInteraction = NO;
        objc_setAssociatedObject(self, _cmd, sharedHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DaiInboxHUD *newHUD = [[DaiInboxHUD allocWithZone:zone] init];
    newHUD.colors = self.colors;
    newHUD.checkmarkColor = self.checkmarkColor;
    newHUD.crossColor = self.crossColor;
    newHUD.backgroundColor = self.backgroundColor;
    newHUD.maskColor = self.maskColor;
    newHUD.lineWidth = self.lineWidth;
    newHUD.allowUserInteraction = self.allowUserInteraction;
    return newHUD;
}

@end
