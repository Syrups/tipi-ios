//
//  RequestListViewController.h
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "RoomManager.h"
#import "TPAlert.h"

@interface NotificationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InvitationFetcherDelegate, RoomJoinerDelegate, TPAlertDelegate>

@property (strong, nonatomic) NSMutableArray* invitations;
@property (strong, nonatomic) IBOutlet UITableView* requestsTableView;
@property (strong, nonatomic) IBOutlet UILabel* errorLabel;

@end
