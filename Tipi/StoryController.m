//
//  StoryController.m
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryController.h"
#import <AFNetworking/AFNetworking.h>

@implementation StoryController

-(void)createStoryWithName:(NSString *)name owner:(User *)owner inRooms:(NSArray *)rooms tag:(NSString *)tag medias:(NSArray *)medias audiosFiles:(NSArray *)audioFiles success:(void (^)(Story *, NSArray*))success failure:(void (^)(NSError *))failure {
    
    NSString* path = [NSString stringWithFormat:@"/users/%@/stories", owner.id];
    NSMutableURLRequest* request = [StoryController getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"story\": { \"title\": \"%@\", \"page_count\": \"%ld\", \"tag\": \"%@\", \"rooms\": %@ } }", name, (unsigned long)medias.count, tag, [self jsonArrayForRooms:rooms]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(story, story.pages);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [op start];
}


- (void)fetchStoriesForRoomId:(NSUInteger )room filteredByTag:(NSString *)tag orUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString* path = [NSString stringWithFormat:@"/rooms/%ld/stories", (long)room];
    
    if (tag != nil) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?tag=%@", tag]];
    } else if (user != nil) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?user=%@", user.id]];
    }
    
    NSURLRequest* request = [StoryController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* stories = [Story arrayOfModelsFromDictionaries:responseObject];
        
           NSLog(@"%@",responseObject);
        
        if (err) { NSLog(@"%@", err); }
        
        success(stories);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)fetchStoryWithId:(NSUInteger)roomId success:(void (^)(Story *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/stories/%ld", (unsigned long)roomId];
    NSURLRequest* request = [StoryController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"blubli %@", responseObject);
        
        NSError* err = nil;
        Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(story);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

- (void)addCommentOnPage:(Page *)page atTime:(NSUInteger)timecode withAudioFile:(NSString *)audioFile success:(void (^)(Comment *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/pages/%@/comments", page.id];
    NSMutableURLRequest* request = [StoryController getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    NSString *jsonParams = [NSString stringWithFormat:@"{ \"comment\": { \"file\": \"%@\", \"timecode\": \"%lu\" } }", audioFile,(unsigned long)timecode];
    [request setHTTPBody: [jsonParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Comment* comment = [[Comment alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(comment);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [op start];
}

- (void)deleteStory:(Story*)story inRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure{
    NSString* path = [NSString stringWithFormat:@"/rooms/%@/stories/%@",story.id, room.id];
    NSURLRequest* request = [BaseModelController getBaseRequestFor:path authenticated:YES method:@"DELETE"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Room* room = [[Room alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        success(room);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure(error);
    }];
    
    [op start];
}

#pragma mark - Helpers

- (NSString*)jsonArrayForRooms:(NSArray*)rooms {
    NSMutableString* json = [NSMutableString  stringWithString:@"[ "];
    
    NSUInteger i = 0;
    
    for (Room* room in rooms) {
        [json appendString:[NSString stringWithFormat:@"\"%@\"", room.id]];
        
        if (i < rooms.count-1) {
            [json appendString:@", "];
        }
        
        i++;
    }
    
    return [json stringByAppendingString:@" ]"];
}

@end