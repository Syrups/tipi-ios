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
    
    if ([self.roomNameField.text isEqualToString:@""]) return;
    
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
    
    AddUsersToRoomViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUsersToRoom"];
    vc.room = room;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    if (self.roomsController != nil) {
        NSMutableArray* mRooms = [self.roomsController.mGroups mutableCopy];
        [mRooms addObject:room];
        room.owner = CurrentUser;
        self.roomsController.mGroups = [mRooms copy];
        [self.roomsController.mTableView reloadData];
    }
    
    if (self.roomsPicker != nil) {
        NSMutableArray* mRooms = [self.roomsPicker.rooms mutableCopy];
        [mRooms addObject:room];
        room.owner = CurrentUser;
        self.roomsPicker.rooms = [mRooms copy];
        [self.roomsPicker.roomsTableView reloadData];
    }
    
}

- (void)roomManager:(RoomManager *)manager failedToCreateRoom:(NSError *)error {
    [loader removeFromSuperview];
    [TPAlert displayOnController:self withMessage:@"Impossible de créer le feu de camp, réessayez plus tard" delegate:nil];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self back:textField];
    
    return YES;
}


@end
