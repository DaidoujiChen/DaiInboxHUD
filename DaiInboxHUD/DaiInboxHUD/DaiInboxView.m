//
//  DaiInboxView.m
//  DaiInboxHUD
//
//  Created by 啟倫 陳 on 2014/10/31.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiInboxView.h"

#import <objc/runtime.h>

#define degreesToRadian(angle) (M_PI * (angle) / 180.0)

//控制最大最小長度, 以及每次迭代長度
#define maxLength 200.0f
#define minLength 2.0f
#define lengthIteration 8.0f

//每次旋轉角度
#define rotateIteration 4.0f

//動畫的 fps 設定, 以及最長最短時要停留的 frame 張數
#define framePerSecond 60.0f
#define maxWaitingFrame 30.0f

typedef enum {
    CricleLengthStatusDecrease,
    CricleLengthStatusIncrease,
    CricleLengthStatusWaiting
} CricleLengthStatus;

@interface UIColor (MixColor)

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

- (UIColor *)mixColor:(UIColor *)otherColor;

@end

@implementation UIColor (MixColor)

@dynamic r, g, b, a;

- (CGFloat)r {
    return [[self rgba][@"r"] floatValue];
}

- (CGFloat)g {
    return [[self rgba][@"g"] floatValue];
}

- (CGFloat)b {
    return [[self rgba][@"b"] floatValue];
}

- (CGFloat)a {
    return [[self rgba][@"a"] floatValue];
}

- (UIColor *)mixColor:(UIColor *)otherColor {
    //混色的公式
    //http://stackoverflow.com/questions/726549/algorithm-for-additive-color-mixing-for-rgb-values
    CGFloat newAlpha = 1 - (1 - self.a) * (1 - otherColor.a);
    CGFloat newRed = self.r * self.a / newAlpha + otherColor.r * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newGreen = self.g * self.a / newAlpha + otherColor.g * otherColor.a * (1 - self.a) / newAlpha;
    CGFloat newBlue = self.b * self.a / newAlpha + otherColor.b * otherColor.a * (1 - self.a) / newAlpha;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

- (NSDictionary *)rgba {
    NSDictionary *rgba = objc_getAssociatedObject(self, _cmd);
    if (!rgba) {
        CGFloat red = 0.0f, green = 0.0f, blue = 0.0f, alpha = 0.0f;
        [self getRed:&red green:&green blue:&blue alpha:&alpha];
        [self setRgba:@{ @"r":@(red), @"g":@(green), @"b":@(blue), @"a":@(alpha) }];
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRgba:(NSDictionary *)rgba {
    objc_setAssociatedObject(self, @selector(rgba), rgba, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface DaiInboxView ()

//轉轉轉的 timer
@property (nonatomic, strong) NSTimer *circleTimer;

//當前長度, 旋轉角度, 狀態
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger rotateAngle;
@property (nonatomic, assign) CricleLengthStatus status;

//變換的顏色, default 是 紅 -> 綠 -> 黃 -> 藍, 以及當前在哪一個顏色上
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) NSInteger colorIndex;

//已等待張數
@property (nonatomic, assign) NSInteger waitingFrameCount;

@end

@implementation DaiInboxView

#pragma mark - private

//每 frame 所做的數值變動
- (void)refreshCricle {
    self.transform = CGAffineTransformMakeRotation(degreesToRadian(self.rotateAngle));
    
    switch (self.status) {
        case CricleLengthStatusDecrease:
        {
            self.length -= lengthIteration;
            self.rotateAngle += rotateIteration;
            
            if (self.length <= minLength) {
                self.length = minLength;
                self.status = CricleLengthStatusWaiting;
                self.colorIndex++;
            }
            break;
        }
            
        case CricleLengthStatusIncrease:
        {
            self.length += lengthIteration;
            CGFloat deltaLength = sin(((float)lengthIteration / 360) * M_PI_2) * 360;
            self.rotateAngle += (rotateIteration + deltaLength);
            
            if (self.length >= maxLength) {
                self.length = maxLength;
                self.status = CricleLengthStatusWaiting;
            }
            break;
        }
            
        case CricleLengthStatusWaiting:
        {
            self.waitingFrameCount++;
            self.rotateAngle += rotateIteration;
            
            if (self.waitingFrameCount == maxWaitingFrame) {
                self.waitingFrameCount = 0;
                if (self.length == minLength) {
                    self.status = CricleLengthStatusIncrease;
                }
                else {
                    self.status = CricleLengthStatusDecrease;
                }
            }
            break;
        }
    }
    
    self.rotateAngle %= 360;
    [self setNeedsDisplay];
}

#pragma mark - method override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //設定線條的粗細, 以及圓角
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2.0f);
    
    //設定線條的顏色
    UIColor *finalColor;
    switch (self.status) {
        case CricleLengthStatusDecrease:
        case CricleLengthStatusIncrease:
        {
            finalColor = self.colors[self.colorIndex % [self.colors count]];
            break;
        }
            
        case CricleLengthStatusWaiting:
        {
            if (self.length == minLength) {
                NSInteger prevIndex = (self.colorIndex - 1 + [self.colors count]) % [self.colors count];
                NSInteger currentIndex = self.colorIndex % [self.colors count];
                UIColor *opaqueColorA = self.colors[currentIndex];
                UIColor *opaqueColorB = self.colors[prevIndex];
                CGFloat colorAPercent = ((float)self.waitingFrameCount / maxWaitingFrame);
                CGFloat colorBPercent = 1 - colorAPercent;
                UIColor *transparentColorA = [UIColor colorWithRed:opaqueColorA.r green:opaqueColorA.g blue:opaqueColorA.b alpha:colorAPercent];
                UIColor *transparentColorB = [UIColor colorWithRed:opaqueColorB.r green:opaqueColorB.g blue:opaqueColorB.b alpha:colorBPercent];
                finalColor = [transparentColorA mixColor:transparentColorB];
            }
            else {
                finalColor = self.colors[self.colorIndex % [self.colors count]];
            }
            break;
        }
    }
    CGContextSetRGBStrokeColor(context, finalColor.r, finalColor.g, finalColor.b, finalColor.a);
    
    //設定半弧的中心, 半徑, 起始以及終點
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 3;
    CGFloat deltaLength = sin(((float)self.length / 360) * M_PI_2) * 360;
    CGFloat startAngle = degreesToRadian(-deltaLength);
    CGFloat endAngle = degreesToRadian(0);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    
    //著色
    CGContextStrokePath(context);
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始值
        self.backgroundColor = [UIColor clearColor];
        self.rotateAngle = 0;
        self.length = maxLength;
        self.status = CricleLengthStatusDecrease;
        self.colorIndex = 0;
        self.waitingFrameCount = 0;
        self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    //從 newSuperview 的有無可以判斷現在是被加入或是被移除
    if (newSuperview) {
        self.circleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / framePerSecond target:self selector:@selector(refreshCricle) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.circleTimer forMode:NSDefaultRunLoopMode];
    }
    else {
        [self.circleTimer invalidate];
    }
}

@end
