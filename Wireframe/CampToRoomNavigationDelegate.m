//
//  CampToRoomNavigationDelegate.m
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CampToRoomNavigationDelegate.h"
#import "WaveSwipeTransitionAnimator.h"



@implementation CampToRoomNavigationDelegate

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    //[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.navigationController.view addGestureRecognizer:recognizer];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    
    return [[WaveSwipeTransitionAnimator alloc]init];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactionController;
}


//1
- (void)panned:(UIPanGestureRecognizer*)gestureRecognizer{
    
    
    switch(gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan :
            
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated: YES];
            } else {
                [self.navigationController.topViewController performSegueWithIdentifier: @"ToGroupSegue" sender: nil];
            }
            
            break;
        case UIGestureRecognizerStateChanged :
            
            //Bug if I remove it
            [gestureRecognizer translationInView:self.navigationController.view];
            
            CGPoint translation = [gestureRecognizer translationInView:self.navigationController.view];
            
            float completionProgress = translation.x/CGRectGetWidth(self.navigationController.view.bounds );
            [self.interactionController updateInteractiveTransition: completionProgress];
            
            break;
            
        case UIGestureRecognizerStateEnded :
            
            if ([gestureRecognizer velocityInView:self.navigationController.view].x > 0) {
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
            
            break;
            
        default :
            [self.interactionController cancelInteractiveTransition];
            self.interactionController = nil;
            break;
    }
}

@end
