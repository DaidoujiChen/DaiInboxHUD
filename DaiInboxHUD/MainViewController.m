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
            [DaiInboxHUD showMessage:attributedString];
            break;
            
        case 1:
            [DaiInboxHUD showSuccessMessage:attributedString];
            break;
            
        case 2:
            [DaiInboxHUD showFail:attributedString];
            break;
            
        default:
            break;
    }
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:3.0f];
}

- (IBAction)clickAction:(id)sender {
    NSLog(@"Clicked");
}

#pragma mark - private

- (void)hideHUD {
    [DaiInboxHUD hide];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //客製化想要的顏色
    [DaiInboxHUD setColors:@[[UIColor grayColor], [UIColor whiteColor], [UIColor blackColor], [UIColor purpleColor]]];
    
    //想要的背景色
    [DaiInboxHUD setBackgroundColor:[UIColor orangeColor]];
    
    //想要的遮膜色
    [DaiInboxHUD setMaskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    
    //想要的線條粗度
    [DaiInboxHUD setLineWidth:4.0f];
    
    //打勾要顯示的顏色
    [DaiInboxHUD setCheckmarkColor:[UIColor greenColor]];
    
    //叉叉要顯示的顏色
    [DaiInboxHUD setCrossColor:[UIColor redColor]];
    
    //當然也都可以不設, 使用預設帶的值
}

@end
