//
//  UIImage+effectWithCoreImage.m
//  coreImage_test
//
//  Created by ghostpf on 15/8/25.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import "UIImage+effectWithCoreImage.h"

@implementation UIImage (effectWithCoreImage)


- (UIImage *)effectWithEffectName:(NSString *)name
{
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:name keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end
