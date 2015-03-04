//
//  GroupMembersViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMembersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic)  NSArray *mUsers;
@end
