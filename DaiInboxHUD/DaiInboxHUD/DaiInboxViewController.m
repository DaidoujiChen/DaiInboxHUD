//
//  DaiInboxViewController.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/11/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxViewController.h"

#define centerViewSize 50.0f
#define inboxViewSize 30.0f

@implementation UIView (Center)

- (void)centerInBounds:(CGRect)bounds {
    CGRect newFrame = self.frame;
    newFrame.origin.x = bounds.size.width / 2 - newFrame.size.width / 2;
    newFrame.origin.y = bounds.size.height / 2 - newFrame.size.height / 2;
    self.frame = newFrame;
}

@end

@interface DaiInboxViewController ()

@property (nonatomic, strong) UIView *centerView;

@end

@implementation DaiInboxViewController

#pragma mark - instance method

// hide hud 然後帶個動畫
- (void)hide:(void (^)(void))completion {
    __weak DaiInboxViewController *wealSelf = self;
    [UIView animateWithDuration:1.0f animations: ^{
        wealSelf.centerView.alpha = 0;
    } completion: ^(BOOL finished) {
        completion();
    }];
}

#pragma mark - private

- (void)setupDefaultHUD {
    //設定好 centerview 的大小
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerViewSize, centerViewSize)];
    [self.centerView centerInBounds:[UIScreen mainScreen].bounds];
    self.centerView.backgroundColor = self.hudBackgroundColor;
    self.centerView.layer.cornerRadius = centerViewSize * 0.1f;
    self.centerView.layer.masksToBounds = YES;
    
    //加入 hud 主體
    DaiInboxView *inboxView = [[DaiInboxView alloc] initWithFrame:CGRectMake(0, 0, inboxViewSize, inboxViewSize)];
    inboxView.hudColors = self.hudColors;
    inboxView.hudLineWidth = self.hudLineWidth;
    [inboxView centerInBounds:self.centerView.bounds];
    [self.centerView addSubview:inboxView];
    
    //放到 view 裡
    [self.view addSubview:self.centerView];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [self setupDefaultHUD];
    
    //一開始的彈出動畫效果
    self.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    __weak DaiInboxViewController *wealSelf = self;
    [UIView animateWithDuration:0.3 / 1.5 animations: ^{
        wealSelf.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations: ^{
            wealSelf.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:0.3 / 2 animations: ^{
                wealSelf.centerView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

@end
