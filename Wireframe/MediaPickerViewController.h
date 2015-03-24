//
//  MediaPickerViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryWIPSaver.h"

@interface MediaPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) NSMutableArray* medias;
@property (strong, nonatomic) IBOutlet UICollectionView* mediaCollectionView;
@property (strong, nonatomic) IBOutlet UILabel* selectedCount;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
