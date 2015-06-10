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
    
    NSString* cachedFile = [self cachedFilePathForUrl:fileURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* cachedPath = [documentsDirectory stringByAppendingPathComponent:cachedFile];
    
    if (cachedFile != nil && [[NSFileManager defaultManager] fileExistsAtPath:cachedPath]) {
        
//        NSLog(@"Cache hit for path %@", cachedPath);
        
        completionHandler(nil, [NSURL fileURLWithPath:cachedPath], nil);
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
        [self cacheFileAtPath:filePath forUrl:fileURL];
        
        completionHandler(response, filePath, error);
    }];
    
    [downloadTask resume];
}

+ (void)cacheFileAtPath:(NSURL*)filePath forUrl:(NSString*)fileUrl {
    
    // First copy the temp downloaded file to a new file
    NSString* ext = [[fileUrl componentsSeparatedByString:@"."] lastObject];
    NSString* newFile = [self generateNewFilePathWithExtension:ext];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* newFilePath = [documentsDirectory stringByAppendingPathComponent:newFile];
    NSError* err = nil;
    [[NSFileManager defaultManager] copyItemAtURL:filePath toURL:[NSURL fileURLWithPath:newFilePath] error:&err];
    
    if (err) { NSLog(@"%@", err); }
    
    // Then register the new file path into the cache for the given URL
    NSMutableDictionary* cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
    
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
    }
    
    [cache setObject:newFile forKey:fileUrl];
    
    [cache writeToFile:[self cacheFilePath] atomically:YES];
    
//    NSLog(@"Cached file at URL %@ for url %@", [NSURL fileURLWithPath:newFilePath], fileUrl);
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

+ (NSString*)generateNewFilePathWithExtension:(NSString*)extension {
    return [[self generateUuid] stringByAppendingPathExtension:extension];
}

+ (NSString *)generateUuid {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

@end
