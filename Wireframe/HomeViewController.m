//
//  HomeViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseHomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView* v in self.view.subviews) {
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    // Create it.
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // Point the datasource back to this UIViewController.
    self.pager.dataSource = self;
    
    // Start at the first page of the array?
    int initialIndex = 0;
    
    // Assuming you have a SomePageViewController which extends UIViewController so you can do custom things.
    BaseHomeViewController *initialViewController = (BaseHomeViewController *)[self viewControllerAtIndex:initialIndex];
    NSArray *initialViewControllers = [NSArray arrayWithObject:initialViewController];
    
    // animated:NO is important so the view just pops into existence.
    // direction: doesn't matter because it's not animating in.
    [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Tell the child view to get ready
    [self.pager willMoveToParentViewController:self];
    
    // Actually add the child view controller
    [self addChildViewController:self.pager];
    
    // Don't forget to add the new root view to the current view hierarchy!
    [self.view addSubview:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
}

// Some number
#define MAX_PAGES 5

// Factory method
- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0) {
        return nil;
    }
    if (i>=MAX_PAGES) {
        return nil;
    }
    
    // Assuming you have SomePageViewController.xib
    BaseHomeViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: @"BaseHomeViewController"];
    newController.idx = i;
    
    return newController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BaseHomeViewController *p = (BaseHomeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BaseHomeViewController *p = (BaseHomeViewController *)viewController;
    return [self viewControllerAtIndex:(p.idx + 1)];
}



-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
