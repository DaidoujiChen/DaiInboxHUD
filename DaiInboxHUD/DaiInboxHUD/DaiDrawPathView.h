//
//  DaiDrawPathView.h
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/13.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiInboxDisplayLink.h"

@interface DaiDrawPathView : UIView <DaiInboxDisplayLinkDelegate>

@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, strong) NSArray *drawPath;
@property (nonatomic, assign) CGFloat lengthIteration;
@property (nonatomic, assign) CGFloat hudLineWidth;

@end
