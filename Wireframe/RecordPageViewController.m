//
//  RecordPageViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordPageViewController.h"

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
        [self.imageView removeFromSuperview];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        self.imageView.bounds = CGRectMake(0, 0, self.view.frame.size.height * ratio, self.view.frame.size.height);
        
        scrollView.userInteractionEnabled = NO;
        
        scrollView.contentInset = UIEdgeInsetsZero;
        scrollView.contentSize = self.imageView.bounds.size;
        scrollView.zoomScale = (CGRectGetHeight(scrollView.bounds) / CGRectGetWidth(scrollView.bounds)) * (self.image.size.width / self.image.size.height);
        
        [scrollView addSubview:self.imageView];
        [self.view addSubview:scrollView];
        
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width/2-self.view.frame.size.width/2, 0);
        offsetCoefficient = scrollView.contentOffset.x;
        
        self.imagePanningEnabled = YES;
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .2f;
    self.motionManager.accelerometerUpdateInterval = .2f;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:[self gyroUpdateHandler]];
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
