//
//  INTableViewController.h
//  in.notes
//
//  Created by iC on 5/4/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

/**
 *  This is the "root" TableViewController for this application.
 *  Any TableViewController created should inherit from this controller
 *  at some point (if the child view controller requires CoreData, make it inherit
 *  from INNotesFetchedResultsController that in turn inherits from this VC.
 
 *  This view controller implements the most common actions such as monitoring for
 *  content text size change. For example, if the user decides to change the text size
 *  in Settings, any view controller inheriting from this controller will have its table
 *  view cell text size updated to reflect that change. See implementation for more information.
 */

#import <UIKit/UIKit.h>

@interface INTableViewController : UITableViewController

@end
