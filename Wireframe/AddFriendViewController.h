//
//  AddFriendViewController.h
//  Wireframe
//
//  Created by Leo on 03/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendManager.h"

@interface AddFriendViewController : UIViewController <FriendAdderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* resultsTableView;

@end
