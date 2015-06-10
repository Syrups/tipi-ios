//
//  AnimationLibrary.m
//  Wireframe
//
//  Created by Leo on 16/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AnimationLibrary.h"
#import <UIView+MTAnimation.h>

static const int kInitialYOffset = 100;
static const float totalBounceDuration = 1.2f;

@implementation AnimationLibrary

+ (void)animateBouncingView:(UIView*)view withDelay:(CGFloat)delay {
    int endY = view.frame.origin.y;
    
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + view.superview.frame.size.height, view.frame.size.width, view.frame.size.height)];
    [view setAlpha:0];
    [UIView animateWithDuration:.2f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [view setAlpha:1];
        [view setFrame:CGRectMake(view.frame.origin.x, endY + 50, view.frame.size.width, view.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView mt_animateWithViews:@[view] duration:1.3f delay:0 timingFunction:kMTEaseOutElastic animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x, endY, view.frame.size.width, view.frame.size.height)];
        } completion:nil];
    }];
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

+ (void)animateGizzlingView:(UIView *)view {
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformMakeTranslation(1 + arc4random_uniform(3), 1 + arc4random_uniform(3));
        }];
        [UIView addKeyframeWithRelativeStartTime:.2f relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformMakeTranslation(1 + arc4random_uniform(3), 1 -arc4random_uniform(3));
        }];
        [UIView addKeyframeWithRelativeStartTime:.4f relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformMakeTranslation(1-arc4random_uniform(3), 1+arc4random_uniform(3));
        }];
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformMakeTranslation(1-arc4random_uniform(3), 1+arc4random_uniform(3));
        }];
        [UIView addKeyframeWithRelativeStartTime:.8f relativeDuration:.2f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    } completion:nil];
}

+ (void)animateZoomBouncingView:(UIView *)view {
    [UIView animateKeyframesWithDuration:.4f delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            view.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:nil];
}

@end
