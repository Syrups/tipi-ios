//
//  ShowGroupsViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowOneGroupViewController.h"
#import "RoomManager.h"
#import "UIRoomTableViewCell.h"


@interface ShowGroupsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, RoomFetcherDelegate>

@property (strong, nonatomic) ShowOneGroupViewController *mShowOneGroupViewController;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic)  NSArray *mGroups;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* topControlsYConstraint;

- (void)animate;

@end
