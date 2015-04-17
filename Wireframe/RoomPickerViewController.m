//
//  RoomPickerViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "RoomPickerViewController.h"
#import "RoomListFlowLayout.h"
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
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        NSLog(@"%@", self.navigationController.parentViewController);
        [self.navigationController.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)fileUploader:(FileUploader *)uploader failedToUploadFileOfType:(NSString *)type toPath:(NSString *)path {
    // TODO
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
    return self.rooms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;
    
    Room* room = nil;
    
    room = [self.rooms objectAtIndex:indexPath.row];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomCell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    if (indexPath.row == 0) {
        cell.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = room.name;
    
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

        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor whiteColor];
        
    } else {
        [selectedRooms removeObject:room];

        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.textColor = [UIColor blackColor];
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGPoint point = CGPointMake(self.roomsCollectionView.frame.size.width/2, self.roomsCollectionView.contentOffset.y + 100);
        NSIndexPath* indexPath = [self.roomsCollectionView indexPathForItemAtPoint:point];
        UICollectionViewCell* cell = [self.roomsCollectionView cellForItemAtIndexPath:indexPath];
        
        cell.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        
        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
        name.alpha = 1;
        
        [[self.roomsCollectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath* _indexPath, NSUInteger idx, BOOL *stop) {
            if (indexPath.row != _indexPath.row) {
                UICollectionViewCell* cell = [self.roomsCollectionView cellForItemAtIndexPath:_indexPath];
                cell.transform = CGAffineTransformMakeScale(1, 1);
                
                UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
                name.alpha = 0.6f;
            }
        }];

    } completion:nil];
}

@end
