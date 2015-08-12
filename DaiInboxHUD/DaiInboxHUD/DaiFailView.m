//
//  DaiFailView.m
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/12.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiFailView.h"
#import "UIColor+MixColor.h"

#define lengthIteration 1.6f
#define framePerSecond 60.0f

@interface DaiFailView ()

@property (nonatomic, strong) NSArray *drawPath;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, strong) DaiInboxDisplayLink *displayLink;
@property (nonatomic, strong) UIImage *checkmarkImage;

@end

@implementation DaiFailView

#pragma mark - DaiInboxDisplayLinkDelegate

- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime {
    __weak DaiFailView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            __strong DaiFailView *strongSelf = weakSelf;
            
            CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / framePerSecond));
            
            strongSelf.length += lengthIteration * deltaValue;
            strongSelf.checkmarkImage = [strongSelf preDrawCircleImage];
            
            //算完以後回 main thread 囉
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setNeedsDisplay];
            });
        }
    });
}

#pragma mark - private

- (CGFloat)distanceA:(CGPoint)pointA toB:(CGPoint)pointB {
    return sqrt(pow(fabs(pointA.x - pointB.x), 2) + pow(fabs(pointA.y - pointB.y), 2));
}

- (UIImage *)preDrawCircleImage {
    UIImage *circleImage;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, self.bounds.size.height), 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //設定線條的粗細, 以及圓角
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.hudLineWidth);
    
    //劃勾勾的線
    CGFloat length = self.length;
    for (NSInteger index = 0; index < self.drawPath.count; index++) {
        NSArray *subArray = self.drawPath[index];
        CGPoint firstPoint = [[subArray firstObject] CGPointValue];
        CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
        
        BOOL isBreak = NO;
        for (NSInteger subIndex = 0; subIndex < subArray.count - 1; subIndex++) {
            CGPoint pointA = [subArray[subIndex] CGPointValue];
            CGPoint pointB = [subArray[subIndex + 1] CGPointValue];
            CGFloat distance = [self distanceA:pointA toB:pointB];
            if (length < distance) {
                CGFloat percentA =  length / distance;
                CGFloat percentB = 1 - percentA;
                CGPoint newPoint = CGPointMake(pointA.x * percentB + pointB.x * percentA, pointA.y * percentB + pointB.y * percentA);
                CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
                isBreak = YES;
                break;
            }
            else {
                CGContextAddLineToPoint(context, pointB.x, pointB.y);
                length -= distance;
            }
        }
        
        if (isBreak) {
            break;
        }
    }
    CGContextSetRGBStrokeColor(context, self.hudCrossColor.r, self.hudCrossColor.g, self.hudCrossColor.b, self.hudCrossColor.a);
    
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
    [self.checkmarkImage drawInRect:rect];
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始值
        self.backgroundColor = [UIColor clearColor];
        self.drawPath = @[@[[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.15f, CGRectGetHeight(self.bounds) * 0.15f)], [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.85f, CGRectGetHeight(self.bounds) * 0.85f)]], @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.85f, CGRectGetHeight(self.bounds) * 0.15f)], [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.15f, CGRectGetHeight(self.bounds) * 0.85f)]]];
        self.length = 0;
        self.displayLink = [[DaiInboxDisplayLink alloc] initWithDelegate:self];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    //從 newSuperview 的有無可以判斷現在是被加入或是被移除
    if (!newSuperview) {
        [self.displayLink removeDisplayLink];
    }
}

@end
