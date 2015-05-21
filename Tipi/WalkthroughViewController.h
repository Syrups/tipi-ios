//
//  WalkthroughViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkthroughViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController* pageViewController;

@end
