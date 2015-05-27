//
//  MediaPickerViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryWIPSaver.h"
#import "MediaLibrary.h"
#import "WaveBackground.h"

@interface MediaPickerViewController : ShowCaseableViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, MediaLibraryDelegate>

@property (strong, nonatomic) NSMutableArray* selectedIndexes;
@property (strong, nonatomic) MediaLibrary* library;
@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) NSMutableArray* medias;
@property (strong, nonatomic) IBOutlet UICollectionView* mediaCollectionView;
@property (strong, nonatomic) IBOutlet UIButton* continueButton;
@property (strong, nonatomic) IBOutlet WaveBackground* wave;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* continueButtonYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* topControlsYConstraint;

@end
