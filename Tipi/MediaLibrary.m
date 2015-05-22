//
//  MediaLibrary.m
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MediaLibrary.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MediaLibrary

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedMedias = [NSMutableArray array];
        self.medias = [NSMutableArray array];
    }
    return self;
}

- (void)fetchMediasFromLibraryFrom:(NSUInteger)start to:(NSUInteger)limit {
    
    NSMutableArray* assetGroups = [NSMutableArray array];
    ALAssetsLibrary* library = [AppDelegate defaultAssetsLibrary];
    NSMutableArray* medias = [NSMutableArray array];
    __block NSUInteger i = 0;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [assetGroups addObject:group];
            
            self.totalMediasCount += group.numberOfAssets;
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                
                if (result != nil) {
                    
                    i++;
                    
//                        NSLog(@"asset - %ld / %ld", (unsigned long)index, (unsigned long)group.numberOfAssets);
                        NSURL *url= (NSURL*) [[result defaultRepresentation]url];

                        
                        UIImage* image = [UIImage imageWithCGImage:[result thumbnail]];
//                        UIImage* fullImage = [UIImage imageWithCGImage:[rep fullScreenImage]];
                        
                        
                            NSDictionary* media = @{
                                                    @"image": image,
                                                    @"asset": result,
//                                                    @"full": fullImage,
                                                    @"date": [result valueForProperty:ALAssetPropertyDate],
                                                    @"type": [result valueForProperty:ALAssetPropertyType],
                                                    @"url": url,
                                                    @"audio_only": [NSNumber numberWithBool:NO]
                                                    }.mutableCopy;
                            
                            [medias addObject:media];
                            
                            if ([self.delegate respondsToSelector:@selector(mediaLibrary:successfullyFetchedMedia:)]) {
                                [self.delegate mediaLibrary:self successfullyFetchedMedia:media];
                            }
                        
                        
                        
                            if ( i == self.totalMediasCount) {
                
                                    
                                    if ([self.delegate respondsToSelector:@selector(mediaLibrary:successfullyFetchedMedias:from:to:)]) {
                                        [self.delegate mediaLibrary:self successfullyFetchedMedias:medias from:start to:limit];
                                    }
                             
                            }
                        
                    
                    
                }
                
            }];
        }
    } failureBlock:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(mediaLibrary:failedToFetchMediasWithError:)]) {
            [self.delegate mediaLibrary:self failedToFetchMediasWithError:error];
        }
    }];

}


//- (void)loadAsynchronouslyFullImages {
//    NSMutableArray* assetGroups = [NSMutableArray array];
//    ALAssetsLibrary* library = [MediaLibrary defaultAssetsLibrary];
//
//    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if(group != nil) {
//            [assetGroups addObject:group];
//            
//            [group enumerateAssetsWithOptions:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                
//                if (result != nil) {
//                    
//                    NSLog(@"asset - full");
//                    
//                    ALAssetRepresentation* rep = [result defaultRepresentation];
//                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                        UIImage* fullImage = [UIImage imageWithCGImage:[rep fullScreenImage]];
//                        
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            NSMutableDictionary* media = [(NSDictionary*)[self.medias objectAtIndex:index] mutableCopy];
//                            [media setObject:fullImage forKey:@"full"];
//                            
//                            [self.medias setObject:media atIndexedSubscript:index];
//                            
//                            if (index+1 == group.numberOfAssets) {
//                                [self setCachedMedias:self.medias];
//                                if ([self.delegate respondsToSelector:@selector(mediaLibrary:successfullyFetchedMedias:from:to:)]) {
//                                    [self.delegate mediaLibrary:self successfullyFetchedMedias:self.medias from:0 to:10];
//                                }
//                            }
//                        });
//                    });
//                }
//                
//            }];
//        }
//    } failureBlock:^(NSError *error) {
//        if ([self.delegate respondsToSelector:@selector(mediaLibrary:failedToFetchMediasWithError:)]) {
//            [self.delegate mediaLibrary:self failedToFetchMediasWithError:error];
//        }
//    }];
//}

@end
