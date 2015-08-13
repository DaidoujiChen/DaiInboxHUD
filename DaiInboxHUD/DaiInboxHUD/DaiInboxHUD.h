//
//  DaiInboxHUD.h
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DaiInboxHUD;
typedef DaiInboxHUD *(^CopiedHUD)(DaiInboxHUD *copiedHUD);

@interface DaiInboxHUD : NSObject <NSCopying>

//設定自己想要的顏色循環, 預設是 紅 -> 綠 -> 黃 -> 藍 -> loop, 起始為哪一個則為隨機, 建議設定兩個顏色以上
@property (nonatomic, strong) NSArray *colors;

//設定打勾勾顏色, 預設為純綠
@property (nonatomic, strong) UIColor *checkmarkColor;

//設定叉叉顏色, 預設為純紅
@property (nonatomic, strong) UIColor *crossColor;

//設定 hud 的背景顏色, 預設為 0.65 alpha 的黑色
@property (nonatomic, strong) UIColor *backgroundColor;

//設定 hud 跳出來時, 原來的畫面要用什麼顏色蓋住, 預設蓋住的顏色是 clearColor
@property (nonatomic, strong) UIColor *maskColor;

//設定 hud 轉圈圈線的粗細, 預設為 2.0f, 數值大約到 10.0f 都還可以看, 到 20.0f 就不知道在幹嘛了
@property (nonatomic, assign) CGFloat lineWidth;

//切換在 hud 過程中, 使用者是否可以有其他動作, 預設為 NO, 不允許
@property (nonatomic, assign) BOOL allowUserInteraction;

//顯示轉圈 hud, 可帶字, 可設定幾秒後消失
+ (void)show;
+ (void)showThenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showMessage:(NSAttributedString *)message;
+ (void)showMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;
+ (void)showCopied:(CopiedHUD)copied;
+ (void)showCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message;
+ (void)showCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;

//顯示成功動畫, 可帶字, 可設定幾秒後消失
+ (void)showSuccess;
+ (void)showSuccessThenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showSuccessMessage:(NSAttributedString *)message;
+ (void)showSuccessMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;
+ (void)showSuccessCopied:(CopiedHUD)copied;
+ (void)showSuccessCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showSuccessCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message;
+ (void)showSuccessCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;

//顯示失敗動畫, 可帶字, 可設定幾秒後消失
+ (void)showFail;
+ (void)showFailThenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showFailMessage:(NSAttributedString *)message;
+ (void)showFailMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;
+ (void)showFailCopied:(CopiedHUD)copied;
+ (void)showFailCopied:(CopiedHUD)copied thenHideAfterDelay:(NSTimeInterval)delay;
+ (void)showFailCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message;
+ (void)showFailCopied:(CopiedHUD)copied andMessage:(NSAttributedString *)message hideAfterDelay:(NSTimeInterval)delay;

//隱藏 hud,可設定幾秒後消失
+ (void)hide;
+ (void)hideAfterDelay:(NSTimeInterval)delay;

//共用實例
+ (DaiInboxHUD *)shared;

@end
