//
//  ShowOneGroupViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface ShowOneGroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSUInteger roomId;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *revealTag;
@property (weak, nonatomic) IBOutlet UIButton *revealUsers;
@property (strong, nonatomic)  NSArray *mStories;
@end
