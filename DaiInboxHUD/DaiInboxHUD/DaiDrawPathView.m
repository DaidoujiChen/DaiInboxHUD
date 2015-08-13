//
//  DaiDrawPathView.m
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/13.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiDrawPathView.h"
#import "UIColor+MixColor.h"

#define framePerSecond 60.0f

@interface DaiDrawPathView ()

@property (nonatomic, assign) CGFloat length;
@property (nonatomic, strong) DaiInboxDisplayLink *displayLink;
@property (nonatomic, strong) UIImage *pathImage;

@end

@implementation DaiDrawPathView

#pragma mark - DaiInboxDisplayLinkDelegate

- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime {
    __weak DaiDrawPathView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            __strong DaiDrawPathView *strongSelf = weakSelf;
            CGFloat deltaValue = MIN(1.0f, deltaTime / (1.0f / framePerSecond));
            strongSelf.length += self.lengthIteration * deltaValue;
            strongSelf.pathImage = [strongSelf preDrawPathImage];
            
            //算完以後回 main thread 囉
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setNeedsDisplay];
            });
        }
    });
}

#pragma mark - private instance method

- (CGFloat)distanceA:(CGPoint)pointA toB:(CGPoint)pointB {
    return sqrt(pow(fabs(pointA.x - pointB.x), 2) + pow(fabs(pointA.y - pointB.y), 2));
}

- (UIImage *)preDrawPathImage {
    UIImage *pathImage;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //設定線條的粗細, 以及圓角
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
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
    CGContextSetRGBStrokeColor(context, self.pathColor.r, self.pathColor.g, self.pathColor.b, self.pathColor.a);
    
    //著色
    CGContextStrokePath(context);
    pathImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pathImage;
}

#pragma mark - method override

//這邊主要就只負責把圖畫出來
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.pathImage drawInRect:rect];
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始值
        self.backgroundColor = [UIColor clearColor];
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
