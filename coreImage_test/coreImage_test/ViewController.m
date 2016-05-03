//
//  ViewController.m
//  coreImage_test
//
//  Created by ghostpf on 15/8/25.
//  Copyright (c) 2015年 ghostpf. All rights reserved.
//

//(
// CIAccordionFoldTransition,
// CIAdditionCompositing,
// CIAffineClamp,
// CIAffineTile,
// CIAffineTransform,
// CIAreaHistogram,
// CIAztecCodeGenerator,
// CIBarsSwipeTransition,
// CIBlendWithAlphaMask,
// CIBlendWithMask,
// CIBloom,
// CIBumpDistortion,
// CIBumpDistortionLinear,
// CICheckerboardGenerator,
// CICircleSplashDistortion,
// CICircularScreen,
// CICode128BarcodeGenerator,
// CIColorBlendMode,
// CIColorBurnBlendMode,
// CIColorClamp,
// CIColorControls,
// CIColorCrossPolynomial,
// CIColorCube,
// CIColorCubeWithColorSpace,
// CIColorDodgeBlendMode,
// CIColorInvert,
// CIColorMap,
// CIColorMatrix,
// CIColorMonochrome,
// CIColorPolynomial,
// CIColorPosterize,
// CIConstantColorGenerator,
// CIConvolution3X3,
// CIConvolution5X5,
// CIConvolution9Horizontal,
// CIConvolution9Vertical,
// CICopyMachineTransition,
// CICrop,
// CIDarkenBlendMode,
// CIDifferenceBlendMode,
// CIDisintegrateWithMaskTransition,
// CIDissolveTransition,
// CIDivideBlendMode,
// CIDotScreen,
// CIEightfoldReflectedTile,
// CIExclusionBlendMode,
// CIExposureAdjust,
// CIFalseColor,
// CIFlashTransition,
// CIFourfoldReflectedTile,
// CIFourfoldRotatedTile,
// CIFourfoldTranslatedTile,
// CIGammaAdjust,
// CIGaussianBlur,
// CIGaussianGradient,
// CIGlassDistortion,
// CIGlideReflectedTile,
// CIGloom,
// CIHardLightBlendMode,
// CIHatchedScreen,
// CIHighlightShadowAdjust,
// CIHistogramDisplayFilter,
// CIHoleDistortion,
// CIHueAdjust,
// CIHueBlendMode,
// CILanczosScaleTransform,
// CILightenBlendMode,
// CILightTunnel,
// CILinearBurnBlendMode,
// CILinearDodgeBlendMode,
// CILinearGradient,
// CILinearToSRGBToneCurve,
// CILineScreen,
// CILuminosityBlendMode,
// CIMaskToAlpha,
// CIMaximumComponent,
// CIMaximumCompositing,
// CIMinimumComponent,
// CIMinimumCompositing,
// CIModTransition,
// CIMotionBlur,
// CIMultiplyBlendMode,
// CIMultiplyCompositing,
// CIOverlayBlendMode,
// CIPerspectiveCorrection,

// CIPhotoEffectChrome,
// CIPhotoEffectFade,
// CIPhotoEffectInstant,
// CIPhotoEffectMono,
// CIPhotoEffectNoir,
// CIPhotoEffectProcess,
// CIPhotoEffectTonal,
// CIPhotoEffectTransfer,

// CIPinchDistortion,
// CIPinLightBlendMode,
// CIPixellate,
// CIQRCodeGenerator,
// CIRadialGradient,
// CIRandomGenerator,
// CISaturationBlendMode,
// CIScreenBlendMode,
// CISepiaTone,
// CISharpenLuminance,
// CISixfoldReflectedTile,
// CISixfoldRotatedTile,
// CISmoothLinearGradient,
// CISoftLightBlendMode,
// CISourceAtopCompositing,
// CISourceInCompositing,
// CISourceOutCompositing,
// CISourceOverCompositing,
// CISRGBToneCurveToLinear,
// CIStarShineGenerator,
// CIStraightenFilter,
// CIStripesGenerator,
// CISubtractBlendMode,
// CISwipeTransition,
// CITemperatureAndTint,
// CIToneCurve,
// CITriangleKaleidoscope,
// CITwelvefoldReflectedTile,
// CITwirlDistortion,
// CIUnsharpMask,
// CIVibrance,
// CIVignette,
// CIVignetteEffect,
// CIVortexDistortion,
// CIWhitePointAdjust,
// CIZoomBlur
// ) 129个滤镜效果


#import "ViewController.h"
#import "CanvasView.h"
#import "UIImage+effectWithCoreImage.h"
#import "UIImage+cut.h"
#import "UIImage+rotation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UIImageView *iconV;

@property (strong,nonatomic) CanvasView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *filterName =   [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%ld",filterName.count);
    NSLog(@"%@",filterName);
    
    self.imageV.image = [UIImage imageNamed:@"3.jpg"];
    self.imageV.userInteractionEnabled = YES;
    
    __weak typeof(self) WeakSelf = self;
    _drawView = [[CanvasView alloc]initWithFrame:self.view.bounds];
    [self.imageV addSubview:_drawView];
    self.drawView.block = ^(NSArray * points){
        
        UIImage *image = [UIImage imageNamed:@"3.jpg"];
        
        CGFloat scaleW =  image.size.width / WeakSelf.imageV.frame.size.width;
        CGFloat scaleH =  image.size.height / WeakSelf.imageV.frame.size.height;
        NSMutableArray *pointsM = [NSMutableArray array];
        for (NSValue *point in points) {
            CGPoint cgpoint = point.CGPointValue;
            CGPoint imagePoint = CGPointMake(cgpoint.x*scaleW, cgpoint.y*scaleH);
            [pointsM addObject:[NSValue valueWithCGPoint:imagePoint]];
        }
        
        WeakSelf.iconV.image = [[[image cropImageWithPath:pointsM]rotateImageWithRadian:M_PI cropMode:enSvCropExpand]effectWithEffectName:@"CIPhotoEffectTonal"];
        
    };
}





- (UIImage *)effectWithImage:(UIImage *)image
{
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTonal" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end
