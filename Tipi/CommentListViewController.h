//
//  CommentListViewController.h
//  Tipi
//
//  Created by Leo on 08/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Comment.h"

@interface CommentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic)   id delegate;
@property (strong, nonatomic) NSArray* comments;
@property (strong, nonatomic) IBOutlet UITableView* commentsTableView;
@property (strong, nonatomic) AVAudioPlayer* player;

- (void)appear;

@end

@protocol CommentListViewControllerDelegate <NSObject>

- (void)commentListViewController:(CommentListViewController*)viewController didSelectComment:(Comment*)comment;

@end
