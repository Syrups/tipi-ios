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
        
        //[self.statesQueue insertObject:@YES atIndex:0];
        //[self.namesQueue insertObject:[self findCapForuser: comment.user] atIndex:0];
        
        NSDictionary *commentWraper = @{@"comment": comment, @"cap": [self findCapForuser: comment.user], @"state" : @YES};
        [self.commentsQueue insertObject:commentWraper atIndex:0];
        [self.referencesQueue insertObject:@(index) atIndex:0];
        
        [self.delegate commentsQueueManager:self didPushedComment:commentWraper withReference:@(index)];
        
        //TODO should be duration plus .8f
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeCommentRef:commentWraper atIndex:index];
        });
    }
}

- (void)removeCommentRef:(NSDictionary *) ref atIndex:(NSUInteger) index{
    //[self.commQueue removeObjectForKey:@(index)];
    
    [self.commentsQueue removeObject:ref];
    [self.delegate commentsQueueManager:self didRemovedComment:ref withReference:@(index)];
}

/*
- (void)removeComment:(Comment *) comment atIndex:(NSUInteger) index{
    //[self.commQueue removeObjectForKey:@(index)];
    
    [self.commentsQueue removeObject:comment];
    [self.delegate commentsQueueManager:self didRemovedComment:comment withReference:@(index)];
}*/

- (NSString *)findCapForuser:(User*)user{
    
    /*NSString*(^checkCapBeetweenUser)(User*comUser, NSUInteger index) = ^(User* comUser, NSUInteger index) {
        
        NSString *userCap = [user.username substringToIndex:index];
        NSString *cap1 = [comUser.username substringToIndex:index];
        
        
        if([userCap isEqual:cap1] && index < user.username.length){
            userCap = checkCapBeetweenUser(comUser, index+1);
        }
        
        return userCap;
    };*/
    
    NSString *cap = [user.username substringToIndex:2];
    
    for (NSDictionary *comRef in self.commentsQueue) {
        Comment *com = [comRef objectForKey:@"comment"];
        if(user.id != com.user.id){
            cap = [self checkCapBeetweenUser:user andComUser:com.user andUserwithIndex:2];
            //cap = checkCapBeetweenUser(com.user, 2);
        }
    }

    return cap;
}


- (NSString *)checkCapBeetweenUser:(User*)user andComUser:(User*)comUser andUserwithIndex:(NSUInteger)index{
    
    NSString *userCap = [user.username substringToIndex:index];
    NSString *cap1 = [comUser.username substringToIndex:index];

    if([userCap isEqual:cap1] && index < user.username.length && index < comUser.username.length){
        userCap = [self checkCapBeetweenUser:user andComUser:comUser andUserwithIndex:index+1];
    }
    
    return userCap;
}

@end
