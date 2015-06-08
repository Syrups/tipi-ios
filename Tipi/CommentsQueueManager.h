//
//  CommentsQueueManager.h
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"



@interface CommentsQueueManager : NSObject

@property (nonatomic, strong) NSMutableArray *commentsQueue;
@property (nonatomic, strong) NSMutableArray *referencesQueue;
@property (nonatomic, assign) id delegate;


- (instancetype) initWithDelegate:(id)delegate;
- (instancetype) initWithDelegate:(id)delegate andCapacity:(NSUInteger)capacity;

- (void) pushInQueueComment: (Comment *) comment atIndex:(NSUInteger) index;
- (void)removeCommentRef:(NSDictionary *) ref atIndex:(NSUInteger) index;

@end

@protocol CommentsQueueDelegate <NSObject>

@required
- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(NSDictionary*)comment withReference:(NSNumber*)ref;
@required
- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(NSDictionary*)comment atIndex:(NSUInteger)index;

@optional
- (void)commentsQueueManager:(CommentsQueueManager *)manager isReadyComment:(NSDictionary *)comment withReference:(NSNumber*)ref atIndexPath:(NSIndexPath *) indexpath;
@end



