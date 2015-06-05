//
//  CreateRoomViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "AddUsersToRoomViewController.h"
#import "TPLoader.h"

@interface CreateRoomViewController ()

@end

@implementation CreateRoomViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.roomNameField becomeFirstResponder];
}

- (IBAction)create:(id)sender {
    RoomManager* manager = [[RoomManager alloc] initWithDelegate:self];
    [manager createRoomWithName:[self.roomNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] andUsers:@[]];
    
    [self.roomNameField resignFirstResponder];
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
}

- (IBAction)back:(id)sender {
    [self.roomNameField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - RoomCreator

- (void)roomManager:(RoomManager *)manager successfullyCreatedRoom:(Room *)room {
    [loader removeFromSuperview];
    
    AddUsersToRoomViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:[self.restorationIdentifier isEqualToString:@"StoryBuilderCreateRoom"] ? @"StoryBuilderAddUsersToRoom" : @"AddUsersToRoom"];
    vc.room = room;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)roomManager:(RoomManager *)manager failedToCreateRoom:(NSError *)error {
    [loader removeFromSuperview];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self back:textField];
    
    return YES;
}


@end
