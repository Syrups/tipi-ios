//
//  ReadModeContainerViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadModeContainerViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic, strong)UIPageViewController *pager;
@property (strong, nonatomic)  NSArray *mPages;
@end
