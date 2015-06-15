//
//  FeedbackViewController.m
//  Tipi
//
//  Created by Leo on 15/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)openMailComposer {
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@", kFeedbackEmail];
    
    NSString *email = [NSString stringWithFormat:@"%@", recipients];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
