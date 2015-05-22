//
//  TPSideCommentsView.h
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsQueueManager.h"

@interface TPSideCommentsView : UIView <CommentsQueueDelegate, UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *commentsList;
@property (nonatomic, assign) id delegate;
@end

@protocol TPSideCommentsDelegate <NSObject>

@required
- (void)sideCommentsView:(TPSideCommentsView *)manager didSelectedComment:(Comment*)comment withFile:(NSString*)fileUrl;

@required
- (void)sideCommentsView:(TPSideCommentsView *)manager didDeselectedComment:(Comment*)comment withFile:(NSString*)fileUrl;

@end


