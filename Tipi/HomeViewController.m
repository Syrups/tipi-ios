//
//  HomeViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseHomeViewController.h"
#import "NewStoryViewController.h"
#import "ShowGroupsViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.storyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewStoryViewController"];
    self.groupsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowGroupsNavViewController"];
    
    [self displayChildViewController:self.storyViewController];
    
    // check for notifications
    UserManager* manager = [[UserManager alloc] initWithDelegate:self];
    [manager fetchRoomInvitationsOfUser:CurrentUser];
}

#pragma mark - InvitationFetcher

- (void)userManager:(UserManager *)manager successfullyFetchedInvitations:(NSArray *)invitations {
    if ([invitations count] > 0) {
        self.storyViewController.notificationsAlert.hidden = NO;
    }
}

- (void)userManager:(UserManager *)manager failedToFetchInvitationsWithError:(NSError *)error {
    // TODO
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goRooms:(id)sender
{
    [self switchChildViewController];
}

#pragma mark - Navigation

- (void)switchChildViewController {
    UIViewController* vc = self.currentViewController == self.storyViewController ? self.groupsViewController : self.storyViewController;
    
    [self displayChildViewController:vc];
}

- (void)displayChildViewController:(UIViewController *)viewController {
    
    // remove old child vc if any
    if (self.currentViewController != nil) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }
    
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.frame;
    [self.view addSubview:viewController.view];
    [self.view sendSubviewToBack:viewController.view];
    [viewController didMoveToParentViewController:self];

    self.currentViewController = viewController;
    
    if (self.currentViewController == self.storyViewController) {
        [self.storyViewController transitionFromFires];
    } else {
        [(ShowGroupsViewController*)self.groupsViewController.childViewControllers[0] animate];
    }
}

@end
