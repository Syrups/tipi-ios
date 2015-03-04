//
//  RecordViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController <UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UIPageViewController* pageViewController;
@property (strong, nonatomic) NSMutableArray* pages;
@property (strong, nonatomic) IBOutlet UIButton* recordButton;
@property (strong, nonatomic) IBOutlet UIView* eraseWarning;
@property (strong, nonatomic) IBOutlet UIView* replay;

@property BOOL lastPage;

@end
