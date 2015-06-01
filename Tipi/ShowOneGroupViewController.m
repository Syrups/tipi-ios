//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowOneGroupViewController.h"
#import "UserSession.h"
#import "ReadModeContainerViewController.h"
#import "AdminRoomViewController.h"
#import "SHPathLibrary.h"
#import "FilterViewController.h"
#import "WaveToBottomTransitionAnimator.h"
#import "TPStoryTableViewCell.h"
#import "TPLoader.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController {
    TPLoader* loader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    desc.text = [Story NSDateToShowString: story.createdAt];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mStories.count;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showStory"]) {
        
        //TODO put in model
        NSIndexPath *indexPath = [self.mTableView indexPathForSelectedRow];
        Story* story = [self.mStories objectAtIndex:indexPath.row];
        NSUInteger selectedStory = [story.id integerValue];
        
        ReadModeContainerViewController* reveal = segue.destinationViewController;
        reveal.storyId = selectedStory;
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
}

-(IBAction)prepareForGoBackToOneGroup:(UIStoryboardSegue *)segue {
    
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
    
    NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startPreviewForRowAtIndexPath:indexPath];
    
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded
              || gestureRecognizer.state ==UIGestureRecognizerStateCancelled){
        [self stopPreview];
    }else {
        NSLog(@"gestureRecognizer.state = %ld", (long)gestureRecognizer.state);
    }
}

-(void)startPreviewForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    self.isPreviewMode = YES;
    self.previewImageView.alpha = 0;
    
    Story* story = [self.mStories objectAtIndex:indexPath.row];
    Page* first = [story.pages objectAtIndex:0];

    Audio* audio = first.audio;
    Media* media = first.media;
    
    NSURL *audioUrl = [[NSURL alloc]initWithString:audio.file];
    NSURL *mediaUrl = [[NSURL alloc]initWithString:media.file];
    
    AVPlayerItem *aPlayerItem = [[AVPlayerItem alloc] initWithURL:audioUrl];
    self.previewAudioPlayer = [[AVPlayer alloc] initWithPlayerItem:aPlayerItem];
    self.previewAudioPlayer.volume = 1;
    
    SDImageCache *previewCache = [SDImageCache sharedImageCache];
    [previewCache queryDiskCacheForKey:@"roomPreview" done:^(UIImage *image, SDImageCacheType cacheType) {

        if(image){
            [self startPreviewWithImage:image];
        }else{
            [self.previewImageView sd_setImageWithURL:mediaUrl
                                     placeholderImage:[UIImage imageNamed:@"walkscreen"]
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                [[SDImageCache sharedImageCache] storeImage:image forKey:@"roomPreview"];
                                                [self startPreviewWithImage:image];
                                            }];
        }
    }];
}


-(void)startPreviewWithImage:(UIImage*)image{
    self.previewImageView.image = image;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.previewImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.previewAudioPlayer play];
    }];
}

-(void)stopPreview {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.previewImageView.alpha = 0;
        self.previewAudioPlayer.volume = 0;
    } completion:^(BOOL finished) {
        [self.previewAudioPlayer pause];
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
