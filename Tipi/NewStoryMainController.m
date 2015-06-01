//
//  NewStoryMainController.m
//  Wireframe
//
//  Created by Leo on 13/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryMainController.h"
#import "AbortModalViewController.h"

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
    [(UINavigationController*)self.childViewControllers[0] popViewControllerAnimated:YES];
}

@end
