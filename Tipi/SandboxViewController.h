//
//  SandboxViewController.h
//  Wireframe
//
//  Created by Leo on 15/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRecordButton.h"
#import <AVFoundation/AVFoundation.h>
#import <EZMicrophone.h>
#import "MediaLibrary.h"

@interface SandboxViewController : UIViewController <MediaLibraryDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) NSArray* photos;

@end
