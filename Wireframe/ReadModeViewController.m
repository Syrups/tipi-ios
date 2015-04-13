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
    // Do any additional setup after loading the view.
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kMediaRootUrl, [self.page.media.file lastPathComponent]];
    ///api/v1/pages/:page_id/media
    [self.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kAudioRootUrl, [self.page.audio.file lastPathComponent]];
    [self downloadFileWithURL:fileUrl completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        self.fileURL = filePath;
        
        NSLog(@"File %@ downloaded to: %@",fileUrl, filePath);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
