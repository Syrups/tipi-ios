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
#import "UIRoomTableViewCell.h"
#import "TPLoader.h"
#import "HomeViewController.h"
#import "HelpModalViewController.h"
#import "ImageUtils.h"
#import <UIView+MTAnimation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CreateRoomViewController.h"

@implementation RoomPickerViewController {
    NSMutableArray* selectedRooms;
    NSUInteger uploadedAudiosCount;
    NSUInteger uploadedMediasCount;
    CAGradientLayer* maskLayer;
    TPLoader* loader;
    TPAlert* alert;
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
    
    [self.roomsTableView setContentInset:UIEdgeInsetsMake(0,0,150,0)];
//    [self centerTable];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (NSDictionary* media in self.saver.medias) {
        UIImage* img = [media objectForKey:@"full"];
        NSData* data = UIImageJPEGRepresentation(img, 0);
        NSLog(@"Size of image : %lu", (unsigned long)data.length);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!maskLayer) {
//        maskLayer = [CAGradientLayer layer];
//        
//        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//        CGColorRef innerColor = kListenBackgroundColor.CGColor;
//        
//        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
//                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
//        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
//                               [NSNumber numberWithFloat:0.1],
//                               [NSNumber numberWithFloat:0.8],
//                               [NSNumber numberWithFloat:1.0], nil];
//        
//        maskLayer.bounds = CGRectMake(0, 0,
//                                      self.roomsTableView.frame.size.width,
//                                      self.roomsTableView.frame.size.height);
//        maskLayer.anchorPoint = CGPointZero;
//        
//        self.roomsTableView.layer.mask = maskLayer;
    }
}

- (IBAction)back:(id)sender {
    self.roomsTableView.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)send:(id)sender {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    User* user = [[UserSession sharedSession] user];
    NSArray* medias = [[StoryWIPSaver sharedSaver] medias];
    NSString* tag = [[StoryWIPSaver sharedSaver] tag];
    NSString* title = [[StoryWIPSaver sharedSaver] title];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
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
    
    NSLog(@"%u files downloaded (%u total)", uploadedAudiosCount+uploadedMediasCount, self.saver.medias.count*2);

    // all good
    if (uploadedMediasCount == self.saver.medias.count && uploadedAudiosCount == self.saver.medias.count) {
        [loader removeFromSuperview];
        self.roomsTableView.delegate = nil;
        
        [self displayModalViewController];
    }
}

- (void)fileUploader:(FileUploader *)uploader failedToUploadFileOfType:(NSString *)type toPath:(NSString *)path {
    // TODO
    alert = [TPAlert displayOnController:self withMessage:@"Impossible de créer l'histoire, vérifiez votre connexion" delegate:self];
}

#pragma mark - RoomFetcherDelegate

- (void)roomManager:(RoomManager *)manager successfullyFetchedRooms:(NSArray *)rooms {
    
    BOOL first = self.rooms.count == 0;
    
    NSMutableArray* tempRooms = [rooms mutableCopy];
    Room* roomDelete = nil;
    
    for (Room* room in tempRooms) {
        if (room.tipi_room && [room.tipi_room isEqualToString:@"1"])
            roomDelete = room;
    }
    
    [tempRooms removeObject:roomDelete];
    
    self.rooms = [tempRooms copy];
    
    [self.roomsTableView reloadData];
    
    if (first) {
        [self animate];
    }
}

- (void)roomManager:(RoomManager *)manager failedToFetchRooms:(NSError *)error {
    // error
    alert = [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Impossible de charger les feux de camp, vérifiez votre connexion", nil) delegate:self];
    [loader removeFromSuperview];
}

#pragma mark - StoryCreatorDelegate

- (void)storyManager:(StoryManager *)manager successfullyCreatedStory:(Story *)story withPages:(NSArray *)pages {
    NSLog(@"Story created");
    
    FileUploader* uploader = [[FileUploader alloc] init];
    uploader.delegate = self;
    
    [story.pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
        NSDictionary* media = (NSDictionary*)[self.saver.medias objectAtIndex:idx];
        
        NSData* data;
        NSString* type;
        
        if ([[media objectForKey:@"type"] isEqualToString:ALAssetTypeVideo]) {
            ALAssetRepresentation *rep = [(ALAsset*)[media objectForKey:@"asset"] defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned long)rep.size error:nil];
            
            
            data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
            NSLog(@"Size of video : %d", [data length]);
            type = kUploadTypeVideo;
        } else {
            type = kUploadTypeMedia;
            UIImage* image = [media objectForKey:@"full"];
            
            if (image.size.width > 2000) {
                image = [ImageUtils scaleImage:image toSize:CGSizeMake(image.size.width/3, image.size.height/3) mirrored:NO];
            }
            
            data = UIImageJPEGRepresentation(image, 0.5f);
        }
        
        
        NSString* mediaPath = [NSString stringWithFormat:@"/pages/%@/media", page.id];
        NSString* audioPath = [NSString stringWithFormat:@"/pages/%@/audio", page.id];
        
        [uploader uploadFileWithData:data toPath:mediaPath ofType:type];
        
        [uploader uploadFileWithData:[self.recorder dataOfAudioWithIndex:idx] toPath:audioPath ofType:kUploadTypeAudio];
    }];
}

- (void)storyManager:(StoryManager *)manager failedToCreateStory:(NSError *)error {
    NSLog(@"%@", error);
    
    alert = [TPAlert displayOnController:self withMessage:NSLocalizedString(@"Impossible de créer l'histoire, vérifiez votre connexion", nil) delegate:self];
    [loader removeFromSuperview];
}

#pragma mark - Modal

- (void)displayModalViewController {
    [HelpModalViewController instantiateModalViewOnParentController:self withDelegate:self andMessage:@"Et voilà ! votre histoire a bien été partagée"];
}

- (void)modalViewControllerDidAcknowledgedMessage:(HelpModalViewController *)controller {
    UINavigationController* rootNav = self.navigationController.parentViewController.navigationController;
    [rootNav popToRootViewControllerAnimated:YES];
    [[(HomeViewController*)rootNav.viewControllers[0] storyViewController] transitionFromStoryBuilder];
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
    
    UIImageView* picto = (UIImageView*)[cell.contentView viewWithTag:90];

    if ([selectedRooms containsObject:room]) {
        picto.image = [UIImage imageNamed:@"check-room"];
    } else {
        picto.image = [UIImage imageNamed:@"picto-fire-b"];
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
        
    } else {
        [selectedRooms removeObject:room];
        UIImageView* picto = (UIImageView*)[cell.contentView viewWithTag:90];
        picto.image = [UIImage imageNamed:@"picto-fire-b"];

    }
}


#pragma mark - UIScrollView


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self centerTable];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    [self centerTable];
}

- (void)centerTable {
    
    NSIndexPath *pathForCenterCell = [self.roomsTableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.roomsTableView.bounds), CGRectGetMidY(self.roomsTableView.bounds) - 100)];
    [self.roomsTableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)animate {
    [[self.roomsTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.05;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + self.view.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        
        [UIView animateWithDuration:.23f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            [cell setAlpha:1];
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY + 100, cell.frame.size.width, cell.frame.size.height)];
        } completion:^(BOOL finished) {
            [UIView mt_animateWithViews:@[cell] duration:1.3f delay:0 timingFunction:kMTEaseOutElastic animations:^{
                [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            } completion:nil];
        }];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToCreate"]) {
        CreateRoomViewController* vc = (CreateRoomViewController*)segue.destinationViewController;
        vc.roomsPicker = self;
    }
}

@end
