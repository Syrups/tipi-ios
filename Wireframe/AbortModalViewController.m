//
//  AbortModalViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AbortModalViewController.h"
#import "StoryWIPSaver.h"

@implementation AbortModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.saveButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveButton.layer.borderWidth = 1;
}

- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)discard:(id)sender {
    [[StoryWIPSaver sharedSaver] discard];
    UINavigationController* previous = (UINavigationController*)self.parentViewController.navigationController;
    [self removeFromParentViewController];
    [previous popToRootViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [[StoryWIPSaver sharedSaver] save];
    
    UINavigationController* previous = (UINavigationController*)self.parentViewController.navigationController;
    [self removeFromParentViewController];
    [previous popToRootViewControllerAnimated:YES];

}

@end
