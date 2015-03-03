//
//  NewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryViewController.h"

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView* v in self.view.subviews) {
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
}


@end
