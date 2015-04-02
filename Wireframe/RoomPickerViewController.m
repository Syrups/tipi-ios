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
#import "Configuration.h"

@implementation RoomPickerViewController {
    NSMutableArray* selectedRooms;
    NSUInteger uploadedAudiosCount;
    NSUInteger uploadedMediasCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedRooms = [NSMutableArray array];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
    
    self.saver = [StoryWIPSaver sharedSaver];
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)send:(id)sender {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    User* user = [[UserSession sharedSession] user];
    NSArray* medias = [[StoryWIPSaver sharedSaver] medias];
    NSString* tag = [[StoryWIPSaver sharedSaver] tag];
    NSString* title = [[StoryWIPSaver sharedSaver] title];
    
    [manager createStoryWithName:title owner:user inRooms:selectedRooms tag:tag medias:medias audiosFiles:medias];
}

#pragma mark - FileUploaderDelegate

- (void)fileUploader:(FileUploader *)uploader successfullyUploadedFileOfType:(NSString *)type toPath:(NSString *)path withFileName:(NSString *)filename {
    
    if ([type isEqualToString:kUploadTypeAudio]) {
        uploadedAudiosCount++;
    } else {
        uploadedMediasCount++;
    }
    
    
    // all good
    if (uploadedMediasCount == self.saver.medias.count && uploadedAudiosCount == self.saver.medias.count) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - RoomFetcherDelegate

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    self.rooms = rooms;
    
    [self.roomsCollectionView reloadData];
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError *)error {
    // error
    ErrorAlert(@"Impossible de charger les feux de camp.");
}

#pragma mark - StoryCreatorDelegate

- (void)storyManager:(StoryManager *)manager successfullyCreatedStory:(Story *)story withPages:(NSArray *)pages {
    NSLog(@"Story created");
    
    FileUploader* uploader = [[FileUploader alloc] init];
    uploader.delegate = self;
    
    [story.pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
        UIImage* image = [(NSDictionary*)[self.saver.medias objectAtIndex:idx] objectForKey:@"full"];
        NSString* mediaPath = [NSString stringWithFormat:@"/pages/%@/media", page.id];
        NSString* audioPath = [NSString stringWithFormat:@"/pages/%@/audio", page.id];
        
        [uploader uploadFileWithData:UIImageJPEGRepresentation(image, 1.0) toPath:mediaPath ofType:kUploadTypeMedia];
        
        [uploader uploadFileWithData:[self.recorder dataOfAudioWithIndex:idx] toPath:audioPath ofType:kUploadTypeAudio];
    }];
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
    
    if (indexPath.row == self.rooms.count) {
        return;
    }
    
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
