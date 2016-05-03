//
//  NSData+sd_swizzling.m
//  decodeImageUrl
//
//  Created by ghostpf on 15/12/24.
//  Copyright © 2015年 ghostpf. All rights reserved.
//

#import "NSData+sd_swizzling.h"
#import <objc/runtime.h>
#import "NSData+ImageContentType.h"

@implementation NSData (sd_swizzling)

+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 框架本来的方法
        SEL sdSel = @selector(sd_contentTypeForImageData:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(swiz_sd_contentTypeForImageData:);
        //两个方法的Method
        Method sdMethod = class_getClassMethod([self class], sdSel);
        Method swizzMethod = class_getClassMethod([self class], swizzSel);
        // 交换实现
        method_exchangeImplementations(sdMethod, swizzMethod);

    });
}

+ (NSString *)swiz_sd_contentTypeForImageData:(NSData *)data {

    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
#warning 添加加密的文件格式
        case 0x1E: // jpg加密格式
        case 0x58: // png加密格式
            return @"image/yjk_image";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
    
    
}


@end
