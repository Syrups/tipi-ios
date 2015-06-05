//
//  TPTiltingImageView.m
//  Tipi
//
//  Created by Leo on 04/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPTiltingImageView.h"

@implementation TPTiltingImageView {
    UIScrollView* scrollView;
    UIImageView* imageView;
    CGFloat offsetCoefficient;
}

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        
        CGFloat ratio = image.size.width / image.size.height;
        
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        scrollView.scrollEnabled = NO;
        scrollView.maximumZoomScale = 2;
        
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, frame.size.height * ratio, frame.size.height);
        imageView.bounds = CGRectMake(0, 0, frame.size.height * ratio, frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
        
        [self updateScrollViewZoomToMaximumForImage:image];
        
        scrollView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
        
        scrollView.contentInset = UIEdgeInsetsZero;
        scrollView.contentSize = imageView.bounds.size;
        scrollView.zoomScale = (CGRectGetWidth(scrollView.bounds) / CGRectGetHeight(scrollView.bounds)) * (self.image.size.width / self.image.size.height);
        
        scrollView.contentOffset = CGPointMake((scrollView.contentSize.width / 2.f) - (CGRectGetWidth(scrollView.bounds)) / 2.f, (scrollView.contentSize.height / 2.f) - (CGRectGetHeight(scrollView.bounds)) / 2.f);
        [self addSubview:scrollView];
        
        
        
        
        offsetCoefficient = scrollView.contentOffset.x;
        
        self.enabled = YES;
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.gyroUpdateInterval = .2f;
        self.motionManager.accelerometerUpdateInterval = .2f;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:[self gyroUpdateHandler]];
    }
    return self;
}

- (CGFloat)maximumZoomScaleForImage:(UIImage *)image
{
    return (CGRectGetHeight(scrollView.bounds) / CGRectGetWidth(scrollView.bounds)) * (image.size.width / image.size.height);
}

- (void)updateScrollViewZoomToMaximumForImage:(UIImage *)image
{
    CGFloat zoomScale = [self maximumZoomScaleForImage:image];
    
    scrollView.maximumZoomScale = zoomScale;
    scrollView.zoomScale = zoomScale;
}

- (void(^)(CMDeviceMotion *gyroData, NSError *error)) gyroUpdateHandler {
    return ^void(CMDeviceMotion* gyroData, NSError* error) {
        
        if (!self.enabled) return;
        
        CGFloat xRotationRate = gyroData.rotationRate.x;
        CGFloat yRotationRate = gyroData.rotationRate.y;
        CGFloat zRotationRate = gyroData.rotationRate.z;
        
        if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate)) && self.enabled)
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
