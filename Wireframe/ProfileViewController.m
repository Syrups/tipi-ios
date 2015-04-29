//
//  ProfileViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendListViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = CurrentUser.username;
    
    // Create it.
    self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
     
    // Point the datasource back to this UIViewController.
    self.pager.dataSource = self;
    
    // Start at the first page of the array?
    int initialIndex = 0;
    
    UIViewController *initialViewController = [self viewControllerAtIndex:initialIndex];
    NSArray *initialViewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pager setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.pager willMoveToParentViewController:self];
    
    [self addChildViewController:self.pager];
    
    // Don't forget to add the new root view to the current view hierarchy!
    self.pager.view.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIpageViewController

- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0 || i>=2) {
        return nil;
    }
    
    NSString * indentifier = i == 0 ? @"FriendList" : @"RequestList";//ShowGroupsViewController
    
    UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: indentifier];
    
    return newController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self viewControllerAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self viewControllerAtIndex:1];
}

@end
