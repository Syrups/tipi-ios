//
//  AddUsersToRoomViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomManager.h"
#import "FriendManager.h"

@interface AddUsersToRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RoomCreatorDelegate, FriendFetcherDelegate>

@property (strong, nonatomic) NSString* roomName;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) NSArray* friends;
@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;

@end
