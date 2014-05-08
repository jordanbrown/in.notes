//
//  INHomeViewController.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INHomeViewController.h"
#import "INPost+Manage.h"

#import "INTableViewCell.h"
#import "INImageTableViewCell.h"
#import "INTextTableViewCell.h"
#import "INThumbnailViewProtocol.h"

#import "INImagePreview.h"
#import "INComposeViewController.h"
#import "INPlaceholderView.h"

@interface INHomeViewController () <INImagePreviewDelegate, INThumbnailViewDelegate>

- (void)configureSizeManager;
- (void)configureTableView;
- (void)configureObservers;
- (void)configureINPlaceholderView:(NSNotification *)note;

- (IBAction)composeNewPostButtonSelected:(id)sender;

@end

@implementation INHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSizeManager];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureObservers];
    [self configureINPlaceholderView:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureSizeManager
{
    self.sizeManager = [[RZCellSizeManager alloc]init];

    [self.sizeManager registerCellClassName:[INTableViewCell className]
                         forReuseIdentifier:[INTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(INTableViewCell *cell, INPost *post) {
                         [cell setPost:post];
                     }];
    
    [self.sizeManager registerCellClassName:[INTextTableViewCell className]
                         forReuseIdentifier:[INTextTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(INTextTableViewCell *textCell, INPost *post) {
                         [textCell setPost:post];
                     }];
    
    [self.sizeManager registerCellClassName:[INImageTableViewCell className]
                         forReuseIdentifier:[INImageTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(INImageTableViewCell *imageCell, INPost *post) {
                         [imageCell setPost:post];
                     }];
}

- (void)configureTableView
{
    self.fetchedResultsController = [INPost fetchAllGroupedBy:nil
                                                withPredicate:nil
                                                     sortedBy:@"date"
                                                    ascending:NO
                                                     delegate:self // super class, since THIS VC inherits from FRC.
                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
    
    [self.tableView registerNib:[INTableViewCell nib] forCellReuseIdentifier:[INTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[INTextTableViewCell nib] forCellReuseIdentifier:[INTextTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[INImageTableViewCell nib] forCellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
}

- (void)configureObservers
{
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kINManagedObjectContextDidAddNewItem
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [weakSelf configureINPlaceholderView:note];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kINManagedObjectContextDidDeleteLastItem
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [weakSelf configureINPlaceholderView:note];
                                                  }];
}

- (void)configureINPlaceholderView:(NSNotification *)note
{
    if ([note.name isEqualToString:kINManagedObjectContextDidAddNewItem] || [[INPost findAll]count] > IN_ZERO) {
        
        if ([[self.view.subviews lastObject] isKindOfClass:[INPlaceholderView class]]) {
            [self.view.subviews.lastObject removeFromSuperview];
        }
        
    } else if ([note.name isEqualToString:kINManagedObjectContextDidDeleteLastItem] || [[INPost findAll]count] == IN_ZERO) {
        
        [self.view addSubview:[[INPlaceholderView alloc]initWithFrame:self.view.frame image:[UIImage imageNamed:kINNotesLogo]]];
    }
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
    
    switch ([post.type integerValue]) {
        case kINPostTypeComplete: {
            INTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[INTableViewCell reuseIdentifier]];
            cell.post = post;
            cell.indexPath = indexPath;
            cell.delegate = self;
            homeCell = cell;
        }
            break;
        case kINPostTypeText: {
            INTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[INTextTableViewCell reuseIdentifier]];
            textCell.post = post;
            homeCell = textCell;
        }
            break;
        case kINPostTypeImage: {
            INImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[INImageTableViewCell reuseIdentifier]];
            imageCell.post = post;
            imageCell.indexPath = indexPath;
            imageCell.delegate = self;
            homeCell = imageCell;
        }
            break;
    }
    
    return homeCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat height = 0.0;
    
    switch ([post.type integerValue]) {
        case kINPostTypeComplete: {
            height = [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INTableViewCell reuseIdentifier]];
        }
            break;
        case kINPostTypeText: {
            height = [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INTextTableViewCell reuseIdentifier]];
        }
            break;
        case kINPostTypeImage: {
            height = [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
        }
            break;
    }
    
    return height < 44 ? 44 : height;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView setEditing:NO animated:YES];
        
        dispatch_queue_t waitQ = dispatch_queue_create(IN_GENERIC_Q, NULL);
        dispatch_async(waitQ, ^{
            usleep(400000);
            dispatch_async(dispatch_get_main_queue(), ^{
                [INPost deletePost:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            });
        });
    }
}

- (void)presentActivityViewControllerWithActivityItems:(NSArray *)items
{
    [self presentViewController:[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil] animated:YES completion:nil];
}

#pragma mark - UIScrollViewdelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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

#pragma mark - INThumbnailViewDelegate

- (void)thumbnail:(UIImageView *)thumbnail didSelectThumbnailImageView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    SProgressHUD *progressHUD = [[SProgressHUD alloc]initForViewType:kMCViewTypeImageThumbnailView];
	progressHUD.alpha = 0.0;
    
    __block INImagePreview *imagePreview = nil;
    
    CGPoint locationInView = [tapGestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationInView];
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [thumbnail addSubview:progressHUD];
	[UIView animateWithDuration:0.6 animations:^{
        progressHUD.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            imagePreview = [[INImagePreview alloc]initWithImage:[UIImage imageWithData:post.image] view:self.navigationController.view completion:^{
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

@end
