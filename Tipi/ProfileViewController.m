//
//  ProfileViewController.m
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"
#import "FriendListViewController.h"
#import "NewStoryViewController.h"
#import "AnimationLibrary.h"
#import "SHPathLibrary.h"

@implementation ProfileViewController {
    CAShapeLayer* maskLayer;
}

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
    self.pager.view.frame = CGRectMake(0, 120, self.view.frame.size.width, self.bodyView.frame.size.height - 80);
    [self.view.subviews[0] addSubview:self.pager.view];
    [self.view.subviews[0] sendSubviewToBack:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [AnimationLibrary animateBouncingView:self.addButton usingConstraint:self.addButtonYConstraint ofType:AnimationLibraryTopSpaceConstraint relativeToSuperview:self.addButton.superview inverted:NO];
    
    CGFloat initialConstant = self.friendsTabButtonYConstraint.constant;
    self.friendsTabButtonYConstraint.constant -= 50;
    self.friendsTabButton.alpha = 0;
    [self.friendsTabButton.superview layoutIfNeeded];
    [UIView animateWithDuration:.3f delay:.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.friendsTabButtonYConstraint.constant = initialConstant;
        self.friendsTabButton.alpha = 1;
        [self.friendsTabButton.superview layoutIfNeeded];
    } completion:nil];
    
    initialConstant = self.requestsTabButtonYConstraint.constant;
    self.requestsTabButtonYConstraint.constant -= 50;
    self.requestsTabButton.alpha = 0;
    [self.requestsTabButton.superview layoutIfNeeded];
    [UIView animateWithDuration:.3f delay:.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.requestsTabButtonYConstraint.constant = initialConstant;
        self.requestsTabButton.alpha = 1;
        [self.requestsTabButton.superview layoutIfNeeded];
    } completion:nil];
    
    self.backButton.transform = CGAffineTransformMakeTranslation(0, -80);
    self.settingsButton.transform = CGAffineTransformMakeTranslation(0, -80);
    [UIView animateWithDuration:.3f delay:.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backButton.alpha = 1;
        self.settingsButton.alpha = 1;
        self.backButton.transform = CGAffineTransformIdentity;
        self.settingsButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    maskLayer = [CAShapeLayer layer];
    
    maskLayer.path = [SHPathLibrary pathForProfileView:self.bodyView open:NO bumpDelta:0].CGPath;
    self.bodyView.layer.mask = maskLayer;
    
    [self animatePathExit:NO];
}

- (IBAction)dismiss:(id)sender {
    NewStoryViewController* parent = (NewStoryViewController*)self.parentViewController;
    
    [self animatePathExit:YES];
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backButton.alpha = 0;
        self.settingsButton.alpha = 0;
        self.backButton.transform = CGAffineTransformMakeTranslation(0, -80);
        self.settingsButton.transform = CGAffineTransformMakeTranslation(0, -80);
        
        self.friendsTabButton.alpha = 0;
        self.requestsTabButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.4f animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            [parent transitionFromProfile];
            
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }];
}

#pragma mark - Navigation

- (IBAction)toFriendList:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendList"];
    [self.pager setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.requestsTabButton.alpha = .5f;
    self.friendsTabButton.alpha = 1;
}

- (IBAction)toRequestList:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestList"];
    [self.pager setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.friendsTabButton.alpha = .5f;
    self.requestsTabButton.alpha = 1;
}

#pragma mark - UIpageViewController

- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0 || i>=2) {
        return nil;
    }
    
    NSString * indentifier = i == 0 ? @"RequestList" : @"FriendList";//ShowGroupsViewController
    
    UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: indentifier];
    
    return newController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self viewControllerAtIndex:0];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return [self viewControllerAtIndex:1];
}

#pragma mark - Animation

- (void)animatePathExit:(BOOL)exit {
    
    [CATransaction begin];
    
    if (!exit) {
        [CATransaction setCompletionBlock:^{
            [self _animateOpenBump];
        }];
    }
        
    CABasicAnimation* open = [CABasicAnimation animationWithKeyPath:@"path"];
    open.duration = .4f;
    open.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef to = exit ? [SHPathLibrary pathForProfileView:self.bodyView open:NO bumpDelta:0].CGPath : [SHPathLibrary pathForProfileView:self.bodyView open:YES bumpDelta:20].CGPath;
    
    open.fromValue = (__bridge id)maskLayer.path;
    open.toValue = (__bridge id)to;
    
    [maskLayer addAnimation:open forKey:@"open"];
    [maskLayer.modelLayer setPath:to];
    
    [CATransaction commit];
}

- (void)_animateOpenBump {
    CABasicAnimation* open = [CABasicAnimation animationWithKeyPath:@"path"];
    open.duration = .3f;
    open.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CGPathRef to = [SHPathLibrary pathForProfileView:self.bodyView open:YES bumpDelta:0].CGPath;
    
    open.fromValue = (__bridge id)maskLayer.path;
    open.toValue = (__bridge id)to;
    
    [maskLayer addAnimation:open forKey:@"open"];
    [maskLayer.modelLayer setPath:to];

}

@end
