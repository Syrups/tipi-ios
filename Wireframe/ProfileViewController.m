//
//  ProfileViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendListViewController.h"
#import "HomeViewController.h"
#import "AnimationLibrary.h"

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
    self.pager.view.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.subviews[0] addSubview:self.pager.view];
    [self.view.subviews[0] sendSubviewToBack:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [AnimationLibrary animateBouncingView:self.addButton usingConstraint:self.addButtonYConstraint ofType:AnimationLibraryBottomSpaceConstraint relativeToSuperview:self.view];
    
    self.backButton.transform = CGAffineTransformMakeTranslation(0, -100);
    self.settingsButton.transform = CGAffineTransformMakeTranslation(0, -100);
    [UIView animateWithDuration:.6f delay:.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backButton.alpha = 1;
        self.settingsButton.alpha = 1;
        self.backButton.transform = CGAffineTransformIdentity;
        self.settingsButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)dismiss:(id)sender {
    HomeViewController* parent = (HomeViewController*)self.parentViewController;
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        parent.profileButton.hidden = NO;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
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

-(void)userManager:(UserManager *)manager successfullyFetchedUser:(User *)user{
}
- (void)userManager:(UserManager *)manager failedToFetchUserWithId:(NSUInteger)userId{
}

@end
