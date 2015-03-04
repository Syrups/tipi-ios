//
//  AbortModalViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AbortModalViewController.h"

@interface AbortModalViewController ()

@end

@implementation AbortModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)discard:(id)sender {
    UINavigationController* previous = (UINavigationController*)self.presentingViewController;
    NSLog(@"%@", [previous class]);
    [self dismissViewControllerAnimated:YES completion:^{
        [previous popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)save:(id)sender {
    UINavigationController* previous = (UINavigationController*)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [previous popToRootViewControllerAnimated:YES];
    }];
}

@end
