//
//  MediaLibrary.h
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaLibrary : NSObject

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSMutableArray* cachedMedias;
@property (strong, nonatomic) NSMutableArray* medias;

- (void)fetchMediasFromLibraryFrom:(NSUInteger)start to:(NSUInteger)limit;

@end

@protocol MediaLibraryDelegate <NSObject>

- (void)mediaLibrary:(MediaLibrary*)library successfullyFetchedMedias:(NSArray*)medias from:(NSUInteger)start to:(NSUInteger)limit;
- (void)mediaLibrary:(MediaLibrary *)library failedToFetchMediasWithError:(NSError*)error;
- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedia:(NSDictionary *)media;

@end
