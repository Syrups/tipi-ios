//
//  OrganizeStoryViewController.h
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"
#import "StoryWIPSaver.h"
#import "WaveBackground.h"

@interface OrganizeStoryViewController : UIViewController <LXReorderableCollectionViewDataSource, UICollectionViewDelegate, LXReorderableCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) StoryWIPSaver* saver;
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) IBOutlet UILabel* pageLabel;
@property (strong, nonatomic) IBOutlet WaveBackground* wave;

- (void)zoom;

@end
