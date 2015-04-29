//
//  ProfileViewController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface ProfileViewController : UIViewController <UserFetcherDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController* pager;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UILabel* usernameLabel;

@end
