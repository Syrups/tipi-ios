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
}

- (IBAction)next:(id)sender {
    [(RecordViewController*)self.parentViewController openNameStoryPopin];
}

- (IBAction)close:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
