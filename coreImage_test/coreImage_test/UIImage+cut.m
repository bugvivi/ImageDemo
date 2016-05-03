//
//  UIImage+cut.m
//  coreImage_test
//
//  Created by ghostpf on 15/8/25.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import "UIImage+cut.h"

@implementation UIImage (cut)

- (UIImage *)cutToCircle
{
    CGFloat radius = MIN(self.size.width, self.size.height)*0.5;
    CGFloat centerX = self.size.width*0.5;
    CGFloat centerY = self.size.height*0.5;
    
    UIImage *oldImage = self;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width*self.scale, self.size.height*self.scale), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();       
    
    CGContextAddArc(context,centerX , centerY, radius, 0, M_PI*2, 0);
    CGContextClip(context);
    [oldImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cutCircleWithRadius:(CGFloat)radius andCircleCenterInImageRect:(CGPoint)point
{
    UIImage *oldImage = self;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius*self.scale, 2*radius*self.scale), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, radius, radius, radius, 0, M_PI*2, 0);
    CGContextClip(context);
    [oldImage drawInRect:CGRectMake(-point.x+radius, -point.y+radius, self.size.width, self.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 剪切矩形
- (UIImage *)cutRectangleWithRectInImage:(CGRect)rect
{
    UIImage *oldImage = self;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width*self.scale, rect.size.height*self.scale), NO, 0.0);

    [oldImage drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


// 任意裁剪
- (UIImage*)cropImageWithPath:(NSArray*)pointArr
{
    if (pointArr.count == 0) {
        return nil;
    }
    
    CGPoint *points = malloc(sizeof(CGPoint) * pointArr.count);
    for (int i = 0; i < pointArr.count; ++i) {
        points[i] = [[pointArr objectAtIndex:i] CGPointValue];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * self.scale, self.size.height * self.scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextAddLines(context, points, pointArr.count);
    CGContextClosePath(context);
    CGRect boundsRect = CGContextGetPathBoundingBox(context);
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(boundsRect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, boundsRect.size.width, boundsRect.size.height));
    
    CGMutablePathRef  path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-boundsRect.origin.x, -boundsRect.origin.y);
    CGPathAddLines(path, &transform, points, pointArr.count);
    
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    [self drawInRect:CGRectMake(-boundsRect.origin.x, -boundsRect.origin.y, self.size.width * self.scale, self.size.height * self.scale)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
