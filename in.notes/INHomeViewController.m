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

#import "INComposeViewController.h"
#import "INEditViewController.h"

@interface INHomeViewController () <ImagePreviewDelegate, ThumbnailViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)configureFetchedResultsController;
- (void)configureTableView;
- (void)configureObservers;
- (void)configureINPlaceholderView:(NSNotification *)note;

- (IBAction)composeNewPostButtonSelected:(id)sender;

@end

@implementation INHomeViewController

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        INAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return _managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureFetchedResultsController];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureObservers];
    [self configureINPlaceholderView:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kINPostEntity];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    request.sortDescriptors = @[descriptor];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                       managedObjectContext:self.managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    self.fetchedResultsController.delegate = self;
    NSError *error = nil; [self.fetchedResultsController performFetch:&error];
}

- (void)configureTableView {
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:320.0];
    [self.tableView registerNib:[INTableViewCell nib] forCellReuseIdentifier:[INTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[INImageTableViewCell nib] forCellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
    
    // Setting footer to CGRectZero assure there are only separators for specific / added rows.
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

- (void)configureObservers {
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kINManagedObjectContextDidAddNewItem
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [weakSelf configureINPlaceholderView:note];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kINManagedObjectContextDidDeleteLastItem
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [weakSelf configureINPlaceholderView:note];
                                                  }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:NSManagedObjectContextDidSaveNotification
                                                     object:nil queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification *note) {
                                                     [weakSelf.tableView reloadData];
                                                 }];
}

- (void)configureINPlaceholderView:(NSNotification *)note {
    if ([note.name isEqualToString:kINManagedObjectContextDidAddNewItem] || ![INPost isEmpty:self.managedObjectContext]) {
        if ([[self.view.subviews lastObject] isKindOfClass:[PlaceholderView class]]) {
            [self.view.subviews.lastObject removeFromSuperview];
            [self.tableView setUserInteractionEnabled:YES];
        }
        
    } else if ([note.name isEqualToString:kINManagedObjectContextDidDeleteLastItem] || [INPost isEmpty:self.managedObjectContext]) {
        [self.view addSubview:[[PlaceholderView alloc]initWithFrame:self.view.frame image:[UIImage imageNamed:kINNotesLogo]]];
        [self.tableView setUserInteractionEnabled:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kINEditViewController]) {
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            INEditViewController *editViewController = (INEditViewController *)segue.destinationViewController;
            editViewController.post = post;
        }
    }
}

- (IBAction)composeNewPostButtonSelected:(id)sender {
    [self performSegueWithIdentifier:kINComposeViewController sender:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *homeCell = nil;
    
    switch ([post.type integerValue]) {
        case kINPostTypeComplete: {
            INTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[INTableViewCell reuseIdentifier]];
            cell.post = post;
            cell.incellDelegate = self;
            homeCell = cell;
        }
            break;
        case kINPostTypeText: {
            UITableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"INTextTableViewCell"];
            textCell.textLabel.numberOfLines = 0;
            textCell.textLabel.textColor = [UIColor darkGrayColor];
            textCell.textLabel.text = post.text;
            homeCell = textCell;
        }
            break;
        case kINPostTypeImage: {
            INImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[INImageTableViewCell reuseIdentifier]];
            imageCell.post = post;
            imageCell.incellDelegate = self;
            homeCell = imageCell;
        }
            break;
    }
    
    return homeCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kINEditViewController sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat height = 0.0;
    
    switch ([post.type integerValue]) {
        case kINPostTypeComplete: {
            height = 0.0;// [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INTableViewCell reuseIdentifier]];
        }
            break;
        case kINPostTypeImage: {
            height = 0.0; // [self.sizeManager cellHeightForObject:post indexPath:indexPath cellReuseIdentifier:[INImageTableViewCell reuseIdentifier]];
        }
            break;
    }
    
    return height > 0.0 ? height : UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
                [INPost deletePost:[self.fetchedResultsController objectAtIndexPath:indexPath] context:self.managedObjectContext];
            });
        });
    }
}

- (void)presentActivityViewControllerWithActivityItems:(NSArray *)items {
    [self presentViewController:[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil] animated:YES completion:nil];
}

#pragma mark - UIScrollViewdelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - MCIMagePreviewDelegate

- (void)imagePreviewDidFinishPreparingImage:(ImagePreview *)view image:(UIImage *)image {
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

- (void)thumbnail:(UIImageView *)thumbnail didSelectThumbnailImageView:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint locationInView = [tapGestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationInView];
    INPost *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    __block ImagePreview *imagePreview = [[ImagePreview alloc]initWithImage:[UIImage imageWithData:post.image]
                                                                       view:self.navigationController.view completion:^{
                                                                           [imagePreview removeFromSuperview];
                                                                           imagePreview = nil;
                                                                       }];
    
    imagePreview.delegate = self;
    
    [self.navigationController.view addSubview:imagePreview];
    [imagePreview previewImage];
}

@end
