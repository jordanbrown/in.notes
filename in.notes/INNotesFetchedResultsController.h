//
//  INNotesFetchedResultsController.h
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INNotesFetchedResultsController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) RZCellSizeManager *sizeManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
