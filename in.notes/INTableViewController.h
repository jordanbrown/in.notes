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
 
 *  This view controller also offers a way to easily setup size manager by exposing sizeManager
 *  property on to any subclass. For more information, see below.
 */

#import <UIKit/UIKit.h>

@interface INTableViewController : UITableViewController

/**
 *  sizeManage is responsible for calcculating the height of 
 *  each cusom cell registered with table view. You need to explicitly
 *  initialize it in a subclass like so using this method: 
 *  registerCellClassName:forReuseIdentifier: withConfigurationBlock.
 
 *  For more information and an example of implementation, see INHomeViewController. Read about it here:
 *  https://github.com/Raizlabs/RZCellSizeManager
 */
@property (strong, nonatomic) RZCellSizeManager *sizeManager;

@end
