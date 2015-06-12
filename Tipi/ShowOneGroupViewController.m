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
#import "HomeViewController.h"
#import "DeleteStoryModalViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIView+MTAnimation.h>
#import "Page.h"

@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController {
    TPLoader* loader;
    TPAlert* alert;
    TPCircleWaverControl* currentControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAVAudioSession];
    // Do any additional setup after loading the view.
    
    
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
    
    self.nameArrow.hidden = ! [self.room isAdmin:CurrentUser];
    
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
    self.previewImageView.alpha = 0.2f;
}

- (void)setupPreviewImageInBackground {
    Page* page = [[[self.mStories firstObject] pages] firstObject];
    self.previewImageView.alpha = .2f;
    [self.previewImageView sd_setImageWithURL:[NSURL URLWithString:page.media.file]];
}

#pragma mark - Actions

- (IBAction)didTapAdminButton:(id)sender {
    
    if ([self.room isAdmin:CurrentUser]) {
        AdminRoomViewController* vc = (AdminRoomViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminRoom"];
        vc.room = self.room;
        //    [self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)toStoryBuilder:(id)sender {
    
    // #1 make home container display story builder screen
    HomeViewController* home = (HomeViewController*)self.navigationController.parentViewController;
    [home displayChildViewController:home.storyViewController];
    
    // #2 launch story builder
    [home.storyViewController launchStoryBuilder:sender];
    
    // #3 reset campfire nav controller
    [(UINavigationController*)home.groupsViewController popToRootViewControllerAnimated:NO];
}


- (IBAction)displayFiltersController:(id)sender {
    FilterViewController* filterViewController = (FilterViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Filter"];
    filterViewController.room = self.room;
    filterViewController.parent = self;
    
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

- (void)applyFilters {
    NSLog(@"toto");
    StoryManager* manager = [[StoryManager alloc] initWithDelegate:self];
    [manager fetchStoriesForRoomId:[self.room.id integerValue] filteredByTag:self.filterTag orUser:self.filterUser];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (TPStoryTableViewCell *cell in self.mTableView.visibleCells) {
        [cell setEditMode:false];
    }
}

#pragma mark - Deletion

- (IBAction)deleteStory:(id)sender {
    
    // retrieve story object
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.mTableView];
    NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:buttonPosition];
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    
    DeleteStoryModalViewController* modal = [self.storyboard instantiateViewControllerWithIdentifier:@"DeleteStory"];
    modal.room = self.room;
    modal.story = story;
    
    [self addChildViewController:modal];
    modal.view.frame = self.view.frame;
    [self.view addSubview:modal.view];
    [modal didMoveToParentViewController:self];
}

#pragma mark - TableView


- (TPStoryTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellStory";
    TPStoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TPStoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    
    cell.isSwipeDeleteEnabled = [story.user.id isEqualToString:CurrentUser.id] || [self.room isAdmin:CurrentUser];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    
    NSDate *now = [NSDate date];
    NSDate *created = story.createdAt; // this date is UTC
    
    // convert UTC date to locale time zone
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    created = [created dateByAddingTimeInterval:timeZoneSeconds];
    
    NSTimeInterval diff = [now timeIntervalSinceDate:created];
    
    NSString* dateText;
    
    if (diff < 60) {
        dateText = @"A l'instant";
    } else if (diff < 3600) {
        dateText = [NSString stringWithFormat:@"Il y a %d minutes", (int)(diff / 60)];
    } else if (diff < 86400) {
        int h = (int) (diff / 3600);
        dateText = [NSString stringWithFormat:@"Il y a %d heures", h];
    } else if (diff > 86400 && diff < 172800) {
        dateText = [NSString stringWithFormat:@"Hier"];
    } else {
        dateText = [NSString stringWithFormat:@"Il y a %d jours", (int)(diff / 86400)];
    }
    
    //NSLog(@"%@", [story toJSONString]);
    
    UILabel *name = (UILabel*)[cell.contentView viewWithTag:10];
    name.text = story.title;
    
    UILabel *desc = (UILabel*)[cell.contentView viewWithTag:20];
    desc.text = [NSString stringWithFormat:@"%@ - %@", story.user.username, dateText];
    
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

#pragma mark - Transition to Read Mode

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

- (void)readModeContainerViewController:(ReadModeContainerViewController *)controller failedToCompleteLoadStory:(Story *)story {
    // TODO ERROR HANDLING
    [TPAlert displayOnController:self withMessage:@"Impossible de charger l'histoire" delegate:self];
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
    
    if ([stories count] == 0) {
        self.emptyInfoView.hidden = NO;
    }
    
    [self setupPreviewImageInBackground];
    
}

-(void)storyManager:(StoryManager *)manager failedToFetchStories:(NSError *)error{
    //error
    
    //    alert = [TPAlert displayOnController:self withMessage:@"Impossible de récupérer les histoires" delegate:self];
    [loader removeFromSuperview];
    
    self.errorLabel.hidden = NO;
}

#pragma mark - TPAlert

- (void)alertDidAknowledge:(TPAlert *)alert {
    [loader removeFromSuperview];
    [self.readModeContainer close];
}

#pragma mark - Navigation and animation

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    [self.view.layer removeAllAnimations];
    [self removeCoverModer];
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
    
    currentControl = cell.recordButton;
    
    [self loadPreviewMediaAtURL:mediaUrl withCompletionBlock:^(UIImage *image) {
        [self startPreviewWithImage:image];
    }];
}

- (void)circleWaverControl:(TPCircleWaverControl *)control didEndPlayingItem:(AVPlayerItem *)item{
    [self stopPreview];
}

-(void)startPreviewWithImage:(UIImage*)image{
    self.previewImageView.image = image;
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [UIView animateWithDuration:.7f animations:^{
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
    
    [currentControl close];
    
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
        [self setupPreviewImageInBackground];
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

- (void)transitionFromReadMode {
    [loader removeFromSuperview];
    self.previewImageView.alpha = 0;
    
}

- (void)animate {
    [[self.mTableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        
        int endY = cell.frame.origin.y;
        float delay = idx * 0.05;
        
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y + self.view.frame.size.height, cell.frame.size.width, cell.frame.size.height)];
        [cell setAlpha:0];
        
        
        [UIView animateWithDuration:.23f delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            [cell setAlpha:1];
            [cell setFrame:CGRectMake(cell.frame.origin.x, endY + 100, cell.frame.size.width, cell.frame.size.height)];
        } completion:^(BOOL finished) {
            [UIView mt_animateWithViews:@[cell] duration:1.3f delay:0 timingFunction:kMTEaseOutElastic animations:^{
                [cell setFrame:CGRectMake(cell.frame.origin.x, endY, cell.frame.size.width, cell.frame.size.height)];
            } completion:nil];
        }];
    }];
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
