//
//  FilterViewController.h
//  Wireframe
//
//  Created by Leo on 09/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "ShowOneGroupViewController.h"

@interface FilterViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController* pager;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) IBOutlet UIButton* filterUserButton;
@property (strong, nonatomic) IBOutlet UIButton* filterTagButton;

@end
