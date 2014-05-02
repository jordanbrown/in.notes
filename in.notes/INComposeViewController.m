//
//  INComposeViewController.m
//  in.notes
//
//  Created by iC on 3/21/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INComposeViewController.h"
#import "MCMarkdownTextView.h"
#import "MCMoreButton.h"
#import "MCAttachmentContainer.h"
#import "MCImageStore.h"
#import "MCCharacterCounter.h"
#import "MCHashtagContainer.h"

@interface INComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCMoreButtonDelegate, MCAttachmentContainerDelegate, MCMarkdownTextViewDelegate>

@property (strong, nonatomic) MCMarkdownTextView *markdownTextView;
@property (strong, nonatomic) MCMoreButton *moreButton;
@property (strong, nonatomic) MCCharacterCounter *characterCounter;
@property (strong, nonatomic) MCAttachmentContainer *attachmentContainer;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *publishButton;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.markdownTextView becomeFirstResponder];
    [self.moreButton moveToPoint:MC_MORE_BUTTON_ABOVE_KEYBOARD_POINT];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    // Initialization.
    self.moreButton = [[MCMoreButton alloc]initWithFrame:MC_MORE_BUTTON_INIT_FRAME delegate:self];
    self.markdownTextView = [[MCMarkdownTextView alloc]initWithFrame:MC_MARKDOWN_TEXT_VIEW_INIT_FRAME];
    self.markdownTextView.markdownDelegate = self;
    self.characterCounter = [[MCCharacterCounter alloc]initWithFrame:MC_CHARACTER_COUNTER_INIT_FRAME];
    self.attachmentContainer = [[MCAttachmentContainer alloc]initWithFrame:MC_ATTACHMENT_CONTAINER_INIT_FRAME];
    self.attachmentContainer.delegate = self;
    
    // Subviews setup.
    [self.view addSubview:self.markdownTextView];
    [self.view addSubview:self.moreButton];
    [self.view addSubview:self.characterCounter];
    [self.view addSubview:self.attachmentContainer];
}

- (void)setMarkdownTextViewAsFirstResponder
{
    [self.markdownTextView becomeFirstResponder];
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
    // Save to Core Data.
}

#pragma mark - MCMore Button Delegate

- (void)moreButtonSelected:(id)sender
{
    if (self.attachmentContainer.attachmentView.image) {
        if (self.markdownTextView.isFirstResponder) {
            [self.markdownTextView resignFirstResponder];
        } else {
            [self.markdownTextView becomeFirstResponder];
        }
        return;
    }
    [self.markdownTextView resignFirstResponder];
    [self.attachmentContainer setFrame:MC_MARKDOWN_TEXT_VIEW_BEHIND_KEYBOARD_FRAME];
    [self performSelector:@selector(presentImagePicker) withObject:nil afterDelay:IN_DEFAULT_DELAY];
}

#pragma mark - Attachemnt Container Delegate

- (void)attachmentContainerDidRemoveImageWithRequest:(kMCAttachmentRequest)request
{
    if (request == kMCAttachmentRequestRemoveImage) {
        [self performSelector:@selector(setMarkdownTextViewAsFirstResponder) withObject:nil afterDelay:0.9];
    } else if (request == kMCAttachmentRequestReplaceImage) {
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
    [[MCImageStore sharedStore]deleteImageForKey:kMCImageStoreKey];
    [[MCImageStore sharedStore]setImage:[info objectForKey:UIImagePickerControllerOriginalImage]forKey:kMCImageStoreKey];
    [self dismissViewControllerAnimated:YES completion: ^{
        [self.markdownTextView resignFirstResponder];
        [self.attachmentContainer setAttachmentImage:[[MCImageStore sharedStore]imageForKey:kMCImageStoreKey]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Markdown Text View Delegate

- (void)markdownTextViewDidUpdateCharactersCount:(int)count
{
    self.characterCounter.text = [NSString stringWithFormat:@"%i", count];
}

@end
