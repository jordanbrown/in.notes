//
//  INEditViewController.m
//  in.notes
//
//  Created by iC on 5/20/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

#import "INEditViewController.h"
#import "INPost+Manage.h"

@interface INEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AttachmentContainerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NotesTextView *notesTextView;
@property (strong, nonatomic) NSLayoutConstraint *notesTextViewBottomConstraint;
@property (strong, nonatomic) AttachmentContainer *attachmentContainer;

- (void)setup;
- (void)configureNotesTextView;
- (void)configureObservers;
- (void)setupData;
- (void)presentImagePicker;
- (IBAction)publishButtonSelected:(id)sender;

@end

@implementation INEditViewController

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        INAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return _managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNotesTextView];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureObservers];
    
    // This is required to fix UIImagePicker status bar change in an edge case
    // when the user performs partial swipe back and then forward on image picker.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setup {
    // Initialization.
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"done-button"] style:UIBarButtonItemStylePlain target:self action:@selector(publishButtonSelected:)];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more-button"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonSelected:)];
    self.navigationItem.rightBarButtonItems = @[publishButton, moreButton];
    self.attachmentContainer = [[AttachmentContainer alloc]initWithFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT];
    self.attachmentContainer.delegate = self;
    
    // Subviews setup.
    [self.view addSubview:self.attachmentContainer];
    
    // Setup / populate views with data.
    [self setupData];
}

- (void)configureNotesTextView {
    self.notesTextView = [[NotesTextView alloc]initWithView:self.view];
    self.notesTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add subview before applying constraints.
    [self.view addSubview:self.notesTextView];
    
    NSLayoutConstraint *notesTextViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.notesTextView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.view
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.0
                                                                                   constant:0.0];
    NSLayoutConstraint *notesTextViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.notesTextView
                                                                                    attribute:NSLayoutAttributeRight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.view
                                                                                    attribute:NSLayoutAttributeRight
                                                                                   multiplier:1.0
                                                                                     constant:0.0];
    NSLayoutConstraint *notesTextViewLeftConstraint = [NSLayoutConstraint constraintWithItem:self.notesTextView
                                                                                   attribute:NSLayoutAttributeLeft
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.view
                                                                                   attribute:NSLayoutAttributeLeft
                                                                                  multiplier:1.0 constant:0.0];
    
    self.notesTextViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.notesTextView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0.0];
    [self.view addConstraint:notesTextViewTopConstraint];
    [self.view addConstraint:notesTextViewRightConstraint];
    [self.view addConstraint:notesTextViewLeftConstraint];
    [self.view addConstraint:self.notesTextViewBottomConstraint];
}

- (void)configureObservers {

    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSDictionary *userInfo = note.userInfo;
                                                      CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
                                                      NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
                                                      CGRect finalKeyboardFrame = [self.view convertRect:keyboardFrame fromView:self.view.window];
                                                      CGFloat keyboardHeight = finalKeyboardFrame.size.height;
                                                      weakSelf.notesTextViewBottomConstraint.constant = -keyboardHeight + self.notesTextViewBottomConstraint.constant;
                                                      [UIView animateWithDuration:animationDuration animations:^{
                                                          [weakSelf.view layoutIfNeeded];
                                                      }];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSDictionary *userInfo = note.userInfo;
                                                      NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
                                                      weakSelf.notesTextViewBottomConstraint.constant = -self.attachmentContainer.frame.size.height;
                                                      [UIView animateWithDuration:animationDuration animations:^{
                                                          [weakSelf.view layoutIfNeeded];
                                                      }];
                                                  }];
}

- (void)setupData {
    if (self.post.text) {
        [self.notesTextView setText:self.post.text];
    }
    
    /**
     *  This check is required. If the post does not contain an image, imageWithData: will create an empty image
     *  and in turn create unexpected behaviour requuring the user to delete a "blank" image before adding new one.
     */
    if (self.post.image) {
        [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
        [[ImageStore sharedStore]setImage:[UIImage imageWithData:self.post.image]forKey:kINImageStoreKey];
        [self.attachmentContainer setAttachmentImage:[[ImageStore sharedStore]imageForKey:kINImageStoreKey] usingSpringWithDamping:NO];
    }
}

- (void)setMarkdownTextViewAsFirstResponder {
    [self.notesTextView becomeFirstResponder];
}

- (void)presentImagePicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)publishButtonSelected:(id)sender {
    if (![[ImageStore sharedStore]imageForKey:kINImageStoreKey]) { self.post.image = nil; }
    if (![self canSavePOSTData]) { return; }
    
    [INPost editPost:self.post
            withText:self.notesTextView.text
               image:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]
           thumbnail:[UIImage resizeImage:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]
                                   toSize:CGSizeMake(300.0f, 129.0f) cornerRadius:0.0]
            hashtags:[HashtagContainer hashtagArrayFromString:self.notesTextView.text]
             context:self.managedObjectContext];
    /**
     *  It is important to clear the cache because "image" is still in memory.
     *  User can post "empty" posts if not cleared.
     */
    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)canSavePOSTData {
    return [self.notesTextView.text length] || [[ImageStore sharedStore]imageForKey:kINImageStoreKey] ? YES : NO;
}

#pragma mark - MCMore Button Delegate

- (void)moreButtonSelected:(id)sender {
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

- (void)attachmentContainerDidRemoveImageWithRequest:(NSInteger)request {
    if (request == kINAttachmentRequestRemoveImage) {
        [self performSelector:@selector(setMarkdownTextViewAsFirstResponder) withObject:nil afterDelay:0.9];
        
        [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
        [self.attachmentContainer.attachmentView setImage:nil];
        
    } else if (request == kINAttachmentRequestReplaceImage) {
        [self performSelector:@selector(moreButtonSelected:) withObject:nil afterDelay:IN_DEFAULT_DELAY];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[ImageStore sharedStore]deleteImageForKey:kINImageStoreKey];
    [[ImageStore sharedStore]setImage:[info objectForKey:UIImagePickerControllerOriginalImage]forKey:kINImageStoreKey];
    [self dismissViewControllerAnimated:YES completion: ^{
        [self.notesTextView resignFirstResponder];
        [self.attachmentContainer setAttachmentImage:[[ImageStore sharedStore]imageForKey:kINImageStoreKey]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        if (!self.attachmentContainer.attachmentView.image) {
            [self.notesTextView becomeFirstResponder];
        }
    }];
}

#pragma mark - UINavigationControllerDelegate

/**
 *  See the INComposeViewController for more information.
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
