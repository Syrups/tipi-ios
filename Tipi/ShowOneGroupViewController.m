//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "AdminRoomViewController.h"
#import "SHPathLibrary.h"
#import "FilterViewController.h"
#import "WaveToBottomTransitionAnimator.h"
#import "TPStoryTableViewCell.h"
#import "TPLoader.h"
#import "TPAlert.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController {
    TPLoader* loader;
    TPAlert* alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAVAudioSession];
    // Do any additional setup after loading the view.
    
    //[SHPathLibrary addBackgroundPathForstoriesToView:self.view];
    self.view.backgroundColor = [UIColor colorWithRed:178/255.0  green:47/255.0 blue:43/255.0 alpha:1];
    
    //self.mStories = @[@"coup de chance", @"Conférence F.A.M.E", @"Plexus Gobelins"];
    
    [self.roomNameButton setTitle:self.room.name forState:UIControlStateNormal];
    
    NSLog(@"Room is %@", self.room.id);
    
    loader = [[TPLoader alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loader];
    [self.view sendSubviewToBack:loader];
    
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:[self.room.id integerValue] filteredByTag:nil orUser:nil];
    
    if ([self.room isAdmin:CurrentUser]) {
        [self.roomNameButton addTarget:self action:@selector(didTapAdminButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeCell:)];
    //swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    //UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeCell:)];
    //[self addGestureRecognizer:panGesture];
    //[self.mTableView addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer *previewModeGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPreviewMode:)];
    previewModeGesture.minimumPressDuration = 0.5; //seconds
    previewModeGesture.delegate = self;
    [self.mTableView addGestureRecognizer:previewModeGesture];
    
    //Preview Init
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.previewImageView.frame.size.width, self.previewImageView.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    overlay.tag = 2048;
    [self.previewImageView addSubview:overlay];
    self.previewImageView.alpha = 0;
}

#pragma mark - Actions

- (IBAction)didTapAdminButton:(id)sender {
    AdminRoomViewController* vc = (AdminRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminRoom"];
    vc.room = self.room;
    [self presentViewController:vc animated:YES completion:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)displayFiltersController:(id)sender {
    FilterViewController* filterViewController = (FilterViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    filterViewController.room = self.room;
    
    /*
     [vc willMoveToParentViewController:self];
     [self addChildViewController:vc];
     vc.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
     [self.view addSubview:vc.view];
     
     [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     vc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     } completion:nil];
     [vc didMoveToParentViewController:self];*/
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:filterViewController animated:NO completion:^{
        
    }];
    
    filterViewController.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        filterViewController.view.alpha = 1;
    }];
}


#pragma mark - Filters

- (IBAction)deleteStory:(id)sender {
}

- (void)applyFilters {
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:[self.room.id integerValue] filteredByTag:self.filterTag orUser:self.filterUser];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (TPStoryTableViewCell *cell in self.mTableView.visibleCells) {
        [cell setEditMode:false];
    }
}

#pragma mark - TableView


- (TPStoryTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellStory";
    TPStoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TPStoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    
    
    //NSLog(@"%@", [story toJSONString]);
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = story.title;
    
    UILabel *desc = (UILabel*)[cell.contentView viewWithTag:20];
    desc.text = [NSString stringWithFormat:@"%@ - %@", story.user.username, [Story NSDateToShowString: story.createdAt]];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mStories.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self startCoverModeWithAnimatingCell:cell atIndexPath:indexPath withCompletionBlock:^(BOOL done) {
        Story* story = [self.mStories objectAtIndex:indexPath.row];
        
        self.readModeContainer = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadModeContainer"];
        
        self.readModeContainer.storyId = [story.id integerValue];;
        self.readModeContainer.textBaseFrame = [self.mTableView  convertRect:cell.frame toView:self.view];
        self.readModeContainer.delegate = self;
        
        [self prepareReadModeContainerControllerWith:self toViewController:self.readModeContainer ];
    }];
}

- (void) prepareReadModeContainerControllerWith:(UIViewController*) fromController
                               toViewController:(UIViewController*) toController
{
    toController.view.frame = self.readContainer.bounds;
    [toController willMoveToParentViewController:nil];//  1
    [self.readContainer addSubview:toController.view];
    [self addChildViewController:toController];
    [toController didMoveToParentViewController:self];
    
    /*[self transitionFromViewController:fromController
     toViewController:toController
     duration:0.2
     options:direction | UIViewAnimationOptionCurveEaseIn
     animations:nil
     completion:^(BOOL finished) {
     
     
     }];*/
}

- (void)readModeContainerViewController:(ReadModeContainerViewController *)controller didFinishedLoadingStory:(Story *)story{
    
    [UIView animateWithDuration:1 animations:^{
        self.previewImageView.transform = CGAffineTransformMakeScale(1.2,1.2);
        self.previewImageView.alpha = 0;
        
        self.topBar.alpha = 0;
        self.mTableView.alpha = 0;
        
        loader.alpha = 0;
    } completion:^(BOOL finished) {
        
        [loader removeFromSuperview];
        //[fromController removeFromParentViewController];    //  3
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStory"]) {
        
        //TODO put in model
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Story* story = [self.mStories objectAtIndex:indexPath.row];
        NSUInteger selectedStory = [story.id integerValue];
        
        UITableViewCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
        
        ReadModeContainerViewController* reveal = segue.destinationViewController;
        reveal.storyId = selectedStory;
        reveal.textBaseFrame = [self.mTableView  convertRect:cell.frame toView:self.view];
        
    } else if ([segue.identifier isEqualToString:@"ToFilters"]) {
        ((FilterViewController*)segue.destinationViewController).room = self.room;
    }
    
    if([segue.identifier isEqualToString:@"showFilters"]) {
        
        FilterViewController* filterViewController = segue.destinationViewController;
        filterViewController.room = self.room;
        filterViewController.transitioningDelegate = self;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[WaveToBottomTransitionAnimator alloc]init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[WaveToBottomTransitionAnimator alloc]init];
}


- (void)storyManager:(StoryManager *)manager successfullyFetchedStories:(NSArray *)stories{
    
    [loader removeFromSuperview];
    
    self.mStories = stories;
    [self.mTableView reloadData];
    [self animate];
}

-(void)storyManager:(StoryManager *)manager failedToFetchStories:(NSError *)error{
    //error
    
//    alert = [TPAlert displayOnController:self withMessage:@"Impossible de récupérer les histoires" delegate:self];
    [loader removeFromSuperview];
    
    self.errorLabel.hidden = NO;
}

#pragma mark - TPAlert

- (void)alertDidAknowledge:(TPAlert *)alert {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    [self.view.layer removeAllAnimations];
    [self removeCoverModer];
}


- (void)animate
{
    [[self.mTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.1;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 150, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        [UIView animateWithDuration:.5f delay:delay  options:UIViewAnimationOptionCurveEaseOut animations:^{
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            [cell setAlpha:1];
        } completion:nil];
    }];
}


-(void)longPressPreviewMode:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.mTableView];
    
    NSIndexPath *indexpath = [self.mTableView indexPathForRowAtPoint:p];
    TPStoryTableViewCell* cell = (TPStoryTableViewCell*)[self.mTableView cellForRowAtIndexPath:indexpath];
    
    if (indexpath != nil) {
        
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                [self startPreviewForRowAtIndexPath:indexpath];
                cell.isSwipeDeleteEnabled = NO;
                break;
                
            case UIGestureRecognizerStateEnded:
                [self stopPreview];
                cell.isSwipeDeleteEnabled = YES;
                break;
                
            case UIGestureRecognizerStateCancelled:
                [self stopPreview];
                cell.isSwipeDeleteEnabled = YES;
                break;
                
            default:
                break;
        }
    }else if(self.isPreviewMode){
        if(gestureRecognizer.state == UIGestureRecognizerStateEnded ||
           gestureRecognizer.state == UIGestureRecognizerStateCancelled){
            
            [self stopPreview];
        }
    }
}

-(void)startPreviewForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    self.currentIndexPath = indexPath;
    self.isPreviewMode = YES;
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    Page* first = [story.pages objectAtIndex:0];
    
    Audio* audio = first.audio;
    Media* media = first.media;
    
    NSURL *audioUrl = [[NSURL alloc]initWithString:audio.file];
    NSURL *mediaUrl = [[NSURL alloc]initWithString:media.file];
    
    AVPlayerItem *aPlayerItem = [[AVPlayerItem alloc] initWithURL:audioUrl];
    
    self.previewAudioPlayer = [[AVPlayer alloc] initWithPlayerItem:aPlayerItem];
    self.previewAudioPlayer.volume = 1;
    
    TPStoryTableViewCell *cell = (TPStoryTableViewCell*)[self.mTableView cellForRowAtIndexPath:indexPath];
    cell.recordButton.simplePlayer = self.previewAudioPlayer;
    cell.recordButton.autoStart = YES;
   
    cell.recordButton.alpha = 1;
    [cell.recordButton appear];
    
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:aPlayerItem];
    
    [self loadPreviewMediaAtURL:mediaUrl withCompletionBlock:^(UIImage *image) {
        [self startPreviewWithImage:image];
    }];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self stopPreview];
}

-(void)startPreviewWithImage:(UIImage*)image{
    self.previewImageView.image = image;
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [UIView animateWithDuration:1 animations:^{
        self.previewImageView.transform = CGAffineTransformMakeScale(1.2,1.2);
        for (UIView *view in [self.view subviews] ) {
            if(view != self.previewImageView){
                view.alpha = 0.4;
            }
        }
        
        self.previewImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.previewAudioPlayer play];
    }];
}

-(void)stopPreview {
    
    TPStoryTableViewCell* cell = (TPStoryTableViewCell*)[self.mTableView cellForRowAtIndexPath:self.currentIndexPath];
    
    [cell.recordButton close];
    
    self.isPreviewMode = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        for (UIView *view in [self.view subviews] ) {
            if(view != self.previewImageView){
                view.alpha = 1;
            }
        }
        
        self.previewImageView.alpha = 0;
        self.previewAudioPlayer.volume = 0;
        self.previewImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.previewAudioPlayer pause];
    }];
}


- (void)startCoverModeWithAnimatingCell:(UITableViewCell*)selectedCell atIndexPath:(NSIndexPath*)indexPath withCompletionBlock:(void (^)(BOOL))block
{
    
    [self.view addSubview:loader];
    
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    Page* first = [story.pages objectAtIndex:0];
    
    Media* media = first.media;
    
    NSURL *mediaUrl = [[NSURL alloc]initWithString:media.file];
    [self loadPreviewMediaAtURL:mediaUrl withCompletionBlock:^(UIImage *image) {
        
        self.previewImageView.image = image;
        self.previewImageView.clipsToBounds = YES;
        
        [UIView animateWithDuration:1 animations:^{
            self.previewImageView.alpha = 1;
            
            for (UITableViewCell *cell in [self.mTableView visibleCells]) {
                if(cell != selectedCell){
                    cell.alpha = 0;
                }
            }
            
            selectedCell.frame = CGRectMake(CGRectGetMinX(selectedCell.frame), 0, CGRectGetWidth(selectedCell.frame), CGRectGetHeight(selectedCell.frame));
            selectedCell.alpha = 1;
            
        } completion:^(BOOL finished) {
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                block(finished);
            });
        }];
    }];
}

-(void) removeCoverModer{
    self.previewImageView.alpha = 0.0;
    [self.mTableView reloadInputViews];
}

-(void)loadPreviewMediaAtURL:(NSURL*)mediaUrl withCompletionBlock:(void (^)(UIImage*))block{
    
    //SDImageCache *previewCache = [SDImageCache sharedImageCache];
    [self.previewImageView sd_setImageWithURL:mediaUrl
                             placeholderImage:[UIImage imageNamed:@"walkscreen"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        [[SDImageCache sharedImageCache] storeImage:image forKey:@"roomPreview"];
                                        block(image);
                                    }];
    /*[previewCache queryDiskCacheForKey:@"roomPreview" done:^(UIImage *image, SDImageCacheType cacheType) {
     
     if(image){
     block(image);
     }else{
     
     }
     }];*/
}

- (void) configureAVAudioSession
{
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //error handling
    BOOL success;
    NSError* error;
    
    //set the audioSession category.
    //Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:&error];
    
    if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
    
    //set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    //activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) NSLog(@"AVAudioSession error activating: %@",error);
    else NSLog(@"audioSession active");
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
