//
//  RecordPageViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RecordPageViewController.h"

@implementation RecordPageViewController {
    UIScrollView* scrollView;
    CGFloat offsetCoefficient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.image)
        [self.imageView setImage:self.image];
    
    CGFloat ratio = self.image.size.width / self.image.size.height;
    
    if (ratio > 1) { // portrait
        self.tiltingView = [[TPTiltingImageView alloc] initWithFrame:self.imageView.frame andImage:self.image];
        [self.imageView removeFromSuperview];
        [self.view addSubview:self.tiltingView];
    }
    
    [self.view bringSubviewToFront:self.overlay];
    [self.view bringSubviewToFront:self.recordTimer];
    [self.view bringSubviewToFront:self.replayButton];
    
    self.replayButton.transform = CGAffineTransformMakeScale(0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)replay:(id)sender {
    // replay on record view controller
    [self.parentViewController.parentViewController performSelector:@selector(replay:) withObject:nil];
}


@end
