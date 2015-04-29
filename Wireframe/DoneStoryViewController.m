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
    ((RecordViewController*)self.parentViewController).longPressRecognizer.enabled = NO;
    
}

- (IBAction)next:(id)sender {
    [(RecordViewController*)self.parentViewController openNameStoryPopin];
}

- (IBAction)close:(id)sender {
    self.parentViewController.view.userInteractionEnabled = YES;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    ((RecordViewController*)self.parentViewController).longPressRecognizer.enabled = YES;
}

@end
