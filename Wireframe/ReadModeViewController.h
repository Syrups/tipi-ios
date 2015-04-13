//
//  ReadModeViewController.h
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "ReadModeContainerViewController.h"

@interface ReadModeViewController : UIViewController
    @property (weak, nonatomic) IBOutlet UIImageView *image;
    @property (nonatomic) NSUInteger idx;
    @property (nonatomic) Page *page;
    @property (strong,nonatomic) ReadModeContainerViewController *parent;
    @property (strong,nonatomic) NSURL* fileURL;

- (IBAction)playSound:(id)sender;
@end
