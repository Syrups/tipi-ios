//
//  ShowOneGroupViewController.m
//  Wireframe
//
//  Created by Glenn Sonna on 03/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ShowOneGroupViewController.h"

@interface ShowOneGroupViewController ()

@end

@implementation ShowOneGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mStories = @[@1, @2, @3, @4];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellStory";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //UILabel *name = (UILabel*)[cell.contentView viewWithTag:100];
    
    //name.text = @"ok";
    //name.text = [NSString stringWithFormat:@"Groupe %ld", (long)indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mStories.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*self.mShowOneGroupViewController =
    [[ShowOneGroupViewController alloc] initWithNibName:@"ShowOneGroupViewController"
                                                 bundle:nil];
    [self presentViewController:self.mShowOneGroupViewController animated:YES completion:nil];*/
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
