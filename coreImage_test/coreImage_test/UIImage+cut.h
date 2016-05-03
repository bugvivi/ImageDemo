//
//  UIImage+cut.h
//  coreImage_test
//
//  Created by ghostpf on 15/8/25.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (cut)

// 裁剪为圆形，以最小的边为直径
- (UIImage *)cutToCircle;
// 指定半径和圆心的位置裁剪
- (UIImage *)cutCircleWithRadius:(CGFloat)radius andCircleCenterInImageRect:(CGPoint)point;
// 指定矩形裁剪
- (UIImage *)cutRectangleWithRectInImage:(CGRect)rect;
// 任意裁剪 传入点的数组（NSValue包装CGPoint）
- (UIImage*)cropImageWithPath:(NSArray*)pointArr;

@end
