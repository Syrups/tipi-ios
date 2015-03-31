//
//  FileUploader.m
//  Wireframe
//
//  Created by Leo on 31/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FileUploader.h"
#import <AFNetworking/AFNetworking.h>
#import "Configuration.h"
#import "UserSession.h"

@implementation FileUploader

- (void)uploadFileWithData:(NSData *)data toPath:(NSString*)path ofType:(NSString *)type {
    
//    NSString* name = [type isEqualToString:kUploadTypeAudio] ? @"audio[file]" : @"media[file]";
    NSString* mime = [type isEqualToString:kUploadTypeAudio] ? @"audio/mp4" : @"image/jpeg";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[[UserSession sharedSession] token] forHTTPHeaderField:@"X-Authorization-Token"];

    [manager POST:[kApiRootUrl stringByAppendingString:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError* err = nil;
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:mime];
        
        if (err) { NSLog(@"%@", err); }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
