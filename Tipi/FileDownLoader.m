//
//  FileDownLoader.m
//  Tipi
//
//  Created by Glenn Sonna on 22/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FileDownLoader.h"
#import <AFURLSessionManager.h>

@implementation FileDownLoader

+ (void) downloadFileWithURL: (NSString *) fileURL  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error)) completionHandler{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    
    [downloadTask resume];
}

@end
