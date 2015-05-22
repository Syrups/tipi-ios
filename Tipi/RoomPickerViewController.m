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
#import "TPLoader.h"

@implementation RoomPickerViewController {
    NSMutableArray* selectedRooms;
    NSUInteger uploadedAudiosCount;
    NSUInteger uploadedMediasCount;
    CAGradientLayer* maskLayer;
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedRooms = [NSMutableArray array];
    
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager fetchRoomsForUser:[[UserSession sharedSession] user]];
    
    self.rooms = [NSArray array];
    self.saver = [StoryWIPSaver sharedSaver];
    self.recorder = [[StoryMediaRecorder alloc] initWithStoryUUID:self.saver.uuid];
    
    [self.roomsTableView setContentInset:UIEdgeInsetsMake(70,0,150,0)];
    [self centerTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!maskLayer) {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        CGColorRef innerColor = kListenBackgroundColor.CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.8],
                               [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.roomsTableView.frame.size.width,
                                      self.roomsTableView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.roomsTableView.layer.mask = maskLayer;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createNewRoom:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRoom"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    User* user = [[UserSession sharedSession] user];
    NSArray* medias = [[StoryWIPSaver sharedSaver] medias];
    NSString* tag = [[StoryWIPSaver sharedSaver] tag];
    NSString* title = [[StoryWIPSaver sharedSaver] title];
    
    TPLoader* loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    
    [manager createStoryWithName:title owner:user inRooms:selectedRooms tag:tag medias:medias audiosFiles:medias];
}

#pragma mark - FileUploaderDelegate

- (void)fileUploader:(FileUploader *)uploader successfullyUploadedFileOfType:(NSString *)type toPath:(NSString *)path withFileName:(NSString *)filename {
    
    if ([type isEqualToString:kUploadTypeAudio]) {
        uploadedAudiosCount++;
    } else {
        uploadedMediasCount++;
    }
    
//    NSUInteger percent = ((uploadedAudiosCount+uploadedMediasCount) * 100) / (self.saver.medias.count*2);
//    loader.infoLabel.text = [NSString stringWithFormat:@"Envoi de l'histoire...(%d %%)", percent];
    
    // all good
    if (uploadedMediasCount == self.saver.medias.count && uploadedAudiosCount == self.saver.medias.count) {
        [loader removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [self.navigationController.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)fileUploader:(FileUploader *)uploader failedToUploadFileOfType:(NSString *)type toPath:(NSString *)path {
    // TODO
}

#pragma mark - RoomFetcherDelegate

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    
    BOOL first = self.rooms.count == 0;
    
    self.rooms = rooms;
    
    [self.roomsTableView reloadData];
    
    if (first) {
        [self animate];
    }
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
        UIImageView* picto = (UIImageView*)[cell.contentView viewWithTag:90];
        picto.image = [UIImage imageNamed:@"check-room"];
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
            picto.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        } completion:^(BOOL finished) {
            picto.transform = CGAffineTransformIdentity;
        }];
    } else {
        [selectedRooms removeObject:room];
        UIImageView* picto = (UIImageView*)[cell.contentView viewWithTag:90];
        picto.image = [UIImage imageNamed:@"picto_lucifer"];
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
            picto.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        } completion:^(BOOL finished) {
            picto.transform = CGAffineTransformIdentity;
        }];
    }
}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Keep gradient fixed in view
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
    
    for (UIRoomTableViewCell *cell in self.roomsTableView.visibleCells) {
        CGPoint cellCenter = [scrollView convertPoint:cell.center toView:scrollView.superview];
        
        int del = fabs(scrollView.superview.center.y -  cellCenter.y)/ 4.5;
        
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

- (void)animate
{
    [[self.roomsTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.1;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 150, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        [UIView animateWithDuration:.5f delay:delay  options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            [cell setAlpha:1];
        } completion:nil];
    }];
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