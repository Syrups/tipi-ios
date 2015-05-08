//
//  ReadModeViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 05/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ReadModeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Configuration.h"
#import <AFURLSessionManager.h>
@import AVFoundation;

@interface ReadModeViewController ()
@end

@implementation ReadModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.overlayView.alpha = 0;
    
    NSString* url = self.page.media.file;
    NSString* fileUrl = self.page.audio.file;
    
    //TODO change placeholder and loadings
    [self.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    [self downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        self.fileURL = filePath;
        //NSLog(@"File %@ downloaded to: %@",fileUrl, filePath);
    }];
    
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOverlayPlayer:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Overlay View
- (void)showOverlayPlayer:(UITapGestureRecognizer *)recognizer {
    
    
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self.overlayTimer invalidate];
    
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = self.overlayView.alpha == 0 ? 1.0 : 0;
    } completion:^(BOOL finished) {
        self.overlayTimer = [NSTimer timerWithTimeInterval:3
                                                    target:self
                                                  selector:@selector(hideOverlay:)
                                                  userInfo:nil
                                                   repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.overlayTimer forMode:NSRunLoopCommonModes];
    }];
}

- (void)hideOverlay:(NSTimer *)timer{
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.overlayView.alpha = 0;
    } completion:nil];
}

#pragma mark - Sound Playing
- (IBAction)playSound:(id)sender {
    if(self.fileURL){
        [self.parent playSound:self.fileURL];
    }
}

- (void) downloadFileWithURL: (NSString *) fileURL  completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error)) completionHandler{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    
    [downloadTask resume];
}
@end
