//
//  AbortModalViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AbortModalViewController.h"
#import "HomeViewController.h"
#import "StoryWIPSaver.h"

@implementation AbortModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popinVerticalCenterConstraint.constant = self.view.frame.size.height;
    [self.view layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:.6f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6f animations:^{
            self.popinVerticalCenterConstraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.4f animations:^{
            self.popinVerticalCenterConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            self.popinVerticalCenterConstraint.constant = 30;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            self.popinVerticalCenterConstraint.constant = -self.view.frame.size.height;
            [self.view layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
}

- (IBAction)discard:(id)sender {
    [[StoryWIPSaver sharedSaver] discard];
    UINavigationController* previous = (UINavigationController*)self.parentViewController.navigationController;
    [self removeFromParentViewController];
    [previous setViewControllers:@[previous.viewControllers[0]]];
    [((HomeViewController*)previous.viewControllers[0]).storyViewController transitionFromStoryBuilder];
    
}

- (IBAction)save:(id)sender {
    [[StoryWIPSaver sharedSaver] save];
    
    UINavigationController* previous = (UINavigationController*)self.parentViewController.navigationController;
    [self removeFromParentViewController];
    [previous setViewControllers:@[previous.viewControllers[0]]];
    [((HomeViewController*)previous.viewControllers[0]).storyViewController  transitionFromStoryBuilder];
}

@end
