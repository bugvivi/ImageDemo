//
//  CanvasView.h
//  coreImage_test
//
//  Created by ghostpf on 15/8/26.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchEndBlock)(NSArray * points);

@interface CanvasView : UIView

@property (nonatomic,strong,readonly) NSMutableArray *points;

@property (nonatomic,strong) TouchEndBlock block;


@end
