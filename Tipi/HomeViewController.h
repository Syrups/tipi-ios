//
//  HomeViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewStoryViewController.h"
#import "UserManager.h"

@interface HomeViewController : UIViewController <InvitationFetcherDelegate>

- (IBAction)goRooms:(id)sender;

@property (strong, nonatomic) UIViewController* currentViewController;
@property (strong, nonatomic) NewStoryViewController* storyViewController;
@property (strong, nonatomic) UINavigationController* groupsViewController;

- (void)displayChildViewController:(UIViewController*)viewController;
- (void)switchChildViewController;

@end
