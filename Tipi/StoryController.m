//
//  StoryController.m
//  Wireframe
//
//  Created by Leo on 02/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryController.h"
#import "RoomCache.h"
#import "StoryCache.h"
#import <AFNetworking/AFNetworking.h>

@implementation StoryController {
    Page* commentPage;
}

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
        
        if (err) { NSLog(@"%@", err); }
        
        // cache last stories
        NSUInteger l = [stories count] > 3 ? 3 : [stories count];
        [RoomCache cacheLastStories:[stories subarrayWithRange:NSMakeRange(0, l)] forRoomId:[NSString stringWithFormat:@"%d", room]];
        
        success(stories);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error loading stories. Trying cache last stories...");
        
        // try cache
        
        [RoomCache fetchCachedLastStoriesForRoomId:[NSString stringWithFormat:@"%d", room] withSuccess:^(NSArray *stories) {
            success(stories);
        } failure:^{
            failure(error);
        }];
        
    }];
    
    [op start];
}

- (void)fetchStoryWithId:(NSUInteger)roomId success:(void (^)(Story *))success failure:(void (^)(NSError *))failure {
    NSString* path = [NSString stringWithFormat:@"/stories/%ld", (unsigned long)roomId];
    NSURLRequest* request = [StoryController getBaseRequestFor:path authenticated:YES method:@"GET"];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSError* err = nil;
        Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        // cache
        [StoryCache cacheStory:story];
        
        
        success(story);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error loading story. Trying cache copy...");
        
        // try cache
        [StoryCache fetchCachedStoryForId:[NSString stringWithFormat:@"%d", roomId] withSuccess:success failure:^{
            NSLog(@"%@", error);
            failure(error);
        }];
        
        
    }];
    
    [op start];
}

- (void)addCommentOnPage:(Page *)page atTime:(NSUInteger)timecode withAudioFile:(NSString *)audioFile success:(void (^)(Comment *))success failure:(void (^)())failure {
    
    commentPage = page;
    
    FileUploader* uploader = [[FileUploader alloc] init];
    uploader.delegate = self;
    
    NSString* path = [NSString stringWithFormat:@"/pages/%@/comments?timecode=%lu&duration=0", page.id, (unsigned long)timecode];
    
    //[kApiRootUrl stringByAppendingString:[];
    
    
    [uploader uploadFileWithData:[NSData dataWithContentsOfFile:audioFile] toPath:path ofType:kUploadTypeAudio];
    
    self.commentUploadSuccessBlock = success;
    self.commentUploadFailureBlock = failure;
}

- (void)deleteStory:(Story*)story inRoom:(Room*)room success:(void(^)(Room* room))success failure:(void(^)(NSError* error))failure{
    NSString* path = [NSString stringWithFormat:@"/rooms/%@/stories/%@",room.id, story.id];
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

#pragma mark - FileUploader

- (void)fileUploader:(FileUploader *)uploader successfullyUploadedFileOfType:(NSString *)type toPath:(NSString *)path withFileName:(NSString *)filename {
    
    Comment* comment = [[Comment alloc] init];
    comment.file = filename;
    self.commentUploadSuccessBlock(comment);
}

- (void)fileUploader:(FileUploader *)uploader failedToUploadFileOfType:(NSString *)type toPath:(NSString *)path {
    self.commentUploadFailureBlock();
}

@end
