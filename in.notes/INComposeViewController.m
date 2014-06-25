//
//  INComposeViewController.m
//  in.notes
//
//  Created by iC on 3/21/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INComposeViewController.h"
//#import "INAttachmentContainer.h"
#import "INPost+Manage.h"

@interface INComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AttachmentContainerDelegate, NotesTextViewDelegate>

@property (strong, nonatomic) NotesTextView *notesTextView;
@property (strong, nonatomic) CharacterCounter *characterCounter;
@property (strong, nonatomic) AttachmentContainer *attachmentContainer;

- (void)setup;
- (void)presentImagePicker;
- (IBAction)publishButtonSelected:(id)sender;

@end

@implementation INComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // This is required to fix UIImagePicker status bar change in an edge case
    // when the user performs partial swipe back and then forward on image picker.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.notesTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    // Initialization.
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"done-button"] style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonSelected:)];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more-button"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonSelected:)];
    self.navigationItem.rightBarButtonItems = @[publishButton, moreButton];
    self.notesTextView = [[NotesTextView alloc]initWithView:self.view];
    self.notesTextView.markdownDelegate = self;
    self.characterCounter = [[CharacterCounter alloc]initWithFrame:IN_CHARACTER_COUNTER_INIT_FRAME];
    self.attachmentContainer = [[AttachmentContainer alloc]initWithFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME];
    self.attachmentContainer.delegate = self;
    
    // Subviews setup.
    [self.view addSubview:self.notesTextView];
    [self.view addSubview:self.characterCounter];
    [self.view addSubview:self.attachmentContainer];
}

- (void)setMarkdownTextViewAsFirstResponder
{
    [self.notesTextView becomeFirstResponder];
}

- (void)presentImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)publishButtonSelected:(id)sender
{
    if (![self canSavePOSTData]) {
        return;
    }
    
    [INPost postWithText:self.notesTextView.text
                   image:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]
               thumbnail:[UIImage resizeImage:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]
                                       toSize:CGSizeMake(300.0f, 129.0f) cornerRadius:0.0]
                hashtags:[HashtagContainer hashtagArrayFromString:self.notesTextView.text] completion:^(NSError *error) {
                    
                    /**
                     *  It is important to clear the cache because "image" is still in memory.
                     *  User can post "empty" posts if not cleared.
                     */
                    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }];
}

- (BOOL)canSavePOSTData
{
    return [self.notesTextView.text length] || [[ImageStore sharedStore]imageForKey:kINImageStoreKey] ? YES : NO;
}

#pragma mark - MCMore Button Delegate

- (void)moreButtonSelected:(id)sender
{
    if (self.attachmentContainer.attachmentView.image) {
        if (self.notesTextView.isFirstResponder) {
            [self.notesTextView resignFirstResponder];
        } else {
            [self.notesTextView becomeFirstResponder];
        }
        return;
    }
    
    [self.attachmentContainer setFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT];
    [self.notesTextView resignFirstResponder];
    [self performSelector:@selector(presentImagePicker) withObject:nil afterDelay:IN_DEFAULT_DELAY];
}

#pragma mark - Attachemnt Container Delegate

- (void)attachmentContainerDidRemoveImageWithRequest:(NSInteger)request
{
    if (request == kINAttachmentRequestRemoveImage) {
        [self performSelector:@selector(setMarkdownTextViewAsFirstResponder) withObject:nil afterDelay:0.9];
    } else if (request == kINAttachmentRequestReplaceImage) {
        [self performSelector:@selector(moreButtonSelected:) withObject:nil afterDelay:IN_DEFAULT_DELAY];
    }
}

#pragma mark - Image Picker Delegate
/**
 *  MCImageStore is designed to hold a single image. So before
 *  selecting a new one, deleting the store completely to make
 *  sure only one / current / image is saved. After store deletion,
 *  adding the new image to the store.
 
 *  The purpose of the store is simple. If the selected image by the user
 *  is big, there is a chance that selection of that image will cause
 *  low memory warning. Becasue of it, system can purge the memory
 *  leaving attachment image NOT set and selected image lost.
 
 *  Because markdownTextView becomes first responder in viewDidAppear:,
 *  the keyboard will appear when imagePicker is dismissed. Telling
 *  markdownTextView to resign first responder here assures that the
 *  keyboard is hidden unless user decides to edit the post manually.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
    [[ImageStore sharedStore]setImage:[info objectForKey:UIImagePickerControllerOriginalImage]forKey:kINImageStoreKey];
    [self dismissViewControllerAnimated:YES completion: ^{
        [self.notesTextView resignFirstResponder];
        [self.attachmentContainer setAttachmentImage:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

/**
 *  Since I am setting my status bar style to light content in .plist by 
 *  setting "Status bar style" to UIStatusBarStyleLightContent and 
 *  "View controller-based status bar appearance" to "NO", when presenting 
 *  another uinavigation controller such as imagePicker, settings on the controller
 *  overwrites my settings by making status bar content dark. Implementing 
 *  the navigation controller delegate here assures that doesnt happen. This is required
 *  for it to work properly.
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Text View Delegate

- (void)notesTextViewDidUpdateCharactersCount:(NSInteger)count
{
    self.characterCounter.text = [NSString stringWithFormat:@"%i", (int)count];
}

@end
