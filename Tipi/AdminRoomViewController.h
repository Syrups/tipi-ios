//
//  AdminRoomViewController.h
//  Wireframe
//
//  Created by Leo on 29/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomManager.h"

@interface AdminRoomViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, RoomUpdaterDelegate>

@property (strong, nonatomic) IBOutlet UILabel* roomName;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) IBOutlet UITableView* usersTableView;
@property (strong, nonatomic) IBOutlet UITextField* roomNameField;

@end
