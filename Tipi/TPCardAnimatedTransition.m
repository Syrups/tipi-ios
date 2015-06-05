//
//  TPCardAnimatedTransition.m
//  Tipi
//
//  Created by Glenn Sonna on 03/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "TPCardAnimatedTransition.h"
#import "CardViewController.h"

@interface TPCardAnimatedTransition ()

@end

@implementation TPCardAnimatedTransition

static CGFloat const kChildViewPadding = 16;
static CGFloat const kDamping = 0.75;
static CGFloat const kInitialSpringVelocity = 0.5;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .4f;
}

/// Slide views horizontally, with a bit of space between, while fading out and in.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    CardViewController* toViewController = (CardViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CardViewController* fromViewController = (CardViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // When sliding the views horizontally in and out, figure out whether we are going left or right.
    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
    BOOL forward = !goingRight;
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);
    
    CardViewController* toViewControllerNext = goingRight ? fromViewController.next : toViewController.next;
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (forward)
        [[transitionContext containerView] sendSubviewToBack:toViewController.view];
    
    [[transitionContext containerView] addSubview:toViewControllerNext.view];
    [[transitionContext containerView] sendSubviewToBack:toViewControllerNext.view];
    
    if (forward) {
        toViewController.view.transform = CGAffineTransformMakeScale(.9f, .9f);
        toViewController.view.alpha = 0;
        toViewControllerNext.view.alpha = 0;
        
        toViewControllerNext.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.7f, .7f), CGAffineTransformMakeTranslation(toViewControllerNext.view.frame.size.width * .2, 0));
    } else {
        toViewController.view.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0), CGAffineTransformMakeTranslation(-toViewController.view.frame.size.width, 0));
        toViewController.view.alpha = 1;
        toViewControllerNext.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.85f, .85f), CGAffineTransformMakeTranslation(toViewControllerNext.view.frame.size.width * .1, 0));
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (forward) {
            fromViewController.view.transform = CGAffineTransformConcat(travel, CGAffineTransformMakeRotation(0));
            toViewController.view.transform = CGAffineTransformIdentity;
            toViewController.view.alpha = 1;
            toViewControllerNext.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.85f, .85f), CGAffineTransformMakeTranslation(toViewControllerNext.view.frame.size.width * .1, 0));
            toViewControllerNext.view.alpha = .4f;
            
        } else {
            toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            fromViewController.view.transform = CGAffineTransformMakeScale(.9f, .9f);
            toViewControllerNext.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.7f, .7f), CGAffineTransformMakeTranslation(toViewControllerNext.view.frame.size.width * .2, 0));
            fromViewController.view.alpha = 0;
        }
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:(travelDistance > 100) ];
        [toViewControllerNext.view removeFromSuperview];
    }];

}

@end

