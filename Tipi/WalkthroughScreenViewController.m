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
    
    NSLog(@"%d", self.index);
    
    [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Screen%d", self.index] owner:self options:nil];
    [self.view addSubview:self.screenView];
}



@end
