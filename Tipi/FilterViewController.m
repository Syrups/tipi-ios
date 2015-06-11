//
//  FilterViewController.m
//  Wireframe
//
//  Created by Leo on 09/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FilterViewController.h"
#import "ShowOneGroupViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController {
    NSUInteger currentTab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentTab = 0;
    
    // Create it.
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // Point the datasource back to this UIViewController.
    self.pager.dataSource = self;
    self.pager.delegate = self;
    
    UIViewController *initialViewController = [self viewControllerAtIndex:(int)currentTab];
    NSArray *initialViewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.pager willMoveToParentViewController:self];
    
    [self addChildViewController:self.pager];
    
    // Don't forget to add the new root view to the current view hierarchy!
    self.pager.view.frame = CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height - 120);
    [self.view addSubview:self.pager.view];
    [self.view sendSubviewToBack:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)dismiss:(id)sender {
    ShowOneGroupViewController* parent = (ShowOneGroupViewController*)self.parentViewController;
    [parent applyFilters]; // apply filters that were eventually set with two child VCs
    
    //[self.view removeFromSuperview];
    //[self removeFromParentViewController];
    
    [self.navigationController popViewControllerAnimated: YES];
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    
    ShowOneGroupViewController* parent = (ShowOneGroupViewController*)self.parentViewController;
    [parent applyFilters];
}


- (IBAction)toFilterUser:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterUser"];
    [self.pager setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.filterTagButton.alpha = .5f;
    self.filterUserButton.alpha = 1;
}

- (IBAction)toFilterTag:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterTag"];
    [self.pager setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.filterTagButton.alpha = 1;
    self.filterUserButton.alpha = .5f;
}

#pragma mark - UIpageViewController

- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0 || i>=2) {
        return nil;
    }
    
    NSString * indentifier = i == 0 ? @"FilterUser" : @"FilterTag";
    
    UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: indentifier];
    if ([newController respondsToSelector:@selector(setRoom:)]) {
        [newController setValue:self.room forKey:@"room"];
    }
    
    return newController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([viewController.restorationIdentifier isEqualToString:@"FilterUser"]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if ([viewController.restorationIdentifier isEqualToString:@"FilterTag"]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    UIViewController* next = [pendingViewControllers objectAtIndex:0];
    
    if ([next.restorationIdentifier isEqualToString:@"FilterTag"]) {
        self.filterTagButton.alpha = 1;
        self.filterUserButton.alpha = .5f;
    } else {
        self.filterTagButton.alpha = .5f;
        self.filterUserButton.alpha = 1;
    }
}

@end
