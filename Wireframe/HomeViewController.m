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

// Some number
#define MAX_PAGES 2


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.view addGestureRecognizer:recognizer];
    
    // Create it.
    /*self.pager = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
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
    [self.view sendSubviewToBack:self.pager.view];
    
    // And make sure to activate!
    [self.pager didMoveToParentViewController:self];*/

    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

-(void)goRight{
    [self performSegueWithIdentifier: @"goRooms" sender: self];
}



// Factory method
- (UIViewController *)viewControllerAtIndex:(int)i {
    // Asking for a page that is out of bounds??
    if (i<0) {
        return nil;
    }
    if (i>=MAX_PAGES) {
        return nil;
    }
    
    NSString * indentifier = i == 0 ? @"NewStoryViewController" : @"ShowGroupsNavViewController";//ShowGroupsViewController
    
    // Assuming you have SomePageViewController.xib
    BaseHomeViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier: indentifier];
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

- (IBAction)goRooms:(id)sender
{
    
    // Assuming you have SomePageViewController.xib
    UINavigationController *roomController = [self.storyboard instantiateViewControllerWithIdentifier: @"ShowGroupsNavViewController"];
    
    [self presentViewController:roomController animated:YES completion:nil];
    //[self.navigationController pushViewController:roomController animated:YES];
}

- (IBAction)openProfile:(id)sender {
    UIViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    [profile willMoveToParentViewController:self];
    [self addChildViewController:profile];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.size.height;
    profile.view.frame = frame;
    [self.view addSubview:profile.view];
    [profile didMoveToParentViewController:self];
    
    [UIView animateWithDuration:.3f delay:0 usingSpringWithDamping:.5f initialSpringVelocity:.01f options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.profileButton.hidden = YES;
         CGRect frame = profile.view.frame;
         frame.origin.y = 0;
         profile.view.frame = frame;
    } completion:nil];
}

@end
