//
//  AnimationLibrary.m
//  Wireframe
//
//  Created by Leo on 16/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AnimationLibrary.h"

static const int kInitialYOffset = 100;
static const float totalBounceDuration = 1;

@implementation AnimationLibrary

+ (void)animateBouncingView:(UIView*)view {
    view.transform = CGAffineTransformMakeTranslation(0, kInitialYOffset);
    view.alpha = 0;
    [UIView animateKeyframesWithDuration:totalBounceDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.4f animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, -10);
            view.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:.4f relativeDuration:.4f animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, 8);
        }];
        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    } completion:nil];
}

+ (void)animateBouncingView:(UIView *)view usingConstraint:(NSLayoutConstraint *)constraint ofType:(AnimationLibraryConstraintType)type relativeToSuperview:(UIView *)superview inverted:(BOOL)inverted {
    
    __block CGFloat initialConstant = constraint.constant;
    
    int factor = type == AnimationLibraryTopSpaceConstraint ? -1 : 1;
    
    if (inverted) factor = -factor;
    
    constraint.constant = initialConstant - kInitialYOffset * factor;
    view.alpha = 0;
    [superview layoutIfNeeded];
    [UIView animateKeyframesWithDuration:totalBounceDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.4f animations:^{
            constraint.constant = initialConstant + 15 * factor;
            view.alpha = 1;
            [superview layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.4f relativeDuration:.4f animations:^{
            constraint.constant = initialConstant - 10 * factor;
            [superview layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
            constraint.constant = initialConstant;
            [superview layoutIfNeeded];
        }];
        
    } completion:nil];
}

@end
