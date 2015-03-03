//
//  HomeViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView* v in self.view.subviews) {
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
