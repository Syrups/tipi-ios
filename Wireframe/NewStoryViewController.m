//
//  NewStoryViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NewStoryViewController.h"
#import "StoryWIPSaver.h"

@interface NewStoryViewController ()

@end

@implementation NewStoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIView* v in self.view.subviews) {
        if (v.tag == 10) continue;
        
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if ([[StoryWIPSaver sharedSaver] saved]) {
        [self.mainButton setTitle:@"Continue story" forState:UIControlStateNormal];
        self.secondaryButton.hidden = NO;
    }
}


@end
