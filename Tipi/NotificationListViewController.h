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

@interface NotificationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InvitationFetcherDelegate, RoomJoinerDelegate>

@property (strong, nonatomic) NSMutableArray* invitations;
@property (strong, nonatomic) IBOutlet UITableView* requestsTableView;


@end
