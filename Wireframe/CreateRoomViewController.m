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
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)back:(id)sender {
//    [self.roomNameField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - UITextField
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    return !([newString length] > 30);
//    
//}

@end
