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
#import "UserManager.h"
#import "SRUnderlinedField.h"

@interface AddUsersToRoomViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RoomCreatorDelegate, FriendFetcherDelegate, UserFinderDelegate, RoomInviterDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString* roomName;
@property (strong, nonatomic) Room* room;
@property (strong, nonatomic) NSArray* friends;
@property (strong, nonatomic) IBOutlet SRUnderlinedField* searchField;
@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
