//
//  DoneStoryViewController.m
//  Wireframe
//
//  Created by Leo on 16/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "DoneStoryViewController.h"
#import "RecordViewController.h"

@implementation DoneStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGRect frame = self.popin.frame;
//    frame.origin.y = self.view.frame.size.height;
//    self.popin.frame = frame;
//    
//    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.1f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CGRect frame = self.popin.frame;
//        frame.origin.y = self.view.frame.size.height/2 - self.popin.frame.size.height/2;
//        self.popin.frame = frame;
//    } completion:nil];
    
    // disable interaction with the background controller
//    ((RecordViewController*)self.parentViewController).longPressRecognizer.enabled = NO;
    
    self.centerYConstraint.constant = self.view.frame.size.height;
    [self.view layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6f animations:^{
            self.centerYConstraint.constant = -30;
            [self.view layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:.6f relativeDuration:.4f animations:^{
            self.centerYConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    } completion:nil];
    
}

- (IBAction)next:(id)sender {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.7f initialSpringVelocity:.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerYConstraint.constant = -self.view.frame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.parentViewController performSelector:@selector(openNameStoryPopin) withObject:nil];
    }];
}

- (IBAction)close:(id)sender {
    self.parentViewController.view.userInteractionEnabled = YES;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5f animations:^{
            self.centerYConstraint.constant = 30;
            [self.view layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:.5f relativeDuration:.5f animations:^{
            self.centerYConstraint.constant = -self.view.frame.size.height;
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
    
//    ((RecordViewController*)self.parentViewController).longPressRecognizer.enabled = YES;
}

@end
