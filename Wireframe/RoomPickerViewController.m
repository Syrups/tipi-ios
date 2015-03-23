//
//  RoomPickerViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomPickerViewController.h"
#import "UserSession.h"
#import "StoryManager.h"
#import "StoryWIPSaver.h"

@interface RoomPickerViewController ()

@end

@implementation RoomPickerViewController {
    NSMutableArray* selectedRooms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedRooms = [NSMutableArray array];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)send:(id)sender {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    User* user = [[UserSession sharedSession] user];
    NSArray* medias = [[StoryWIPSaver sharedSaver] medias];
    
    [manager createStoryWithName:@"Amazing story" owner:user inRooms:selectedRooms tag:@"los angeles" medias:medias audiosFiles:medias];
}

#pragma mark - RoomFetcherDelegate

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    self.rooms = rooms;
    
    [self.roomsCollectionView reloadData];
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError *)error {
    // error
}

#pragma mark - StoryCreatorDelegate

- (void)storyManager:(StoryManager *)manager successfullyCreatedStory:(Story *)story withPages:(NSArray *)pages {
    NSLog(@"Story created");
    NSLog(@"%@", pages);
}

- (void)storyManager:(StoryManager *)manager failedToCreateStory:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rooms.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;
    
    Room* room = nil;
    
    if (self.rooms.count > 0 && indexPath.row <= self.rooms.count-1) {
        room = [self.rooms objectAtIndex:indexPath.row];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateRoomCell" forIndexPath:indexPath];
    }
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    for (UIView* v in cell.contentView.subviews) {
        v.layer.borderWidth = 1;
        v.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    if (indexPath.row < self.rooms.count) {
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.text = room.name;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    Room* room = [self.rooms objectAtIndex:indexPath.row];
    
    if (![selectedRooms containsObject:room]) {
        [selectedRooms addObject:room];
        
        for (UIView* v in cell.contentView.subviews) {
            v.backgroundColor = [UIColor blackColor];
            v.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor whiteColor];
        
    } else {
        [selectedRooms removeObject:room];
        for (UIView* v in cell.contentView.subviews) {
            v.backgroundColor = [UIColor whiteColor];
            v.layer.borderColor = [UIColor blackColor].CGColor;
        }
        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor blackColor];
    }
}

@end
