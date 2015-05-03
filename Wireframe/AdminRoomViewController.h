//
//  AdminRoomViewController.h
//  Wireframe
//
//  Created by Leo on 29/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface AdminRoomViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) IBOutlet UITableView* usersTableView;

@end
