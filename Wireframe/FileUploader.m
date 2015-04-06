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
#import "Page.h"

@implementation FileUploader

- (void)uploadFileWithData:(NSData *)data toPath:(NSString*)path ofType:(NSString *)type {
    
//    NSString* name = [type isEqualToString:kUploadTypeAudio] ? @"audio[file]" : @"media[file]";
    NSString* mime = [type isEqualToString:kUploadTypeAudio] ? @"audio/mp4" : @"image/jpeg";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[[UserSession sharedSession].user token] forHTTPHeaderField:@"X-Authorization-Token"];

    [manager POST:[kApiRootUrl stringByAppendingString:path] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError* err = nil;
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:mime];
        
        if (err) { NSLog(@"%@", err); }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* err = nil;
        Page* page = [[Page alloc] initWithDictionary:responseObject error:&err];
        
        if (err) { NSLog(@"%@", err); }
        
        NSString* filename = [type isEqualToString:kUploadTypeAudio] ? page.audio.file : page.media.file;
        
        if ([self.delegate respondsToSelector:@selector(fileUploader:successfullyUploadedFileOfType:toPath:withFileName:)]) {
            [self.delegate fileUploader:self successfullyUploadedFileOfType:type toPath:path withFileName:filename];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if ([self.delegate respondsToSelector:@selector(fileUploader:failedToUploadFileOfType:toPath:)]) {
            [self.delegate fileUploader:self failedToUploadFileOfType:type toPath:path];
        }
    }];
}

@end
