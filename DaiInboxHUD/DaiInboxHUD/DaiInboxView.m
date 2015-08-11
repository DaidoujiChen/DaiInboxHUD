//
//  DaiInboxView.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxView.h"
#import <objc/runtime.h>
#import "UIColor+MixColor.h"

#define degreesToRadian(angle) (M_PI * (angle) / 180.0)

//控制最大最小長度, 以及每次迭代長度
#define maxLength 200.0f
#define minLength 2.0f
#define lengthIteration 8.0f

//每次旋轉角度
#define rotateIteration 4.0f

//動畫的 fps 設定, 以及最長最短時要停留的 frame 張數
#define framePerSecond 60.0f
#define maxWaitingSecond 0.5f

typedef enum {
    CricleLengthStatusDecrease,
    CricleLengthStatusIncrease,
    CricleLengthStatusWaiting
} CricleLengthStatus;

@interface DaiInboxView ()

//當前長度, 旋轉角度, 狀態
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger rotateAngle;
@property (nonatomic, assign) CricleLengthStatus status;

//變換的顏色, default 是 紅 -> 綠 -> 黃 -> 藍, 以及當前在哪一個顏色上
@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, strong) UIColor *finalColor;
@property (nonatomic, strong) UIColor *prevColor;
@property (nonatomic, strong) UIColor *gradualColor;

//已等待時間
@property (nonatomic, assign) NSTimeInterval waitingSecond;

//固定的中心點及半徑, 不需每次計算
@property (nonatomic, assign) CGPoint circleCenter;
@property (nonatomic, assign) CGFloat circleRadius;

//預先畫好的圈圈
@property (nonatomic, strong) UIImage *circleImage;

@property (nonatomic, strong) DaiInboxDisplayLink *displayLink;

@end

@implementation DaiInboxView

#pragma mark - DaiInboxDisplayLinkDelegate

//用更合理的概念來做動畫這一個部分
//以 rotateIteration 來說的話, 我們假設在 fps 60 也就是約 0.01666666666 秒要移動 4.0f 個角度
//但是在真實的世界裡, 也許有時候會比這個數值多, 有時候則會少
//於是我們需要用另一種更合理的概念來實現, 這邊的 deltaTime 會傳回幀與幀之前的間隔時間,
//我假設當這個數值 > 60fps 時, 則以全速來跑, 反之, 則依比例縮減他們的變動
//效果可以讓動畫看起來比較不會有違和感
- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime {
    __weak DaiInboxView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            __strong DaiInboxView *strongSelf = weakSelf;
            
            CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / framePerSecond));
            
            switch (strongSelf.status) {
                case CricleLengthStatusDecrease:
                {
                    strongSelf.length -= lengthIteration * deltaValue;
                    strongSelf.rotateAngle += rotateIteration * deltaValue;
                    
                    //當長度扣到過短時, 讓他停下來, 設定好顏色, 準備另一個階段
                    if (strongSelf.length <= minLength) {
                        strongSelf.length = minLength;
                        strongSelf.status = CricleLengthStatusWaiting;
                        strongSelf.colorIndex++;
                        strongSelf.colorIndex %= [strongSelf.hudColors count];
                        strongSelf.prevColor = strongSelf.finalColor;
                        strongSelf.finalColor = strongSelf.hudColors[strongSelf.colorIndex];
                    }
                    break;
                }
                    
                case CricleLengthStatusIncrease:
                {
                    strongSelf.length += lengthIteration * deltaValue;
                    CGFloat deltaLength = sin(((float)lengthIteration / 360) * M_PI_2) * 360;
                    strongSelf.rotateAngle += (rotateIteration + deltaLength) * deltaValue;
                    
                    //長度過長時, 讓他停下來, 準備去另一個階段
                    if (strongSelf.length >= maxLength) {
                        strongSelf.length = maxLength;
                        strongSelf.status = CricleLengthStatusWaiting;
                    }
                    break;
                }
                    
                case CricleLengthStatusWaiting:
                {
                    strongSelf.waitingSecond += deltaTime;
                    strongSelf.rotateAngle += rotateIteration * deltaValue;
                    
                    //這個狀態下需要多算一個漸變色
                    if (strongSelf.length == minLength) {
                        CGFloat colorAPercent = ((float)strongSelf.waitingSecond / maxWaitingSecond);
                        CGFloat colorBPercent = 1 - colorAPercent;
                        UIColor *transparentColorA = [strongSelf.finalColor colorWithAlphaComponent:colorAPercent];
                        UIColor *transparentColorB = [strongSelf.prevColor colorWithAlphaComponent:colorBPercent];;
                        strongSelf.gradualColor = [transparentColorA mixColor:transparentColorB];
                    }
                    
                    //當幀數到達指定的數量, 按照他的狀態, 分配他該去的狀態
                    if (strongSelf.waitingSecond >= maxWaitingSecond) {
                        strongSelf.waitingSecond = 0;
                        if (strongSelf.length == minLength) {
                            strongSelf.status = CricleLengthStatusIncrease;
                        }
                        else {
                            strongSelf.status = CricleLengthStatusDecrease;
                        }
                    }
                    break;
                }
            }
            strongSelf.rotateAngle %= 360;
            strongSelf.circleImage = [strongSelf preDrawCircleImage];
            
            //算完以後回 main thread 囉
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.transform = CGAffineTransformMakeRotation(degreesToRadian(strongSelf.rotateAngle));
                [strongSelf setNeedsDisplay];
            });
        }
    });
}

#pragma mark - private

- (UIImage *)preDrawCircleImage {
    UIImage *circleImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, self.bounds.size.height), 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //設定線條的粗細, 以及圓角
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.hudLineWidth);
    
    //設定線條的顏色, 只有在最短狀態的時候才需要用漸變色
    if (self.status == CricleLengthStatusWaiting && self.length == minLength) {
        CGContextSetRGBStrokeColor(context, self.gradualColor.r, self.gradualColor.g, self.gradualColor.b, self.gradualColor.a);
    }
    else {
        CGContextSetRGBStrokeColor(context, self.finalColor.r, self.finalColor.g, self.finalColor.b, self.finalColor.a);
    }
    
    //設定半弧的中心, 半徑, 起始以及終點
    CGFloat deltaLength = sin(((float)self.length / 360) * M_PI_2) * 360;
    CGFloat startAngle = degreesToRadian(-deltaLength);
    CGContextAddArc(context, self.circleCenter.x, self.circleCenter.y, self.circleRadius, startAngle, 0, 0);
    
    //著色
    CGContextStrokePath(context);
    circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

#pragma mark - method override

//這邊主要就只負責把圖畫出來
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.circleImage drawInRect:rect];
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始值
        self.backgroundColor = [UIColor clearColor];
        self.rotateAngle = arc4random() % 360;
        self.length = maxLength;
        self.status = CricleLengthStatusDecrease;
        self.waitingSecond = 0;
        self.circleCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        self.circleRadius = frame.size.width / 3;
        self.displayLink = [[DaiInboxDisplayLink alloc] initWithDelegate:self];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    //從 newSuperview 的有無可以判斷現在是被加入或是被移除
    if (newSuperview) {
        self.colorIndex = arc4random() % [self.hudColors count];
        self.finalColor = self.hudColors[self.colorIndex];
        self.circleImage = [self preDrawCircleImage];
    }
    else {
        [self.displayLink removeDisplayLink];
    }
}

@end
