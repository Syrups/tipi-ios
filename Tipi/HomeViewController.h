//
//  HomeViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewStoryViewController.h"
#import "ShowGroupsViewController.h"

@interface HomeViewController : UIViewController //<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
- (IBAction)goRooms:(id)sender;

@property (strong, nonatomic) UIViewController* currentViewController;
@property (strong, nonatomic) NewStoryViewController* storyViewController;
@property (strong, nonatomic) ShowGroupsViewController* groupsViewController;

- (void)displayChildViewController:(UIViewController*)viewController;
- (void)switchChildViewController;

@end
