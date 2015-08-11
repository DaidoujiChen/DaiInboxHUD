//
//  DaiSuccessView.m
//  DaiInboxHUD
//
//  Created by DaidoujiChen on 2015/8/11.
//  Copyright (c) 2015年 ChilunChen. All rights reserved.
//

#import "DaiSuccessView.h"
#import "UIColor+MixColor.h"

#define lengthIteration 0.8f
#define framePerSecond 60.0f

@interface DaiSuccessView ()

@property (nonatomic, strong) NSArray *drawPath;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, strong) DaiInboxDisplayLink *displayLink;
@property (nonatomic, strong) UIImage *checkmarkImage;

@end

@implementation DaiSuccessView

#pragma mark - DaiInboxDisplayLinkDelegate

- (void)displayWillUpdateWithDeltaTime:(CFTimeInterval)deltaTime {
    __weak DaiSuccessView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            __strong DaiSuccessView *strongSelf = weakSelf;
            
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
    CGFloat totalLength = 0;
    CGFloat length = self.length;
    CGPoint firstPoint = [[self.drawPath firstObject] CGPointValue];
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    for (NSInteger index = 0; index < self.drawPath.count - 1; index++) {
        CGPoint pointA = [self.drawPath[index] CGPointValue];
        CGPoint pointB = [self.drawPath[index + 1] CGPointValue];
        CGFloat distance = [self distanceA:pointA toB:pointB];
        totalLength += distance;
        if (length < distance) {
            CGFloat percentA =  length / distance;
            CGFloat percentB = 1 - percentA;
            CGPoint newPoint = CGPointMake(pointA.x * percentB + pointB.x * percentA, pointA.y * percentB + pointB.y * percentA);
            CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
            break;
        }
        else {
            CGContextAddLineToPoint(context, pointB.x, pointB.y);
            length -= distance;
        }
    }
    CGContextSetRGBStrokeColor(context, self.hudCheckmarkColor.r, self.hudCheckmarkColor.g, self.hudCheckmarkColor.b, self.hudCheckmarkColor.a);
    
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
        self.drawPath = @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.25f, CGRectGetHeight(self.bounds) * 0.5f)], [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.5f, CGRectGetHeight(self.bounds) * 0.75f)], [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds) * 0.85f, CGRectGetHeight(self.bounds) * 0.25f)]];
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
