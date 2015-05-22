//
//  WebViewController.m
//  Tipi
//
//  Created by Leo on 21/05/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
