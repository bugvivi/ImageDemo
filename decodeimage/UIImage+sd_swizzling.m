//
//  UIImage+sd_swizzling.m
//  decodeImageUrl
//
//  Created by ghostpf on 15/12/24.
//  Copyright © 2015年 ghostpf. All rights reserved.
//

#import "UIImage+sd_swizzling.h"
#import <objc/runtime.h>
#import "UIImage+MultiFormat.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"
#import <ImageIO/ImageIO.h>
#import "CodeAndDecode.h"


#ifdef SD_WEBP
#import "UIImage+WebP.h"
#endif

@implementation UIImage (sd_swizzling)

+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 框架本来的方法
        SEL sdSel = @selector(sd_imageWithData:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(swiz_sd_imageWithData:);
        //两个方法的Method
        Method sdMethod = class_getClassMethod([self class], sdSel);
        Method swizzMethod = class_getClassMethod([self class], swizzSel);
        // 交换实现
        method_exchangeImplementations(sdMethod, swizzMethod);

    });
}

+ (UIImage *)swiz_sd_imageWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
#warning 添加加密文件的解密
    if ([imageContentType isEqualToString:@"image/yjk_image"]) {
        
        data = [CodeAndDecode decodeWithData:data];
        // 解密后检查实际的数据格式
        imageContentType = [NSData sd_contentTypeForImageData:data];
    }

    if ([imageContentType isEqualToString:@"image/gif"]) {
        image = [UIImage sd_animatedGIFWithData:data];
    }
#ifdef SD_WEBP
    else if ([imageContentType isEqualToString:@"image/webp"])
    {
        image = [UIImage sd_imageWithWebPData:data];
    }
#endif
    else {
        image = [[UIImage alloc] initWithData:data];
        UIImageOrientation orientation = [self sd_imageOrientationFromImageData:data];
        if (orientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:orientation];
        }
    }
    
    
    return image;
}

+(UIImageOrientation)sd_imageOrientationFromImageData:(NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            int exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
                result = [self sd_exifOrientationToiOSOrientation:exifOrientation];
            } // else - if it's not set it remains at up
            CFRelease((CFTypeRef) properties);
        } else {
            //NSLog(@"NO PROPERTIES, FAIL");
        }
        CFRelease(imageSource);
    }
    return result;
}

#pragma mark EXIF orientation tag converter
// Convert an EXIF image orientation to an iOS one.
// reference see here: http://sylvana.net/jpegcrop/exif_orientation.html
+ (UIImageOrientation) sd_exifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientationUp;
            break;
            
        case 3:
            orientation = UIImageOrientationDown;
            break;
            
        case 8:
            orientation = UIImageOrientationLeft;
            break;
            
        case 6:
            orientation = UIImageOrientationRight;
            break;
            
        case 2:
            orientation = UIImageOrientationUpMirrored;
            break;
            
        case 4:
            orientation = UIImageOrientationDownMirrored;
            break;
            
        case 5:
            orientation = UIImageOrientationLeftMirrored;
            break;
            
        case 7:
            orientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return orientation;
}

@end
