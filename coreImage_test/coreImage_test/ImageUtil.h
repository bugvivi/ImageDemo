//
//  ImageUtil.h
//  coreImage_test
//
//  Created by ghostpf on 15/8/27.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "header.h"


@interface ImageUtil : NSObject

+ (UIImage*)processImage:(UIImage*)inImage withColorMatrix:(const float*) f;


@end
