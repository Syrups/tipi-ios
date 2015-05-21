//
//  GroupMembersViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "ShowOneGroupViewController.h"

@interface GroupMembersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) ShowOneGroupViewController* parent;

@end
