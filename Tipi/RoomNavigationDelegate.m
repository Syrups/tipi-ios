//
//  CampToRoomNavigationDelegate.m
//  Wireframe
//
//  Created by Glenn Sonna on 18/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AdminRoomViewController.h"
#import "RoomNavigationDelegate.h"
#import "ShowOneGroupViewController.h"
#import "WaveSwipeTransitionAnimator.h"
#import "WaveToBottomTransitionAnimator.h"
#import "FilterViewController.h"
#import "ReadModeContainerViewController.h"
#import "CreateRoomViewController.h"

#import "ReadStoryTransitionAnimator.h"



@implementation RoomNavigationDelegate

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    //[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //[self.navigationController.view addGestureRecognizer:recognizer];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    
        /*if (operation == UINavigationControllerOperationPush)
            return [[PushAnimator alloc] init];
        
        if (operation == UINavigationControllerOperationPop)
            return [[PopAnimator alloc] init];*/
        
    if([toVC isKindOfClass:[ReadModeContainerViewController class]]
       || [fromVC isKindOfClass:[ReadModeContainerViewController class]]){
         return [[ReadStoryTransitionAnimator alloc]init];
    } else if( [toVC isKindOfClass:[FilterViewController class]] || [fromVC isKindOfClass:[FilterViewController class]]
              || [toVC isKindOfClass:[AdminRoomViewController class]] || [fromVC isKindOfClass:[AdminRoomViewController class]]){
        return [[WaveToBottomTransitionAnimator alloc]initWithOperation:operation];
    } else if( [toVC isKindOfClass:[ShowOneGroupViewController class]]
       || [fromVC isKindOfClass:[ShowOneGroupViewController class]]){
        return [[WaveSwipeTransitionAnimator alloc]init];
    } else if( [toVC isKindOfClass:[CreateRoomViewController class]]
              || [fromVC isKindOfClass:[CreateRoomViewController class]]){
        return [[WaveSwipeTransitionAnimator alloc]init];
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactionController;
}

//1
- (void)panned:(UIPanGestureRecognizer*)gestureRecognizer{
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.navigationController.view];
    
    BOOL toRight = velocity.x > 0;
    BOOL popingBack = self.navigationController.viewControllers.count > 1;
    
    
    NSLog(@"gesture went %@", toRight ? @"->" : @"<-");
    
    switch(gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan :
            
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            
            if (popingBack) {
                if (toRight){
                    [self.navigationController popViewControllerAnimated: YES];
                }
            } else {
                if (!toRight){
                    [self.navigationController.topViewController performSegueWithIdentifier: @"ToGroupSegue" sender: nil];
                }
            }
            
            break;
        case UIGestureRecognizerStateChanged :
            
            //Bug if I remove it
            [gestureRecognizer translationInView:self.navigationController.view];
            
            int factor = popingBack ? -1 : 1;
            
            CGPoint translation = [gestureRecognizer translationInView:self.navigationController.view];
            
            float completionProgress = translation.x/((CGRectGetWidth(self.navigationController.view.bounds)) * factor);
            [self.interactionController updateInteractiveTransition: completionProgress];
            
            break;
            
        case UIGestureRecognizerStateEnded :
            
            if ([gestureRecognizer velocityInView:self.navigationController.view].x <= 0 && popingBack) {
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
