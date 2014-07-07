//
//  INNotesFetchedResultsController.h
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

/**
 *  INNotesFetchedResultsController is a subclass of INTableViewController
 *  and is responsible for managing an instance of NSFetchedResultsController.
 *  Any ViewController (TableViewController) that requires interaction with
 *  CoreData should inherit from this VC. 
 
 *  In addition to interaction with CoreData, this VC invalidates cell height
 *  size cache once controller:didChangeObject:atIndexPath:forChangeType:newIndexPath: This might change
 *  in the near future though.
 */

#import "INTableViewController.h"

@interface INNotesFetchedResultsController : INTableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
