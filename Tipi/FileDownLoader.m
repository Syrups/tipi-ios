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
    
    NSString* cachedPath = [self cachedFilePathForUrl:fileURL];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachedPath]) {
        
        NSLog(@"Cache hit for path %@", cachedPath);
        
        completionHandler(nil, [NSURL URLWithString:cachedPath], nil);
    } else {
        [self performDownloadFileWithURL:fileURL completionHandler:completionHandler];
    }
}

+ (void) performDownloadFileWithURL: (NSString *) fileURL  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error)) completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:fileURL];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:URL] mutableCopy];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request.copy progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        // TODO caching
        [self cacheFileAtPath:[filePath absoluteString] forUrl:fileURL];
        
        completionHandler(response, filePath, error);
    }];
    
    [downloadTask resume];
}

+ (void)cacheFileAtPath:(NSString*)filePath forUrl:(NSString*)fileUrl {
    
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:[self cacheFilePath] encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableDictionary* cache;
    if (jsonString != nil) {
        cache = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    } else {
        cache = [NSMutableDictionary dictionary];
    }
    
    [cache setObject:filePath forKey:fileUrl];
    
    [cache writeToFile:[self cacheFilePath] atomically:YES];
    
    NSLog(@"Cached file at path %@ for url %@", filePath, fileUrl);
}

+ (NSString*)cachedFilePathForUrl:(NSString*)fileUrl {
    NSString* path;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self cacheFilePath]]) {
        NSDictionary* cache = [NSDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
        path = [cache objectForKey:fileUrl];
    }
    
    return path;
}

+ (NSString*)cacheFilePath {
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingString:@"/file_cache"];
}

@end
