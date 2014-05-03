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
#import "MCImageTableViewCell.h"
#import "MCImagePreview.h"

@interface INHomeViewController () <NSFetchedResultsControllerDelegate, MCImageTableViewCellDelegate>

@property (strong, nonatomic) RZCellSizeManager *sizeManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureSizeManager;
- (void)configureTableView;
- (void)configureFontSize;

@end

@implementation INHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSizeManager];
    [self configureTableView];
    [self configureFontSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureSizeManager
{
    self.sizeManager = [[RZCellSizeManager alloc]init];
    
    [self.sizeManager registerCellClassName:[MCImageTableViewCell className]
                             forObjectClass:[MCImageTableViewCell class]
                         configurationBlock:^(MCImageTableViewCell *cell, id object) {
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
    
    [self.tableView registerNib:[MCImageTableViewCell nib] forCellReuseIdentifier:[MCImageTableViewCell reuseIdentifier]];
}

- (void)configureFontSize
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(preferredContentSizeChanged:)
                                                name:UIContentSizeCategoryDidChangeNotification
                                              object:nil];
}

- (void)preferredContentSizeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

#pragma mark - NSFetched Results Controller

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    MCImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[MCImageTableViewCell reuseIdentifier]];
    
    [imageCell setIndexPath:indexPath];
    [imageCell setData:post];
    [imageCell setImageCellDelegate:self];
    
    return imageCell;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        case NSFetchedResultsChangeMove:
            break;
    }
    
    /**
     *  Invalidating cell height. This is required is order for new content coming out of CoreData
     *  to work / size properly. Without this, it simply wont size properly due to cached cell height. This also
     *  can use someoptimizing. More information / and the way I made it work, see https://github.com/Raizlabs/RZCellSizeManager
     */
    [self.sizeManager invalidateCellHeightsForResultsController:controller changeType:type indexPath:indexPath newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [self.sizeManager cellHeightForObject:post indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [INPost deletePost:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
    }
}

#pragma mark - MCImageTableViewCellDelegate

- (void)userDidSelectImageView:(UIImageView *)imageView indexPath:(NSIndexPath *)indexPath
{
    /**
     *  If the user is loading the image, disable interactions to assure he / she cant navigate to
     *  a comment / new post / view controller.
     */
    // [self.feedViewController.navigationController.view setUserInteractionEnabled:NO];
    
    SProgressHUD *progressHUD = [[SProgressHUD alloc]initForViewType:kMCViewTypeImageThumbnailView];
    progressHUD.alpha = 0.0;
    
    __block MCImagePreview *imagePreview = nil;
    
    [imageView addSubview:progressHUD];
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         progressHUD.alpha = 1.0;
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
                             imagePreview = [[MCImagePreview alloc]initWithImage:[UIImage imageWithData:post.image]
                                                                            view:self.navigationController.view
                                                                      completion:^{
                                                                          
                                                                          [imagePreview removeFromSuperview];
                                                                          imagePreview = nil;
                                                                          
                                                                      }];
                             
                             [self.navigationController.view addSubview:imagePreview];
                             [imagePreview previewImage];
                             [progressHUD removeFromSuperview];
                         }
                         
                     }];
}

@end