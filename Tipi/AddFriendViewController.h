//
//  AddFriendViewController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendManager.h"
#import "UserManager.h"

@interface AddFriendViewController : UIViewController <FriendAdderDelegate, UserFinderDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* friends;
@property (strong, nonatomic) IBOutlet UITextField* searchField;
@property (strong, nonatomic) IBOutlet UITableView* resultsTableView;
@property (strong, nonatomic) FriendManager* friendManager;

@end
