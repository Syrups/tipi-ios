//
//  ReadStoryTransitionAnimator.m
//  Tipi
//
//  Created by Glenn Sonna on 02/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ReadStoryTransitionAnimator.h"

@implementation ReadStoryTransitionAnimator


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1
    self.transitionContext = transitionContext;
    
    //2
    UIView* containerView = [transitionContext containerView];
 
     UIViewController* fromViewController=  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController=  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    toViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}


@end
