//
//  WalkthroughScreenViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WalkthroughScreenViewController.h"
#import "HomeBubble.h"

@interface WalkthroughScreenViewController ()

@end

@implementation WalkthroughScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeBubble* bubble = [[HomeBubble alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bubble];
    bubble.userInteractionEnabled = NO;
}



@end
