//
//  INConstants.h
//  in.notes
//
//  Created by iC on 5/2/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#pragma mark - Global

#define IN_ZERO 0
#define IN_DEFAULT_ANIMATION_DURATION 0.3
#define IN_DEFAULT_SPRING_DAMPING 0.8
#define IN_DEFAULT_DELAY 0.5
#define IN_IMAGE_STORE_DEFAULT_JPG_QUALITY 0.7
#define IN_GENERIC_Q "com.macciti.macciTi.genericQ"

#define IN_NOTES_DEFAULT_APP_COLOR [UIColor colorWithRed:0.44 green:0.51 blue:0.6 alpha:1]
#define IN_NOTES_DEFAULT_APP_COLOR_SECONDARY [UIColor colorWithRed:0.81 green:0.84 blue:0.87 alpha:1]

#pragma mark - Character Counter
#define IN_CHARACTER_COUNTER_INIT_FRAME CGRectMake(self.view.frame.size.width - 32.0f, self.view.frame.size.height - 276.0f, 23.0f, 16.0f)

static NSString * const INMigratingSqliteStoreName = @"in.notes";

static NSString * const kINManagedObjectContextDidDeleteLastItem = @"kINManagedObjectContextDidDeleteLastItem";
static NSString * const kINManagedObjectContextDidAddNewItem = @"kINManagedObjectContextDidAddNewItem";

#pragma mark - Bootstrap Data
static NSString * const kINBootstrappedInitialData = @"INBootstrappedInitialData";
static NSString * const kINBootstrapInitialText = @"This is your first post. Slide left to edit or delete. Tap on the image to preview.";
static NSString * const kINBootstrapInitialImage = @"intro-image";
static NSString * const kINBootstrapInitialThumbnail = @"intro-image-thumbnail";

static NSString * const kINNotesLogo = @"in-notes-logo";

#pragma mark - INHomeViewController
static NSString * const kINHomeViewController = @"INHomeViewController";

#pragma mark - INComposeViewController
static NSString * const kINComposeViewController = @"INComposeViewController";
static NSString * const kINEditViewController = @"INEditViewController";

static NSString * const kINImageStoreKey = @"imageStoreKey";

// Core Data
static NSString * const kINPostEntity = @"INPost";

#pragma mark - AttachmentView
/**
 *  IMPORTANT: The order of these values in important.
 *  buttonAtIndex (action sheet) directly connects to value
 *  of the request.
 */
typedef enum : NSUInteger {
    kINAttachmentRequestRemoveImage = 0,
    kINAttachmentRequestReplaceImage = 1,
    kINAttachmentRequestCancel = 2,
} kINAttachmentRequest;

// AttachmentContainer
#define IN_ATTACHMENT_CONTAINER_INIT_FRAME CGRectMake(0.0f, self.view.frame.size.height + 216.0f, 320.0f, 216.0f)
#define IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT CGRectMake(0.0f, self.view.frame.size.height - 216.0f, 320.0f, 216.0f)
#define IN_ATTACHMENT_VIEW_INIT_FRAME CGRectMake(10.0f, self.frame.size.height + 98.0f, 300.0f, 196.0f)
#define IN_ATTACHMENT_VIEW_SIZE CGSizeMake(300.0f, 196.0f)
#define IN_ATTACHMENT_VIEW_VISIBLE_FRAME CGRectMake(10.0f, 10.0f, 300.0f, 196.0f)
