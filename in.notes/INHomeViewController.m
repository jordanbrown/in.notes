//
//  INHomeViewController.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INHomeViewController.h"
#import "INPost+Manage.h"
#import "RZCellSizeManager.h"
#import "INImageTableViewCell.h"
#import "INImagePreview.h"
#import "INComposeViewController.h"
#import "INTextTableViewCell.h"

@interface INHomeViewController () <INImageTableViewCellDelegate, INImagePreviewDelegate>

- (void)configureSizeManager;
- (void)configureTableView;

- (IBAction)composeNewPostButtonSelected:(id)sender;

@end

@implementation INHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSizeManager];
    [self configureTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureSizeManager
{
    self.sizeManager = [[RZCellSizeManager alloc]init];

    [self.sizeManager registerCellClassName:[INImageTableViewCell className]
                         forReuseIdentifier:[INImageTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(id cell, id object) {
                         [cell setData:object];
                     }];
    
    [self.sizeManager registerCellClassName:[INTextTableViewCell className]
                         forReuseIdentifier:[INTextTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(id cell, id object) {
                         [cell setData:object];
                     }];
}

- (void)configureTableView
{
    self.fetchedResultsController = [INPost fetchAllGroupedBy:nil
                                                withPredicate:nil
                                                     sortedBy:@"date"
                                                    ascending:NO
                                                     delegate:self
                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    [self.tableView registerNib:[INImageTableViewCell nib] forCellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[INTextTableViewCell nib] forCellReuseIdentifier:[INTextTableViewCell reuseIdentifier]];
}

- (IBAction)composeNewPostButtonSelected:(id)sender
{
    [self performSegueWithIdentifier:kINComposeViewController sender:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *homeCell = nil;
    
    if (post.image) {
        
        INImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[INImageTableViewCell reuseIdentifier]];
        
        [imageCell setIndexPath:indexPath];
        [imageCell setData:post];
        [imageCell setImageCellDelegate:self];
        
        homeCell = imageCell;
        
    } else {
        
        INTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[INTextTableViewCell reuseIdentifier]];
        [textCell setIndexPath:indexPath];
        [textCell setData:post];
        
        homeCell = textCell;
    }
    
    return homeCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (post.image) {
        return [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
    } else {
        return [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INTextTableViewCell reuseIdentifier]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [INPost deletePost:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (post.image) {
        [self presentActivityViewControllerWithItems:@[[UIImage imageWithData:post.image], post.text]];
    } else {
        [self presentActivityViewControllerWithItems:@[post.text]];
    }
}

- (void)presentActivityViewControllerWithItems:(NSArray *)items
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIScrollViewdelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - MCImageTableViewCellDelegate

- (void)userDidSelectImageView:(UIImageView *)imageView indexPath:(NSIndexPath *)indexPath
{
    SProgressHUD *progressHUD = [[SProgressHUD alloc]initForViewType:kMCViewTypeImageThumbnailView];
    progressHUD.alpha = 0.0;
    
    __block INImagePreview *imagePreview = nil;
    
    [imageView addSubview:progressHUD];
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         progressHUD.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
                             imagePreview = [[INImagePreview alloc]initWithImage:[UIImage imageWithData:post.image]
                                                                            view:self.navigationController.view
                                                                      completion:^{
                                                                          
                                                                          [imagePreview removeFromSuperview];
                                                                          imagePreview = nil;
                                                                          
                                                                      }];
                             imagePreview.delegate = self;
                             [self.navigationController.view addSubview:imagePreview];
                             [imagePreview previewImage];
                             [progressHUD removeFromSuperview];
                         }
                         
                     }];
}

#pragma mark - MCIMagePreviewDelegate

- (void)imagePreviewDidFinishPreparingImage:(UIImage *)image
{
    NSArray *activityItems = @[image];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    dispatch_queue_t waitQ = dispatch_queue_create(IN_GENERIC_Q, NULL);
    dispatch_async(waitQ, ^{
        usleep(400000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityViewController animated:YES completion:nil];
        });
    });
}

@end
