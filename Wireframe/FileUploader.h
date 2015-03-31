//
//  FileUploader.h
//  Wireframe
//
//  Created by Leo on 31/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUploadTypeAudio @"audio"
#define kUploadTypeMedia @"media"

@interface FileUploader : NSObject

@property (strong, nonatomic) id delegate;

- (void)uploadFileWithData:(NSData*)data toPath:(NSString*)path ofType:(NSString*)type;

@end

@protocol FileUploaderDelegate <NSObject>

- (void)fileUploader:(FileUploader*)uploader successfullyUploadedFileOfType:(NSString*)type toPath:(NSString*)path withFileName:(NSString*)filename;
- (void)fileUploader:(FileUploader*)uploader failedToUploadFileOfType:(NSString*)type toPath:(NSString*)path;

@end
