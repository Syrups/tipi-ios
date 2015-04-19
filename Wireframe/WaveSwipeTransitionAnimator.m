//
//  WaveSwipeTransitionAnimator.m
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WaveSwipeTransitionAnimator.h"
#import "SHPathLibrary.h"

@implementation WaveSwipeTransitionAnimator

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1
    self.transitionContext = transitionContext;
    
    //2
    UIView* containerView = [transitionContext containerView];
    UIViewController* fromViewController=  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController=  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
   
    //3
    [containerView addSubview: toViewController.view];
    
    //4
    
    //TODO reverse
    UIBezierPath* circleMaskPathInitial = [SHPathLibrary swipableRightCurvyBezierPathForRect:fromViewController.view.frame];
    UIBezierPath* circleMaskPathFinal = [SHPathLibrary swippedRightCurvyBezierPathForRect:toViewController.view.frame];
    
    //5
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = circleMaskPathFinal.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    //6
    CABasicAnimation* maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];

    maskLayerAnimation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"growing"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}


@end