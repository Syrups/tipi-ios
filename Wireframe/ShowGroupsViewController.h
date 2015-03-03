//
//  ShowGroupsViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHomeViewController.h"
#import "ShowOneGroupViewController.h"

@interface ShowGroupsViewController : BaseHomeViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ShowOneGroupViewController *mShowOneGroupViewController;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic)  NSArray *mGroups;

@end
