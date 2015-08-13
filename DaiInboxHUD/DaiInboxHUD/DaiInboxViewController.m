//
//  DaiInboxViewController.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/11/4.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxViewController.h"
#import "DaiInboxView.h"
#import "DaiDrawPathView.h"

#define inboxViewSize 30.0f
#define borderGap 10.0f

@implementation UIView (Center)

- (CGRect)centerInOrientation:(UIInterfaceOrientation)orientation {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat halfScreenWidth = CGRectGetWidth(screenBounds) / 2;
    CGFloat halfScreenHeight = CGRectGetHeight(screenBounds) / 2;
    CGRect newFrame = self.frame;
    CGFloat halfFrameWidth = CGRectGetWidth(newFrame) / 2;
    CGFloat halfFrameHeight = CGRectGetHeight(newFrame) / 2;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        newFrame.origin.x = halfScreenWidth - halfFrameWidth;
        newFrame.origin.y = halfScreenHeight - halfFrameHeight;
    }
    else {
        newFrame.origin.x = halfScreenWidth - halfFrameHeight;
        newFrame.origin.y = halfScreenHeight - halfFrameWidth;
        
        //在 ios7 的時候, 不論手機轉橫轉直, screenSize always 是 320, 568
        //而 ios8 的時候, 手機則會根據轉橫或是轉直而改變, ex: 直立時是 320, 568, 橫向為 568, 320
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
            CGFloat swapValue = newFrame.origin.x;
            newFrame.origin.x = newFrame.origin.y;
            newFrame.origin.y = swapValue;
        }
    }
    return newFrame;
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
    [UIView animateWithDuration:0.3 / 1.5 animations: ^{
        wealSelf.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.3 / 2 animations: ^{
            wealSelf.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion: ^(BOOL finished) {
            [UIView animateWithDuration:0.3 / 2 animations: ^{
                wealSelf.centerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            } completion: ^(BOOL finished) {
                completion();
            }];
        }];
    }];
}

#pragma mark - private instance method

- (void)setupHUD {
    CGRect messageFrame = CGRectZero;
    UILabel *hudMessageLabel;
    CGFloat messageLabelWidth = 0;
    CGFloat messageLabelHeight = 0;
    
    //如果 hud message 有東西, 先算他的 size
    if (self.message) {
        hudMessageLabel = [UILabel new];
        hudMessageLabel.attributedText = self.message;
        [hudMessageLabel sizeToFit];
        messageFrame = hudMessageLabel.frame;
        messageLabelWidth = CGRectGetWidth(hudMessageLabel.frame);
        messageLabelHeight = CGRectGetHeight(hudMessageLabel.frame);
    }
    
    //設定好 centerview 的大小
    //寬度的算法, 取 hud 本身或是 label 的最大者, 加上左右兩旁的邊框
    CGFloat centerViewWidth = MAX(inboxViewSize, CGRectGetWidth(messageFrame)) + borderGap * 2;
    
    //高度的算法, 只有 hud 的時候就是 hud 本身加上上下的邊框, 多 label 的話, 要在 hud 跟 label 之間多塞一個一半大小的 gap
    CGFloat centerViewHeight = inboxViewSize + messageLabelHeight + borderGap * 2 + ((self.message) ? borderGap * 0.5 : 0);
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerViewWidth, centerViewHeight)];
    self.centerView.frame = [self.centerView centerInOrientation:self.interfaceOrientation];
    self.centerView.backgroundColor = self.backgroundColor;
    self.centerView.layer.cornerRadius = 5.0f;
    self.centerView.layer.masksToBounds = YES;
    
    //開始把東西加入 centerView
    CGFloat objectHeight = borderGap;
    
    //加入 hud 主體
    CGFloat halfCenterWidth = CGRectGetWidth(self.centerView.frame) / 2;
    UIView *hudView = nil;
    switch (self.type) {
        case DaiInboxHUDTypeDefault:
        {
            DaiInboxView *inboxView = [[DaiInboxView alloc] initWithFrame:CGRectMake(halfCenterWidth - inboxViewSize / 2, objectHeight, inboxViewSize, inboxViewSize)];
            inboxView.hudColors = self.colors;
            inboxView.hudLineWidth = self.lineWidth;
            hudView = inboxView;
            break;
        }
            
        case DaiInboxHUDTypeSuccess:
        {
            DaiDrawPathView *successView = [[DaiDrawPathView alloc] initWithFrame:CGRectMake(halfCenterWidth - inboxViewSize / 2, objectHeight, inboxViewSize, inboxViewSize)];
            successView.pathColor = self.checkmarkColor;
            successView.hudLineWidth = self.lineWidth;
            successView.drawPath = @[@[[NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.25f, inboxViewSize * 0.5f)], [NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.5f, inboxViewSize * 0.75f)], [NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.85f, inboxViewSize * 0.25f)]]];
            successView.lengthIteration = 0.8f;
            hudView = successView;
            break;
        }
            
        case DaiInboxHUDTypeFail:
        {
            DaiDrawPathView *failView = [[DaiDrawPathView alloc] initWithFrame:CGRectMake(halfCenterWidth - inboxViewSize / 2, objectHeight, inboxViewSize, inboxViewSize)];
            failView.pathColor = self.crossColor;
            failView.hudLineWidth = self.lineWidth;
            failView.drawPath = @[@[[NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.15f, inboxViewSize * 0.15f)], [NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.85f, inboxViewSize * 0.85f)]], @[[NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.85f, inboxViewSize * 0.15f)], [NSValue valueWithCGPoint:CGPointMake(inboxViewSize * 0.15f, inboxViewSize * 0.85f)]]];
            failView.lengthIteration = 1.6f;
            hudView = failView;
            break;
        }
    }
    [self.centerView addSubview:hudView];
    CGFloat hudViewHeight = CGRectGetHeight(hudView.frame);
    objectHeight += hudViewHeight + ((self.message) ? borderGap * 0.5 : 0);
    
    //如果有 label 的話就加
    if (self.message) {
        hudMessageLabel.frame = CGRectMake(halfCenterWidth - messageLabelWidth / 2, objectHeight, messageLabelWidth, messageLabelHeight);
        [self.centerView addSubview:hudMessageLabel];
    }
    
    //放到 view 裡
    [self.view addSubview:self.centerView];
}

#pragma mark - rotate

//for ios8
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator> )coordinator {
    CGRect newFrame = self.centerView.frame;
    CGFloat halfFrameWidth = CGRectGetWidth(newFrame) / 2;
    CGFloat halfFrameHeight = CGRectGetHeight(newFrame) / 2;
    newFrame.origin.x = size.width / 2 - halfFrameWidth;
    newFrame.origin.y = size.height / 2 - halfFrameHeight;
    __weak DaiInboxViewController *weakSelf = self;
    [UIView animateWithDuration:[coordinator transitionDuration] animations: ^{
        weakSelf.centerView.frame = newFrame;
    }];
}

//for ios7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect newFrame = [self.centerView centerInOrientation:toInterfaceOrientation];
    __weak DaiInboxViewController *weakSelf = self;
    [UIView animateWithDuration:duration animations: ^{
        weakSelf.centerView.frame = newFrame;
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.maskColor;
    [self setupHUD];
    
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
