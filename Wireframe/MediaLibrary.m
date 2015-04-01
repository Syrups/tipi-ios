//
//  MediaLibrary.m
//  Wireframe
//
//  Created by Leo on 01/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MediaLibrary.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MediaLibrary

- (void)fetchMediasFromLibrary {
    NSMutableArray* medias = [NSMutableArray array];
    NSMutableArray* assetGroups = [NSMutableArray array];
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    NSUInteger types = ALAssetsGroupAll;
    [library enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [assetGroups addObject:group];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSURL *url= (NSURL*) [[result defaultRepresentation]url];
                    
                    [library assetForURL:url
                             resultBlock:^(ALAsset *asset) { //Your line
                                 ALAssetRepresentation* rep = [asset defaultRepresentation];
                                 
                                 UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
                                 UIImage* fullImage = [UIImage imageWithCGImage:[rep fullScreenImage]];
                                 [medias addObject:@{
                                                          @"image": image,
                                                          @"full": fullImage,
                                                          @"date": [result valueForProperty:ALAssetPropertyDate],
                                                          @"type": [result valueForProperty:ALAssetPropertyType],
                                                          @"url": url
                                                          }];
                                 
                                 if (index+1 == group.numberOfAssets) {
                                     if ([self.delegate respondsToSelector:@selector(mediaLibrary:successfullyFetchedMedias:)]) {
                                         [self.delegate mediaLibrary:self successfullyFetchedMedias:medias];
                                     }
                                 }
                             }
                            failureBlock:^(NSError *error){
                                NSLog(@"test:Fail");
                            }];
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
