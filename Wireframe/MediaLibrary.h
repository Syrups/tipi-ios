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

- (void)fetchMediasFromLibrary;

@end

@protocol MediaLibraryDelegate <NSObject>

- (void)mediaLibrary:(MediaLibrary*)library successfullyFetchedMedias:(NSArray*)medias;
- (void)mediaLibrary:(MediaLibrary *)library failedToFetchMediasWithError:(NSError*)error;

@end
