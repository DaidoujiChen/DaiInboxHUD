//
//  DaiIndoxWindow.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/11/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiIndoxWindow.h"

@implementation DaiIndoxWindow

#pragma mark - method to override

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.eventDelegate shouldHandleTouchAtPoint:point];
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert - 1;
    }
    return self;
}

@end
