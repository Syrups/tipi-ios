//
//  HelpModalViewController.m
//  Wireframe
//
//  Created by Leo on 24/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HelpModalViewController.h"

@implementation HelpModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (IBAction)close:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
