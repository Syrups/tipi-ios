//
//  WaveToBottomTransitionAnimator.m
//  Wireframe
//
//  Created by Glenn Sonna on 06/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//


#import "WaveToBottomTransitionAnimator.h"
#import "SHPathLibrary.h"
#import "AdminRoomViewController.h"
#import "FilterViewController.h"

@implementation WaveToBottomTransitionAnimator


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1
    self.transitionContext = transitionContext;
    
    //2
    UIView* containerView = [transitionContext containerView];
    UIViewController* fromViewController=  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController=  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL segueBack = [fromViewController isKindOfClass:[FilterViewController class]] ;
    
    //3
    [containerView addSubview: toViewController.view];
    
    //4
    
    //TODO reverse
    UIBezierPath* circleMaskPathInitial = [SHPathLibrary
                                           pathForTransitionBeetweenStoriesAndAdmin:toViewController.view.frame
                                           segueBack:segueBack
                                           withFinalPath: NO];
    
    UIBezierPath* circleMaskPathFinal = [SHPathLibrary
                                         pathForTransitionBeetweenStoriesAndAdmin:toViewController.view.frame
                                         segueBack:segueBack
                                         withFinalPath: YES];
    
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
    
    [maskLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //[maskLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.37]];
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"growing"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
   //[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

@end
