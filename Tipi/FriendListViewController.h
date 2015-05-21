//
//  FriendListViewController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendManager.h"

@interface FriendListViewController : UIViewController <FriendFetcherDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;
@property (strong, nonatomic) NSMutableArray* friends;

@end
