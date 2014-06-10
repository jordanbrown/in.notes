//
//  INEditViewController.m
//  in.notes
//
//  Created by iC on 5/20/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INEditViewController.h"
#import "INPost+Manage.h"
#import "INMarkdownTextView.h"
#import "INCharacterCounter.h"
#import "INAttachmentContainer.h"
#import "INImageStore.h"

@interface INEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, INAttachmentContainerDelegate, INMarkdownTextViewDelegate>

@property (strong, nonatomic) INMarkdownTextView *markdownTextView;
@property (strong, nonatomic) INCharacterCounter *characterCounter;
@property (strong, nonatomic) INAttachmentContainer *attachmentContainer;

- (void)setup;
- (void)setupData;
- (void)presentImagePicker;
- (IBAction)publishButtonSelected:(id)sender;

@end

@implementation INEditViewController

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
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"done-button"] style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonSelected:)];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more-button"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonSelected:)];
    self.navigationItem.rightBarButtonItems = @[publishButton, moreButton];
    self.markdownTextView = [[INMarkdownTextView alloc]initWithFrame:IN_MARKDOWN_TEXT_VIEW_INIT_FRAME];
    self.markdownTextView.markdownDelegate = self;
    self.characterCounter = [[INCharacterCounter alloc]initWithFrame:IN_CHARACTER_COUNTER_INIT_FRAME];
    self.attachmentContainer = [[INAttachmentContainer alloc]initWithFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT];
    self.attachmentContainer.delegate = self;
    
    // Subviews setup.
    [self.view addSubview:self.markdownTextView];
    [self.view addSubview:self.characterCounter];
    [self.view addSubview:self.attachmentContainer];
    
    // Setup / populate views with data.
    [self setupData];
}

- (void)setupData
{
    if (self.post.text) {
        [self.markdownTextView setText:self.post.text];
        [self.characterCounter setText:[NSString stringWithFormat:@"%i", 240 - (int)self.markdownTextView.text.length]];
    }
    
    /**
     *  This check is required. If the post does not contain an image, imageWithData: will create an empty image
     *  and in turn create unexpected behaviour requuring the user to delete a "blank" image before adding new one.
     */
    if (self.post.image) {
        [[INImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
        [[INImageStore sharedStore]setImage:[UIImage imageWithData:self.post.image]forKey:kINImageStoreKey];
        [self.attachmentContainer setAttachmentImage:[[INImageStore sharedStore]imageForKey:kINImageStoreKey] usingSpringWithDamping:NO];
    }
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
    if (![[INImageStore sharedStore]imageForKey:kINImageStoreKey]) { self.post.image = nil; }
    if (![self canSavePOSTData]) { return; }
    
    [INPost editPost:self.post
            withText:self.markdownTextView.text
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
    [self performSelector:@selector(presentImagePicker) withObject:nil afterDelay:IN_DEFAULT_DELAY];
}

#pragma mark - Attachemnt Container Delegate

- (void)attachmentContainerDidRemoveImageWithRequest:(kINAttachmentRequest)request
{
    if (request == kINAttachmentRequestRemoveImage) {
        [self performSelector:@selector(setMarkdownTextViewAsFirstResponder) withObject:nil afterDelay:0.9];
        
        [[INImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
        [self.attachmentContainer.attachmentView setImage:nil];
        
    } else if (request == kINAttachmentRequestReplaceImage) {
        [self performSelector:@selector(moreButtonSelected:) withObject:nil afterDelay:IN_DEFAULT_DELAY];
    }
}

#pragma mark - Image Picker Delegate

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
    [self dismissViewControllerAnimated:YES completion:^{
        if (!self.attachmentContainer.attachmentView.image) {
            [self.markdownTextView becomeFirstResponder];
        }
    }];
}

#pragma mark - UINavigationControllerDelegate

/**
 *  See the INComposeViewController for more information.
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Markdown Text View Delegate

- (void)markdownTextViewDidUpdateCharactersCount:(int)count
{
    self.characterCounter.text = [NSString stringWithFormat:@"%i", count];
}

@end
