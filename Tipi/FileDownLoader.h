//
//  FileDownLoader.h
//  Tipi
//
//  Created by Glenn Sonna on 22/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownLoader : NSObject
+ (void) downloadFileWithURL: (NSString *) fileURL  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error)) completionHandler;
@end
