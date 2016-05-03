//
//  CodeAnDecode.h
//  decodeImageUrl
//
//  Created by ghostpf on 15/12/22.
//  Copyright © 2015年 ghostpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeAndDecode : NSObject

+ (NSData *)encodeWithfilePath:(NSString *)path;
+(NSData *)encodeWithData:(NSData *)data;
+(NSData *)decodeWithData:(NSData *)data;

@end
