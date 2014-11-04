//
//  DaiInboxHUD.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxHUD.h"

#import <objc/runtime.h>

@implementation DaiInboxHUD

#pragma mark - class method

+ (void)showHUD {
    [self hudWindow].rootViewController = [DaiInboxViewController new];
    [[self hudWindow] makeKeyAndVisible];
}

+ (void)hideHUD {
    [[self hudWindow].rootViewController performSelector:@selector(hide:) withObject: ^{
        [self hudWindow].hidden = YES;
        [self setHudWindow:nil];
        [[UIApplication sharedApplication].keyWindow makeKeyWindow];
    }];
}

#pragma mark - setter / getter

+ (DaiIndoxWindow *)hudWindow {
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setHudWindow:[[DaiIndoxWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    }
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setHudWindow:(DaiIndoxWindow *)hudWindow {
    objc_setAssociatedObject(self, @selector(hudWindow), hudWindow, OBJC_ASSOCIATION_RETAIN);
}

@end
