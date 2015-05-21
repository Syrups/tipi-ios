//
//  RoomPickerViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomManager.h"
#import "StoryManager.h"
#import "StoryWIPSaver.h"
#import "StoryMediaRecorder.h"
#import "FileUploader.h"

@interface RoomPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RoomFetcherDelegate, StoryCreatorDelegate, FileUploaderDelegate>

@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) StoryMediaRecorder* recorder;
@property (strong, nonatomic) IBOutlet UITableView* roomsTableView;
@property (strong, nonatomic) NSArray* rooms;


@end
