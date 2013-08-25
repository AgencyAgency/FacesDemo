//
//  PDCViewController.m
//  FacesDemo
//
//  Created by koba on 8/24/13.
//  Copyright (c) 2013 Pas de Chocolat, LLC. All rights reserved.
//

#import "PDCViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PDCViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *smilingImageView;
@property (weak, nonatomic) IBOutlet UIView *detectionView;
@end

@implementation PDCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self findFacesInFaceImageView:self.smilingImageView];
}

- (void)drawFaceBoundsForFaceFeature:(CIFaceFeature *)faceFeature
{
    // create a UIView using the bounds of the face
    UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
    
    // add a border around the newly created UIView
    faceView.layer.borderWidth = 1;
    faceView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // add the new view to create a box around the face
    [self.detectionView addSubview:faceView];
}

- (void)drawEyeForFaceFeature:(CIFaceFeature *)faceFeature atPosition:(CGPoint)position
{
    CGFloat faceWidth = faceFeature.bounds.size.width;
    CALayer *eyeLayer = [CALayer layer];
    eyeLayer.frame = CGRectMake(0, 0, faceWidth*0.3, faceWidth*0.3);
    eyeLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    eyeLayer.position = position;
    eyeLayer.cornerRadius = faceWidth * 0.15;
    [self.detectionView.layer addSublayer:eyeLayer];
}

- (void)drawEyesForFaceFeature:(CIFaceFeature *)faceFeature
{
    if(faceFeature.hasLeftEyePosition)
    {
        [self drawEyeForFaceFeature:faceFeature atPosition:faceFeature.leftEyePosition];
    }
    
    if(faceFeature.hasRightEyePosition)
    {
        [self drawEyeForFaceFeature:faceFeature atPosition:faceFeature.rightEyePosition];
    }
}

- (void)drawMouthForFaceFeature:(CIFaceFeature *)faceFeature
{    
    if(faceFeature.hasMouthPosition)
    {
        CGFloat faceWidth = faceFeature.bounds.size.width;
        CALayer *mouthLayer = [CALayer layer];
        mouthLayer.frame = CGRectMake(0, 0, faceWidth*0.4, faceWidth*0.4);
        mouthLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        mouthLayer.position = faceFeature.mouthPosition;
        mouthLayer.cornerRadius = faceWidth * 0.2;
        [self.detectionView.layer addSublayer:mouthLayer];
    }
}

-(void)findFacesInFaceImageView:(UIImageView *)faceImageView
{
    // Create Core Image object for the image with faces in it:
    CIImage* image = [CIImage imageWithCGImage:faceImageView.image.CGImage];

    // Create a face detector. Still image detection can use high accuracy.
    // High Accuracy takes longer.
    NSDictionary *detectorOptions = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                                forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:detectorOptions];

    // Get all detected faces in the image:
    NSArray* features = [detector featuresInImage:image];

    // Iterate through the detected faces and show the features:
    for(CIFaceFeature* faceFeature in features)
    {
        [self drawFaceBoundsForFaceFeature:faceFeature];
        [self drawEyesForFaceFeature:faceFeature];
        [self drawMouthForFaceFeature:faceFeature];
    }
    
    // Flip detection view on y-axis to match coordinate system used by Core Image:
    [self.detectionView setTransform:CGAffineTransformMakeScale(1, -1)];
}


@end
