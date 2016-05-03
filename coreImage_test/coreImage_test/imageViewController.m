//
//  imageViewController.m
//  coreImage_test
//
//  Created by ghostpf on 15/8/27.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

#import "imageViewController.h"
#import "ImageUtil.h"

@interface imageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation imageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [ImageUtil processImage:[UIImage imageNamed:@"3.jpg"] withColorMatrix:colormatrix_yese];
    
}



@end
