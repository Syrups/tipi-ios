//
//  StoryManager.m
//  Wireframe
//
//  Created by Leo on 18/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "StoryManager.h"
#import "Api.h"
#import "Room.h"
#import <AFNetworking/AFNetworking.h>

@implementation StoryManager

-(void)createStoryWithName:(NSString *)name owner:(User *)owner inRooms:(NSArray *)rooms tag:(NSString *)tag medias:(NSArray *)medias audiosFiles:(NSArray *)audioFiles {
    
    NSString* path = [NSString stringWithFormat:@"/users/%@/stories", owner.id];
    NSMutableURLRequest* request = [Api getBaseRequestFor:path authenticated:YES method:@"POST"].mutableCopy;
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"story\": { \"title\": \"%@\", \"page_count\": \"%ld\", \"tag\": \"%@\", \"rooms\": %@ } }", name, medias.count, tag, [self jsonArrayForRooms:rooms]] dataUsingEncoding:NSUTF8StringEncoding]];
    
                  

    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        Story* story = [[Story alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        
        [self.delegate storyManager:self successfullyCreatedStory:story withPages:story.pages];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate storyManager:self failedToCreateStory:error];
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
