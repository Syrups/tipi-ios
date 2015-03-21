//
//  AbortModalViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AbortModalViewController.h"
#import "StoryWIPSaver.h"

@interface AbortModalViewController ()

@end

@implementation AbortModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.saveButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.saveButton.layer.borderWidth = 1;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)discard:(id)sender {
    [[StoryWIPSaver sharedSaver] discard];
    UINavigationController* previous = (UINavigationController*)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [previous popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)save:(id)sender {
    [[StoryWIPSaver sharedSaver] save];
    
    UINavigationController* previous = (UINavigationController*)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [previous popToRootViewControllerAnimated:YES];
    }];
}

@end
