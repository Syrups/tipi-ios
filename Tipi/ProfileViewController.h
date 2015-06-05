//
//  ProfileViewController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface ProfileViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UIView* bodyView;
@property (strong, nonatomic) UIPageViewController* pager;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutlet UIButton* settingsButton;
@property (strong, nonatomic) IBOutlet UILabel* usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton* addButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* addButtonYConstraint;
@property (strong, nonatomic) IBOutlet UIButton* friendsTabButton;
@property (strong, nonatomic) IBOutlet UIButton* requestsTabButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* friendsTabButtonYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* requestsTabButtonYConstraint;

@end
