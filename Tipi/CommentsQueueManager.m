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
        self.commentsQueue = [[NSMutableArray alloc] initWithCapacity:capacity];
        self.referencesQueue = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

- (void)pushInQueueComment : (Comment *) comment atIndex:(NSUInteger) index{

    if(![self.referencesQueue containsObject: @(index)]){
        
        NSMutableDictionary *commentWraper = [@{@"comment": comment, @"cap": [self findCapForuser: comment.user], @"state" : @NO, @"unrolled" : @NO} mutableCopy];
        [self.commentsQueue insertObject:commentWraper atIndex:0];
        [self.referencesQueue insertObject:@(index) atIndex:0];
        
        [self.delegate commentsQueueManager:self didPushedComment:commentWraper withReference:@(index)];
        
        /*NSTimer *timeToStay = [NSTimer timerWithTimeInterval:3
                                                target:self
                                              selector:@selector(hideOverlay:)
                                              userInfo:nil
                                               repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timeToStay forMode:NSRunLoopCommonModes];
        [commentWraper setValue:timeToStay forKey:@"timer"];*/
        
        //[self.overlayTimer invalidate];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [commentWraper setValue:@YES forKey:@"state"];
            [self.delegate commentsQueueManager:self isReadyComment:commentWraper withReference:@(index) atIndexPath:[self indexPathForCommentRef:commentWraper]];
        });
        
        //TODO should be duration plus .8f
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeCommentRef:commentWraper atIndex:index];
        });
    }
}

- (void)hideOverlay:(NSTimer *)timer{
    /*[UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = 0;
    } completion:nil];*/
}

- (void)removeCommentRef:(NSDictionary *) ref atIndex:(NSUInteger) index{
    //[self.commQueue removeObjectForKey:@(index)];
    
    NSUInteger idx = [self.referencesQueue indexOfObject:@(index)];
    
    [self.commentsQueue removeObject:ref];
    [self.referencesQueue removeObject:@(index)];
    
    [self.delegate commentsQueueManager:self didRemovedComment:ref atIndex:idx];
}


- (NSString *)findCapForuser:(User*)user{
    
    NSString *cap = [user.username substringToIndex:2];
    
    for (NSDictionary *comRef in self.commentsQueue) {
        Comment *com = [comRef objectForKey:@"comment"];
        if(user.id != com.user.id){
            cap = [CommentsQueueManager checkCapBeetweenUser:user andComUser:com.user andUserwithIndex:2];
        }
    }

    return cap;
}

- (NSIndexPath*)indexPathForCommentRef:(NSMutableDictionary*) ref{
    return [NSIndexPath indexPathForRow:[self.referencesQueue indexOfObject:ref] inSection:0];
}

- (NSArray*)indexPathArrayForCommentRef:(NSMutableDictionary*) ref{
    NSUInteger index = [self.referencesQueue indexOfObject:ref];
    return @[[NSIndexPath indexPathForRow:index inSection:0]];
}


+ (NSString *)checkCapBeetweenUser:(User*)user andComUser:(User*)comUser andUserwithIndex:(NSUInteger)index{
    
    NSString *userCap = [user.username substringToIndex:index];
    NSString *cap1 = [comUser.username substringToIndex:index];

    if([userCap isEqual:cap1] && index < user.username.length && index < comUser.username.length){
        userCap = [self checkCapBeetweenUser:user andComUser:comUser andUserwithIndex:index+1];
    }
    
    return userCap;
}

@end
