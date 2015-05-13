//
//  HomeViewController.m
//  Wireframe
//
//  Created by Leo on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseHomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goRooms:(id)sender
{
    
    // Assuming you have SomePageViewController.xib
    UINavigationController *roomController = [self.storyboard instantiateViewControllerWithIdentifier: @"ShowGroupsNavViewController"];
    
    [self presentViewController:roomController animated:NO completion:nil];
    //[self.navigationController pushViewController:roomController animated:YES];
}

- (IBAction)openProfile:(id)sender {
    UIViewController* profile = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    [profile willMoveToParentViewController:self];
    [self addChildViewController:profile];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.size.height;
    profile.view.frame = frame;
    [self.view addSubview:profile.view];
    [profile didMoveToParentViewController:self];
    
    [UIView animateWithDuration:.3f delay:0 usingSpringWithDamping:.5f initialSpringVelocity:.01f options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         self.profileButton.hidden = YES;
         CGRect frame = profile.view.frame;
         frame.origin.y = 0;
         profile.view.frame = frame;
    } completion:nil];
}

@end
