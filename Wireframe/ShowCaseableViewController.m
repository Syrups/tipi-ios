//
//  ShowCaseableViewController.m
//  Wireframe
//
//  Created by Leo on 17/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowCaseableViewController.h"

@implementation ShowCaseableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showcaseLayer = [[ShowCaseOverlay alloc] initWithFrame:self.view.frame];
    self.showcaseLayer.userInteractionEnabled = NO; // no interaction by default with the showcase
    [self.view addSubview:self.showcaseLayer];
}

@end
