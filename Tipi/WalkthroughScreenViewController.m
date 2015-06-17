//
//  WalkthroughScreenViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WalkthroughScreenViewController.h"
#import "HomeBubble.h"
#import "PKAIDecoder.h"

@interface WalkthroughScreenViewController ()

@end

@implementation WalkthroughScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Screen%lu", (unsigned long)self.index] owner:self options:nil];
    [self.view addSubview:self.screenView];
    
//    switch (self.index) {
//        case 1:
//            [PKAIDecoder builAnimatedImageIn:self.illu fromFile:@"walk1" withAnimationDuration:3];
//            break;
//            
//        default:
//            break;
//    }
}



@end
