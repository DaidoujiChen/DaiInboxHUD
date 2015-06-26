//
//  DaiIndoxWindow.h
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/11/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaiIndoxWindowDelegate;

@interface DaiIndoxWindow : UIWindow

@property (nonatomic, weak) id <DaiIndoxWindowDelegate> eventDelegate;

@end

@protocol DaiIndoxWindowDelegate <NSObject>
@required
- (BOOL)shouldHandleTouchAtPoint:(CGPoint)point;

@end
