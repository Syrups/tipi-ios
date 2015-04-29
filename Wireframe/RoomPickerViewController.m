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
#import "UIRoomTableViewCell.h"

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
    
    [self.roomsTableView setContentInset:UIEdgeInsetsMake(70,0,150,0)];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createNewRoom:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRoom"];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    [self.roomsTableView reloadData];
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rooms.count;
}

- (UIRoomTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Room* room = [self.rooms objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"groupCell";
    UIRoomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UIRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    cell.roomName.text = room.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (UIRoomTableViewCell *cell in self.roomsTableView.visibleCells) {
        CGPoint cellCenter = [scrollView convertPoint:cell.center toView:scrollView.superview];
        
        int del = fabsf(scrollView.superview.center.y -  cellCenter.y)/ 4.5;
        
        cell.heightConstraint.constant = 120 - del;
        cell.widthConstraint.constant = 120 - del;
        
        [cell setNeedsLayout];
        [cell setNeedsUpdateConstraints];
        
        CGRect cellRect = [scrollView convertRect:cell.frame toView:scrollView.superview];
        CGRect hitRect = CGRectMake(0, self.roomsTableView.superview.center.y- 25, self.roomsTableView.superview.frame.size.width, 50);
        
        if(CGRectIntersectsRect(cellRect, hitRect)){
            [self.roomsTableView selectRowAtIndexPath: [self.roomsTableView indexPathForCell:cell]
                                         animated: NO
                                   scrollPosition: UITableViewScrollPositionNone];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self centerTable];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self centerTable];
}

- (void)centerTable {
    NSIndexPath *pathForCenterCell = [self.roomsTableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.roomsTableView.bounds), CGRectGetMidY(self.roomsTableView.bounds) - 100)];
    [self.roomsTableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CGPoint point = CGPointMake(self.roomsTableView.frame.size.width/2, self.roomsTableView.contentOffset.y + 100);
//        NSIndexPath* indexPath = [self.roomsTableView indexPathForRowAtPoint:point];
//        UITableViewCell* cell = [self.roomsTableView cellForRowAtIndexPath:indexPath];
//        
//        
//        UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
//        name.alpha = 1;
//        
//        [[self.roomsTableView indexPathsForVisibleRows] enumerateObjectsUsingBlock:^(NSIndexPath* _indexPath, NSUInteger idx, BOOL *stop) {
//            if (indexPath.row != _indexPath.row) {
//                UITableViewCell* cell = [self.roomsTableView cellForRowAtIndexPath:_indexPath];
//
//                UILabel* name = (UILabel*)[cell.contentView viewWithTag:10];
//                name.alpha = 0.6f;
//            }
//        }];
//
//    } completion:nil];
//}

@end
