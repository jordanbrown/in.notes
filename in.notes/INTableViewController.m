//
//  INTableViewController.m
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INTableViewController.h"

@interface INTableViewController ()

- (void)configureFontSize;

@end

@implementation INTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFontSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
