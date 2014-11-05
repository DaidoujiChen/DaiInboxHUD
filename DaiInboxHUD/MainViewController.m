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
    [DaiInboxHUD show];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:10.0f];
}

#pragma mark - private

- (void)hideHUD {
    [DaiInboxHUD hide];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
