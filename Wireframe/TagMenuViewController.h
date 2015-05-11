//
//  TagMenuViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 04/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowOneGroupViewController.h"
#import "UserManager.h"

@interface TagMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TagFetcherDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic)  NSArray *mTags;
@property (strong, nonatomic) ShowOneGroupViewController* parent;
@end
