//
//  HomeViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController //<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
- (IBAction)goRooms:(id)sender;

//@property (nonatomic, strong)UIPageViewController *pager;

@property (strong, nonatomic) IBOutlet UIButton* profileButton;

@end
