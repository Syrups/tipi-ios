//
//  CommentsQueueManager.m
//  Wireframe
//
//  Created by Glenn Sonna on 19/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CommentsQueueManager.h"

@implementation CommentsQueueManager


- (id)initWithDelegate:(id)delegate{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.commentsQueue = [NSMutableArray new];
    }
    
    return self;
}

- (id)initWithDelegate:(id)delegate andCapacity:(NSUInteger)capacity {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.commentsQueue = [NSMutableArray new];
        self.indexesQueue = [NSMutableArray new];
        
    }
    return self;
}

- (void)pushInQueueComment : (Comment *) comment atIndex:(NSUInteger) index{
    
    if(![self.indexesQueue containsObject: @(index)]){
        [self.commentsQueue insertObject:comment atIndex:0];
        [self.indexesQueue insertObject:@(index) atIndex:0];
        
        [self.delegate commentsQueueManager:self didPushedComment:comment atIndex:index];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeComment:comment atIndex:index];
        });
    }
}

- (void)removeComment:(Comment *) comment atIndex:(NSUInteger) index{
    [self.commentsQueue removeObject:comment];
    [self.delegate commentsQueueManager:self didRemovedComment:comment atIndex:index];
}

@end
