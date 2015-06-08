//
//  CommentListViewController.h
//  Tipi
//
//  Created by Leo on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* comments;
@property (strong, nonatomic) IBOutlet UITableView* commentsTableView;

@end
