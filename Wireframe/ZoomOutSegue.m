//
//  ZoomOutSegue.m
//  Wireframe
//
//  Created by Leo on 16/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ZoomOutSegue.h"

@implementation ZoomOutSegue

- (void)perform {
    UIViewController* record = self.sourceViewController;
    UIViewController* organizer = self.destinationViewController;
    
    [UIView animateWithDuration:.2f animations:^{
        [record.view addSubview:organizer.view];
        [record.view sendSubviewToBack:organizer.view];
        CGRect f = record.view.frame;
        f.origin.y = organizer.view.frame.size.height;
        [record.navigationController popViewControllerAnimated:NO];
    }];
}

@end
