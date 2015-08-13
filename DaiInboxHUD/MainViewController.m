//
//  MainViewController.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

#import "DaiInboxHUD.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - ibaction

- (IBAction)showAction:(id)sender {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIColor *textColor = [UIColor blackColor];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : textColor, NSFontAttributeName : font, NSTextEffectAttributeName : NSTextEffectLetterpressStyle };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Loading" attributes:attributes];
    
    switch (arc4random() % 3) {
        case 0:
            if (arc4random() % 2) {
                [DaiInboxHUD showMessage:attributedString hideAfterDelay:2.0f];
            }
            else {
                [DaiInboxHUD showCopied: ^DaiInboxHUD *(DaiInboxHUD *copiedHUD) {
                    copiedHUD.backgroundColor = [UIColor redColor];
                    return copiedHUD;
                } andMessage:attributedString hideAfterDelay:2.0f];
            }
            break;
            
        case 1:
            if (arc4random() % 2) {
                [DaiInboxHUD showSuccessMessage:attributedString hideAfterDelay:3.0f];
            }
            else {
                [DaiInboxHUD showSuccessCopied: ^DaiInboxHUD *(DaiInboxHUD *copiedHUD) {
                    copiedHUD.checkmarkColor = [UIColor blueColor];
                    return copiedHUD;
                } andMessage:attributedString hideAfterDelay:3.0f];
            }
            break;
            
        case 2:
            if (arc4random() % 2) {
                [DaiInboxHUD showFailMessage:attributedString hideAfterDelay:4.0f];
            }
            else {
                [DaiInboxHUD showFailCopied: ^DaiInboxHUD *(DaiInboxHUD *copiedHUD) {
                    copiedHUD.crossColor = [UIColor purpleColor];
                    return copiedHUD;
                } andMessage:attributedString hideAfterDelay:4.0f];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)clickAction:(id)sender {
    NSLog(@"Clicked");
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //客製化想要的顏色
    [DaiInboxHUD shared].colors = @[[UIColor grayColor], [UIColor whiteColor], [UIColor blackColor], [UIColor purpleColor]];
    
    //想要的背景色
    [DaiInboxHUD shared].backgroundColor = [UIColor orangeColor];
    
    //想要的遮膜色
    [DaiInboxHUD shared].maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    //想要的線條粗度
    [DaiInboxHUD shared].lineWidth = 4.0f;
    
    //打勾要顯示的顏色
    [DaiInboxHUD shared].checkmarkColor = [UIColor greenColor];
    
    //叉叉要顯示的顏色
    [DaiInboxHUD shared].crossColor = [UIColor redColor];
    
    //當然也都可以不設, 使用預設帶的值
}

@end
