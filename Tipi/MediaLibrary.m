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

- (void)fetchMediasFromLibrary {
    
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
                    
                    NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                    UIImage* image = [UIImage imageWithCGImage:[result thumbnail]];
                    
                    
                    NSDictionary* media = @{
                                            @"image": image,
                                            @"asset": result,
                                            @"date": [result valueForProperty:ALAssetPropertyDate],
                                            @"type": [result valueForProperty:ALAssetPropertyType],
                                            @"url": url,
                                            @"audio_only": [NSNumber numberWithBool:NO]
                                            }.mutableCopy;
                    
                    [medias addObject:media];
                    
                    NSLog(@"%d / %d", i, self.totalMediasCount);
                    
                    
                    if ( i == self.totalMediasCount) {
                        
                        if ([self.delegate respondsToSelector:@selector(mediaLibrary:successfullyFetchedMedias:)]) {
                            [self.delegate mediaLibrary:self successfullyFetchedMedias:medias];
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

@end
