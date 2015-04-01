//
//  RecordPageViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordPageViewController.h"

@interface RecordPageViewController ()

@end

@implementation RecordPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.image)
        [self.imageView setImage:self.image];
}


@end
