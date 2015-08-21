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

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, strong) UIColor *checkmarkColor;
@property (nonatomic, strong) UIColor *crossColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSAttributedString *message;
@property (nonatomic, assign) BOOL allowUserInteraction;
@property (nonatomic, assign) DaiInboxHUDType type;

- (void)hide:(void (^)(void))completion;

@end
