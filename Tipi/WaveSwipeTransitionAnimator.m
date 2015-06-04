//
//  WaveSwipeTransitionAnimator.m
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WaveSwipeTransitionAnimator.h"
#import "SHPathLibrary.h"
#import "ShowOneGroupViewController.h"

@implementation WaveSwipeTransitionAnimator

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1
    self.transitionContext = transitionContext;
    
    //2
    UIView* containerView = [transitionContext containerView];
//    containerView.backgroundColor =  [UIColor colorWithRed:178/255.0  green:47/255.0 blue:43/255.0 alpha:1];
    containerView.backgroundColor = kListenBackgroundColor;
    
    UIViewController* fromViewController=  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController=  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //fromViewController.view.layer.backgroundColor = [UIColor orangeColor].CGColor;
    
    BOOL segueBack = [fromViewController isKindOfClass:[ShowOneGroupViewController class]] ;
    if(!segueBack){
        toViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(containerView.frame) * 0.2, 0);
    }
    
    //3
    [containerView addSubview: toViewController.view];
    
    //4
    
    //TODO reverse
    UIBezierPath* circleMaskPathInitial = [SHPathLibrary pathForTransitionBeetweenRoomsAndStories:toViewController.view.frame segueBack:segueBack withFinalPath:NO];
    UIBezierPath* circleMaskPathFinal = [SHPathLibrary pathForTransitionBeetweenRoomsAndStories:toViewController.view.frame segueBack:segueBack withFinalPath:YES];
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
    [maskLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.785 :0.135 :0.15 :0.86]];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"growing"];
    
    
    //usingSpringWithDamping:0
    //initialSpringVelocity:0
    if(!segueBack){
        [UIView animateWithDuration:.3f
                              delay:.2f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformMakeTranslation(-200, 0);
                         } completion:nil];
    }
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .6f;
}


@end
