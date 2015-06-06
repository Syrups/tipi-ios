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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)setup{
    
    CGFloat ratio = self.image.size.width / self.image.size.height;
    
    imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = CGRectMake(0, 0, self.frame.size.height * ratio, self.frame.size.height);
    
    //        imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    
    imageView.bounds = CGRectMake(0, 0, self.frame.size.height * ratio, self.frame.size.height);
    
    scrollView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.contentSize = imageView.bounds.size;
    scrollView.zoomScale = (CGRectGetWidth(scrollView.bounds) / CGRectGetHeight(scrollView.bounds)) * (self.image.size.width / self.image.size.height);
    
    [scrollView addSubview:imageView];
    [self addSubview:scrollView];
    
    scrollView.contentOffset = CGPointMake(scrollView.contentSize.width/2-self.frame.size.width/2, 0);
    offsetCoefficient = scrollView.contentOffset.x;
    
    self.enabled = YES;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .2f;
    self.motionManager.accelerometerUpdateInterval = .2f;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:[self gyroUpdateHandler]];
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
