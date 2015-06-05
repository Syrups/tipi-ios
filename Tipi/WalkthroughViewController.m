//
//  WalkthroughViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WalkthroughViewController.h"
#import "WalkthroughScreenViewController.h"
#import "HomeViewController.h"

#define SCREENS_COUNT 3

@interface WalkthroughViewController ()

@end

@implementation WalkthroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TPSwipableViewController* tps = [[TPSwipableViewController alloc] initWithViewControllers:[self instantiateViewControllers]];
    tps.delegate = self;
    tps.view.frame = self.view.frame;
    tps.view.backgroundColor = kCreateBackgroundColor;
    [self addChildViewController:tps];
    [self.view addSubview:tps.view];
    [tps didMoveToParentViewController:self];
    
}

- (NSArray*)instantiateViewControllers {
    NSMutableArray* viewControllers = [NSMutableArray array];
    
    for (int i = 0 ; i < SCREENS_COUNT ; i++) {
        CardViewController* vc = (CardViewController*)[self viewControllerAtIndex:i];
        vc.next = (CardViewController*)[self viewControllerAtIndex:i+1];
        [viewControllers addObject:vc];
    }
    
    // append fake home screen at the end
    
    CardViewController* last = [[CardViewController alloc] init];
    last.view.backgroundColor = kCreateBackgroundColor;
    last.view.frame = self.view.frame;
    
    [viewControllers addObject:last];
    
    return [viewControllers copy];
}

- (WalkthroughScreenViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= SCREENS_COUNT) {
        return nil;
    }
    
    WalkthroughScreenViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughScreen"];
    childViewController.index = index;
    
    return childViewController;
    
}

- (void)displayHome {
    HomeViewController* home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController setViewControllers:@[home] animated:NO];
}

#pragma mark - TPSwipable

- (void)swipableViewController:(TPSwipableViewController *)containerViewController didFinishedTransitionToViewController:(CardViewController *)viewController {
    if (viewController.next == nil) { // last
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayHome) userInfo:nil repeats:NO];
        
    }
}


@end
