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
@property (nonatomic, strong) NSMutableArray *statesQueue;
@property (nonatomic, strong) NSMutableArray *namesQueue;
//@property (nonatomic, strong) NSMutableDictionary *commQueue;
//@property (nonatomic, strong) NSMutableArray *commentsTimers;
@property (nonatomic, assign) id delegate;


- (instancetype) initWithDelegate:(id)delegate;
- (instancetype) initWithDelegate:(id)delegate andCapacity:(NSUInteger)capacity;

- (void) pushInQueueComment: (Comment *) comment atIndex:(NSUInteger) index;
- (void) removeComment:(Comment *) comment atIndex:(NSUInteger) index;

@end

@protocol CommentsQueueDelegate <NSObject>

@required
- (void)commentsQueueManager:(CommentsQueueManager *)manager didPushedComment:(Comment*)comment withReference:(NSNumber*)ref;
@required
- (void)commentsQueueManager:(CommentsQueueManager *)manager didRemovedComment:(Comment*)comment withReference:(NSNumber*)ref;
@end



