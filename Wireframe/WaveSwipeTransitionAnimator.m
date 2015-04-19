//
//  WaveSwipeTransitionAnimator.m
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WaveSwipeTransitionAnimator.h"

@implementation WaveSwipeTransitionAnimator

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //1
    self.transitionContext = transitionContext;
    
    //2
    UIView* containerView = [transitionContext containerView];
    UIViewController* fromViewController=  [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController=  [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
   
    //var button = fromViewController.button
    CGRect baseFrame = CGRectMake(0, 0, 100, 100);
    
    //3
    [containerView addSubview: toViewController.view];
    
    //4
    UIBezierPath* circleMaskPathInitial = [UIBezierPath bezierPathWithRect:baseFrame];
    //var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
    CGPoint extremePoint = CGPointMake(0, 0 - CGRectGetHeight(toViewController.view.bounds));
    //CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
    float radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y));
    UIBezierPath* circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(baseFrame, -radius, -radius)];
    //UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
    
    //5
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = circleMaskPathFinal.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    //6
    //var maskLayerAnimation = CABasicAnimation(keyPath: "path")
    CABasicAnimation* maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];

    maskLayerAnimation.fromValue = (__bridge id)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"growing"];
    //maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    //self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
    
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    //self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

/*
- (void)morph {
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        animating = NO;
    }];
    
    CABasicAnimation* morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration = 0.2f;
    morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef from = shapeLayer.path;
    CGPathRef to = [self pathForLayer];
    
    morph.fromValue = (__bridge id)(from);
    morph.toValue = (__bridge id)(to);
    
    [shapeLayer addAnimation:morph forKey:@"growing"];
    [shapeLayer.modelLayer setPath:to];
    
    [CATransaction commit];
}*/



@end
