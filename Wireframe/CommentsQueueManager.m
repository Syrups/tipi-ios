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
        self.referencesQueue = [NSMutableArray new];
        self.statesQueue = [NSMutableArray new];
        
    }
    return self;
}

- (void)pushInQueueComment : (Comment *) comment atIndex:(NSUInteger) index{
    
    /*NSDictionary *commentRef = [self.commQueue objectForKey:@(index)];
    if (!queueItem) {
        self.commQueue[@(index)] = @{@"comments": comment, @"state" : @YES};
        [self.delegate commentsQueueManager:self didPushedCommentReference:commentRef];
     
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeComment:comment atIndex:index];
        });
    }*/
    
    if(![self.referencesQueue containsObject: @(index)]){
         [self.referencesQueue insertObject:@(index) atIndex:0];
        [self.commentsQueue insertObject:comment atIndex:0];
        [self.statesQueue insertObject:@YES atIndex:0];
        [self.namesQueue insertObject:[self findCapForuser: comment.user] atIndex:0];
        
        [self.delegate commentsQueueManager:self didPushedComment:comment withReference:@(index)];
        
        //TODO should be duration plus .8f
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeComment:comment atIndex:index];
        });
    }
}

- (void)removeComment:(Comment *) comment atIndex:(NSUInteger) index{
    //[self.commQueue removeObjectForKey:@(index)];
    
    [self.commentsQueue removeObject:comment];
    [self.delegate commentsQueueManager:self didRemovedComment:comment withReference:@(index)];
}

- (NSString *)findCapForuser:(User*)user{

    return [user.username substringToIndex:2];
}

@end
