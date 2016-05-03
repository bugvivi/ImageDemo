//
//  CanvasView.m
//  coreImage_test
//
//  Created by ghostpf on 15/8/26.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    _points = [NSMutableArray array];
    CGPoint point = [touch locationInView:self];
    [_points addObject:[NSValue valueWithCGPoint:point]];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [_points addObject:[NSValue valueWithCGPoint:point]];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
    self.block(_points);
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    
    CGContextBeginPath(context);
    
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    NSValue * beginPoint = _points.firstObject;
    CGContextMoveToPoint(context, beginPoint.CGPointValue.x, beginPoint.CGPointValue.y);
    
    CGPoint *points = malloc(sizeof(CGPoint) * _points.count);
    for (int i = 0; i < _points.count; ++i) {
        points[i] = [[_points objectAtIndex:i] CGPointValue];
    }
    
    CGContextAddLines(context, points, _points.count);
    //连接上面定义的坐标点
        
    CGContextStrokePath(context);
    
}

@end
