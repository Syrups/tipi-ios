//
//  CreateRoomViewController.m
//  Wireframe
//
//  Created by Leo on 28/04/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "AddUsersToRoomViewController.h"

@interface CreateRoomViewController ()

@end

@implementation CreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.roomNameField becomeFirstResponder];
}

- (IBAction)next:(id)sender {
    AddUsersToRoomViewController* vc = (AddUsersToRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddUsersToRoom"];
    
    vc.roomName = [self.roomNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
