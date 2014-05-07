//
//  INComposeViewController.m
//  in.notes
//
//  Created by iC on 3/21/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INComposeViewController.h"
#import "INMarkdownTextView.h"
#import "INMoreButton.h"
#import "INAttachmentContainer.h"
#import "INImageStore.h"
#import "INCharacterCounter.h"
#import "INHashtagContainer.h"
#import "INPost+Manage.h"

@interface INComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, INMoreButtonDelegate, INAttachmentContainerDelegate, INMarkdownTextViewDelegate>

@property (strong, nonatomic) INMarkdownTextView *markdownTextView;
@property (strong, nonatomic) INMoreButton *moreButton;
@property (strong, nonatomic) INCharacterCounter *characterCounter;
@property (strong, nonatomic) INAttachmentContainer *attachmentContainer;

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
    [self.moreButton moveToPoint:IN_MORE_BUTTON_ABOVE_KEYBOARD_POINT];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[INImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    // Initialization.
    self.moreButton = [[INMoreButton alloc]initWithFrame:IN_MORE_BUTTON_INIT_FRAME delegate:self];
    self.markdownTextView = [[INMarkdownTextView alloc]initWithFrame:IN_MARKDOWN_TEXT_VIEW_INIT_FRAME];
    self.markdownTextView.markdownDelegate = self;
    self.characterCounter = [[INCharacterCounter alloc]initWithFrame:IN_CHARACTER_COUNTER_INIT_FRAME];
    self.attachmentContainer = [[INAttachmentContainer alloc]initWithFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME];
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
    if (![self canSavePOSTData]) {
        return;
    }
    
    [INPost postWithText:self.markdownTextView.text
                   image:[[INImageStore sharedStore]imageForKey:kINImageStoreKey]
               thumbnail:[UIImage resizeImage:[[INImageStore sharedStore]imageForKey:kINImageStoreKey]
                                       toSize:CGSizeMake(300.0f, 129.0f) cornerRadius:0.0]
                hashtags:[INHashtagContainer hashtagArrayFromString:self.markdownTextView.text] completion:^(NSError *error) {
                    
                    /**
                     *  It is important to clear the cache because "image" is still in memory.
                     *  User can post "empty" posts if not cleared.
                     */
                    [[INImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }];
}

- (BOOL)canSavePOSTData
{
    return [self.markdownTextView.text length] || [[INImageStore sharedStore]imageForKey:kINImageStoreKey] ? YES : NO;
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
    [self.attachmentContainer setFrame:IN_MARKDOWN_TEXT_VIEW_BEHIND_KEYBOARD_FRAME];
    [self performSelector:@selector(presentImagePicker) withObject:nil afterDelay:IN_DEFAULT_DELAY];
}

#pragma mark - Attachemnt Container Delegate

- (void)attachmentContainerDidRemoveImageWithRequest:(kINAttachmentRequest)request
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
    [[INImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
    [[INImageStore sharedStore]setImage:[info objectForKey:UIImagePickerControllerOriginalImage]forKey:kINImageStoreKey];
    [self dismissViewControllerAnimated:YES completion: ^{
        [self.markdownTextView resignFirstResponder];
        [self.attachmentContainer setAttachmentImage:[[INImageStore sharedStore]imageForKey:kINImageStoreKey]];
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
