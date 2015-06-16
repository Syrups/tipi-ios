//
//  FeedbackViewController.m
//  Tipi
//
//  Created by Leo on 15/06/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PKAIDecoder.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [PKAIDecoder builAnimatedImageIn:self.logo fromFile:@"logo" withAnimationDuration:3.5f];
}

- (IBAction)openMailComposer {
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@", kFeedbackEmail];
    
    NSString *email = [NSString stringWithFormat:@"%@", recipients];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
