//
//  SandboxViewController.m
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SandboxViewController.h"
#import "PKAIDecoder.h"
#import "TPSwipableViewController.h"

@implementation SandboxViewController {
    CGFloat lastValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *childViewControllers = [self _configuredChildViewControllers];
	TPSwipableViewController *tps = [[TPSwipableViewController alloc] initWithViewControllers:childViewControllers];
    
    [self addChildViewController:tps];                 // 1
    tps.view.frame = self.view.frame; // 2
    [self.containerView addSubview:tps.view];
    [tps didMoveToParentViewController:self];          // 3
    //MediaLibrary* library = [[MediaLibrary alloc] init];
    //library.delegate = self;
    //[library fetchMediasFromLibrary];
}


- (NSArray *)_configuredChildViewControllers {
    
    // Set colors, titles and tab bar button icons which are used by the ContainerViewController class for display in its button pane.
    
    NSMutableArray *childViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *configurations = @[
                                @{@"title": @"First", @"color": [UIColor colorWithRed:0.4f green:0.8f blue:1 alpha:1]},
                                @{@"title": @"Second", @"color": [UIColor colorWithRed:1 green:0.4f blue:0.8f alpha:1]},
                                @{@"title": @"Third", @"color": [UIColor colorWithRed:1 green:0.8f blue:0.4f alpha:1]},
                                ];
    
    for (NSDictionary *configuration in configurations) {
        UIViewController *childViewController = [[UIViewController alloc] init];
        
        childViewController.view.backgroundColor = configuration[@"color"];
        childViewController.view.frame = self.view.frame;
       
        [childViewControllers addObject:childViewController];
    }
    
    return childViewControllers;
}









- (void)mediaLibrary:(MediaLibrary *)library successfullyFetchedMedias:(NSArray *)medias {
    self.photos = medias;
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    image.image = [(NSDictionary*)[self.photos objectAtIndex:indexPath.row] objectForKey:@"image"];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
}

@end
