//
//  CodeAnDecode.m
//  decodeImageUrl
//
//  Created by ghostpf on 15/12/22.
//  Copyright © 2015年 ghostpf. All rights reserved.
//

#import "CodeAndDecode.h"

@implementation CodeAndDecode

+ (NSData *)encodeWithfilePath:(NSString *)path
{
    NSData * fileData = [[NSData alloc]initWithContentsOfFile:path];
    
    return [self encodeWithData:fileData];
}

+(NSData *)encodeWithData:(NSData *)data
{
    NSData * fileDataBase64 = [data base64EncodedDataWithOptions:0];
    
    char *key = "123456";
    int len = strlen(key);
    int k;
    
    char *bytesTemp = malloc(fileDataBase64.length);
    
    [fileDataBase64 getBytes:bytesTemp length:fileDataBase64.length];
    
    
    char *bytes = malloc(fileDataBase64.length);
    char *result = bytes;
    
    
    for (long long i = 0 ; i < fileDataBase64.length; i++) {
        
        k = i%len;
        char byte = bytesTemp[i];
        char keyB = key[k];
        *result = byte^keyB;
        
        result++;
    }
    
    NSData * resultData = [[NSData alloc]initWithBytes:bytes length:fileDataBase64.length];
    //    NSLog(@"%@",resultData);
    
    return resultData;
}


+(NSData *)decodeWithData:(NSData *)data
{
    char *key = "123456";
    int len = strlen(key);
    int k;
    
    char *bytesTemp = malloc(data.length);
    
    [data getBytes:bytesTemp length:data.length];
    
    
    char *bytes = malloc(data.length);
    char *result = bytes;
    
    
    for (long long i = 0 ; i < data.length; i++) {
        
        k = i%len;
        char byte = bytesTemp[i];
        char keyB = key[k];
        *result = byte^keyB;
        
        result++;
    }
    
    NSData * dataBase64 = [[NSData alloc]initWithBytes:bytes length:data.length];
    
    NSData *resultData = [[NSData alloc]initWithBase64EncodedData:dataBase64 options:0];
//    NSLog(@"%@",resultData);
    
    return resultData;
    
    
}

@end
