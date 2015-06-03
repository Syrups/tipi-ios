//
//  NewStoryMainController.m
//  Wireframe
//
//  Created by Leo on 13/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryMainController.h"
#import "AbortModalViewController.h"
#import "HomeViewController.h"

@implementation NewStoryMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)displayAbortModal:(id)sender {
    AbortModalViewController* vc = (AbortModalViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AbortModal"];
    
    vc.view.frame = self.view.frame;
    vc.view.alpha = 0;
    
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.2f animations:^{
        vc.view.alpha = 1;
    }];
}

- (IBAction)popCurrentController:(id)sender {
    UINavigationController* nav = (UINavigationController*)self.childViewControllers[0];
    
    // If we are at the first view controller, pop to the home
    if ([[nav visibleViewController] isEqual:[nav.viewControllers objectAtIndex:0]]) {

        HomeViewController* home = (HomeViewController*)[self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [home.storyViewController transitionFromStoryBuilder];
    } else {
        [nav popViewControllerAnimated:NO];
    }
    
}

@end
