//
//  INHomeViewController.m
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INHomeViewController.h"
#import "INPost+Manage.h"

#import "INImageTableViewCell.h"
#import "INTextTableViewCell.h"

#import "INImagePreview.h"
#import "INComposeViewController.h"

@interface INHomeViewController () <INImageTableViewCellDelegate, INImagePreviewDelegate>

- (void)configureSizeManager;
- (void)configureTableView;
- (void)configureNotifications;

- (IBAction)composeNewPostButtonSelected:(id)sender;

@end

@implementation INHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSizeManager];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNotifications];
    [self showFavoriteQuote];
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

    [self.sizeManager registerCellClassName:[INImageTableViewCell className]
                         forReuseIdentifier:[INImageTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(INImageTableViewCell *imageCell, INPost *post) {
                         [imageCell setPost:post];
                     }];
    
    [self.sizeManager registerCellClassName:[INTextTableViewCell className]
                         forReuseIdentifier:[INTextTableViewCell reuseIdentifier]
                     withConfigurationBlock:^(INTextTableViewCell *textCell, INPost *post) {
                         [textCell setPost:post];
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

- (void)configureNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFavoriteQuote) name:kINManagedObjectContextDidDeleteLastItem object:nil];
}

- (void)showFavoriteQuote
{
    if ([[INPost findAll]count] == 0) {
        NSString *quote = [[INQuotes sharedQuotes]quote];
        
        NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc]init];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
        
        CGRect quoteRect = [quote boundingRectWithSize:CGSizeMake(260, 260)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes context:drawingContext];
        
        CGRect labelFrame = CGRectMake((self.tableView.frame.size.width / 2) - (quoteRect.size.width / 2),
                                       (self.tableView.frame.size.height / 2) - quoteRect.size.height * 2.2,
                                       quoteRect.size.width,
                                       quoteRect.size.height);
        
        UILabel *quoteLabel = [[UILabel alloc]initWithFrame:labelFrame];
        quoteLabel.alpha = 0.0;
        quoteLabel.numberOfLines = 0;
        quoteLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        quoteLabel.textColor = [UIColor lightGrayColor];
        quoteLabel.text = quote;
        
        [self.view addSubview:quoteLabel];
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             
                             quoteLabel.alpha = 1.0;
                             
                         }];
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
    
    if (post.image) {
        
        INImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:[INImageTableViewCell reuseIdentifier]];
        imageCell.post = post;
        homeCell = imageCell;
        
    } else {
        
        INTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:[INTextTableViewCell reuseIdentifier]];
        textCell.post = post;
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

@end
