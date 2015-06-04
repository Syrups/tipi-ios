//
//  RecordPageViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordPageViewController.h"
#import "TPTiltingImageView.h"

@implementation RecordPageViewController {
    UIScrollView* scrollView;
    CGFloat offsetCoefficient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.image)
        [self.imageView setImage:self.image];
    
    CGFloat ratio = self.image.size.width / self.image.size.height;
    
    if (ratio > 1) { // portrait
        TPTiltingImageView* tiltingImageView = [[TPTiltingImageView alloc] initWithFrame:self.imageView.frame andImage:self.image];
        [self.imageView removeFromSuperview];
        [self.view addSubview:tiltingImageView];
    }
    
    [self.view bringSubviewToFront:self.overlay];
    [self.view bringSubviewToFront:self.recordTimer];
    [self.view bringSubviewToFront:self.replayButton];
    
    self.replayButton.transform = CGAffineTransformMakeScale(0, 0);
}

- (IBAction)replay:(id)sender {
    // replay on record view controller
    [self.parentViewController.parentViewController performSelector:@selector(replay:) withObject:nil];
}

- (void(^)(CMDeviceMotion *gyroData, NSError *error)) gyroUpdateHandler {
    return ^void(CMDeviceMotion* gyroData, NSError* error) {
        
        CGFloat xRotationRate = gyroData.rotationRate.x;
        CGFloat yRotationRate = gyroData.rotationRate.y;
        CGFloat zRotationRate = gyroData.rotationRate.z;
        
        if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate)) && self.imagePanningEnabled)
        {
            static CGFloat kRotationMultiplier = 5.f;
            CGFloat invertedYRotationRate = yRotationRate * -1;
            
            CGFloat interpretedXOffset = scrollView.contentOffset.x + (invertedYRotationRate  * kRotationMultiplier);
            
            CGPoint contentOffset = [self clampedContentOffsetForHorizontalOffset:interpretedXOffset];
                
            static CGFloat kMovementSmoothing = 0.3f;
            [UIView animateWithDuration:kMovementSmoothing
                                  delay:0.0f
                                options:UIViewAnimationOptionBeginFromCurrentState|
             UIViewAnimationOptionAllowUserInteraction|
             UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [scrollView setContentOffset:contentOffset animated:NO];
                             } completion:NULL];
        }
    
    };
}

- (CGPoint)clampedContentOffsetForHorizontalOffset:(CGFloat)horizontalOffset;
{
    CGFloat maximumXOffset = scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds);
    CGFloat minimumXOffset = 0.f;
    
    CGFloat clampedXOffset = fmaxf(minimumXOffset, fmin(horizontalOffset, maximumXOffset));
    CGFloat centeredY = (scrollView.contentSize.height / 2.f) - (CGRectGetHeight(scrollView.bounds)) / 2.f;
    
    return CGPointMake(clampedXOffset, centeredY);
}

@end
