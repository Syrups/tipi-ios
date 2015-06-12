//
//  TPSideCommentsView.h
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsQueueManager.h"
#import "UIViewTouchUnder.h"
#import <AVFoundation/AVFoundation.h>

@interface TPSideCommentsView : UIViewTouchUnder <CommentsQueueDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) CommentsQueueManager *commentsQueueManager;

@property (strong, nonatomic) AVPlayer* commentsPlayer;
@property (strong, nonatomic) NSMutableArray *commentsPlayers;
@property (strong, nonatomic) NSDictionary* currentCommentRef;
@property (weak, nonatomic) IBOutlet UITableView *commentsList;

@property(strong, nonatomic)NSIndexPath* currentBubbleIndex;

@end

@protocol TPSideCommentsDelegate <NSObject>

@required
- (void)sideCommentsView:(TPSideCommentsView *)manager didSelectComment:(Comment*)comment;

@required
- (void)sideCommentsView:(TPSideCommentsView *)manager didDeselectComment:(Comment*)comment;

@required
- (void)sideCommentsView:(TPSideCommentsView *)manager comment:(Comment*)comment didFinishedPlaying:(BOOL)finished;

@end


