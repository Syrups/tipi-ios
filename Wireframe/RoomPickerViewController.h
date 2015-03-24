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


@interface RoomPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RoomFetcherDelegate, StoryCreatorDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView* roomsCollectionView;
@property (strong, nonatomic) NSArray* rooms;


@end
