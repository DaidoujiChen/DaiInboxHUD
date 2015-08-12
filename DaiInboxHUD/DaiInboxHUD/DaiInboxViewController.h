//
//  DaiInboxViewController.h
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/11/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DaiInboxHUDTypeDefault,
    DaiInboxHUDTypeSuccess,
    DaiInboxHUDTypeFail
} DaiInboxHUDType;

@interface DaiInboxViewController : UIViewController

@property (nonatomic, strong) NSArray *hudColors;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic, strong) UIColor *hudMaskColor;
@property (nonatomic, strong) UIColor *hudCheckmarkColor;
@property (nonatomic, strong) UIColor *hudCrossColor;
@property (nonatomic, assign) CGFloat hudLineWidth;
@property (nonatomic, strong) NSAttributedString *hudMessage;
@property (nonatomic, assign) DaiInboxHUDType hudType;

- (void)hide:(void (^)(void))completion;

@end
