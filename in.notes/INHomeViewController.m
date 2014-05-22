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

#import "INEditViewController.h"

@interface INHomeViewController () <INImagePreviewDelegate, INThumbnailViewDelegate, MSCMoreOptionTableViewCellDelegate>

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
    
    // Setting footer to CGRectZero assure there are only separators for specific / added rows.
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
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
            [self.tableView setUserInteractionEnabled:YES];
        }
        
    } else if ([note.name isEqualToString:kINManagedObjectContextDidDeleteLastItem] || [[INPost findAll]count] == IN_ZERO) {
        [self.view addSubview:[[INPlaceholderView alloc]initWithFrame:self.view.frame image:[UIImage imageNamed:kINNotesLogo]]];
        [self.tableView setUserInteractionEnabled:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kINEditViewController]) {
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            INEditViewController *editViewController = (INEditViewController *)segue.destinationViewController;
            editViewController.post = post;
        }
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
            cell.incellDelegate = self;
            cell.delegate = self; // MoreButton delegate.
            homeCell = cell;
        }
            break;
        case kINPostTypeText: {
            INTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[INTextTableViewCell reuseIdentifier]];
            textCell.post = post;
            textCell.delegate = self;
            homeCell = textCell;
        }
            break;
        case kINPostTypeImage: {
            INImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[INImageTableViewCell reuseIdentifier]];
            imageCell.post = post;
            imageCell.incellDelegate = self;
            imageCell.delegate = self; // MoreButton delegate.
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
    
    // Making sure the cell height is at least 44 points.
    return height < 44 ? 44 : height;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView setEditing:NO animated:YES];
        
        /**
         *  Default animation fades out cell deletion from isEditing state.
         *  Performing 0.4 second sleep, returns cell into !isEditing state and
         *  then allows deletion to take over and perform animaion. 100% optional
         *  and honeslty a personal preference on how the animation should happen.
         */
        dispatch_queue_t waitQ = dispatch_queue_create(IN_GENERIC_Q, NULL);
        dispatch_async(waitQ, ^{
            usleep(400000);
            dispatch_async(dispatch_get_main_queue(), ^{
                [INPost deletePost:[self.fetchedResultsController objectAtIndexPath:indexPath] completion:^(NSError *error) {
                    // Post deleted.
                }];
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
    CGPoint locationInView = [tapGestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationInView];
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    __block INImagePreview *imagePreview = [[INImagePreview alloc]initWithImage:[UIImage imageWithData:post.image]
                                                                           view:self.navigationController.view completion:^{
        [imagePreview removeFromSuperview];
        imagePreview = nil;
                                                                               
    }];
    
    imagePreview.delegate = self;
    
    [self.navigationController.view addSubview:imagePreview];
    [imagePreview previewImage];
}

#pragma mark - MSCMoreOptionTableViewCellDelegate

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor redColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Edit";
}

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IN_NOTES_DEFAULT_APP_COLOR_SECONDARY;
}

- (void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        
        [tableView setEditing:NO animated:YES];
        
        dispatch_queue_t waitQ = dispatch_queue_create(IN_GENERIC_Q, NULL);
        dispatch_async(waitQ, ^{
            usleep(500000);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSegueWithIdentifier:kINEditViewController sender:indexPath];
                
            });
        });
        
    }
}

@end
