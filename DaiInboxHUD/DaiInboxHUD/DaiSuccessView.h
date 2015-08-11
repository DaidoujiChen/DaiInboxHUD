//
//  DaiSuccessView.h
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/11.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiInboxDisplayLink.h"

@interface DaiSuccessView : UIView <DaiInboxDisplayLinkDelegate>

@property (nonatomic, strong) UIColor *hudCheckmarkColor;
@property (nonatomic, assign) CGFloat hudLineWidth;

@end
