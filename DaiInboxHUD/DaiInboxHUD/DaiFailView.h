//
//  DaiFailView.h
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/12.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiInboxDisplayLink.h"

@interface DaiFailView : UIView <DaiInboxDisplayLinkDelegate>

@property (nonatomic, strong) UIColor *hudCrossColor;
@property (nonatomic, assign) CGFloat hudLineWidth;

@end
