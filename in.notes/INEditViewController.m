//
//  INEditViewController.m
//  in.notes
//
//  Created by iC on 5/20/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INEditViewController.h"
#import "INPost+Manage.h"

@interface INEditViewController ()

@end

@implementation INEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.post.text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
