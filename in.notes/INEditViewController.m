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
#import "INMoreButton.h"
#import "INCharacterCounter.h"
#import "INAttachmentContainer.h"

@interface INEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, INMoreButtonDelegate, INAttachmentContainerDelegate, INMarkdownTextViewDelegate>

@property (strong, nonatomic) INMarkdownTextView *markdownTextView;
@property (strong, nonatomic) INMoreButton *moreButton;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setup
{
    // Initialization.
    self.markdownTextView = [[INMarkdownTextView alloc]initWithFrame:IN_MARKDOWN_TEXT_VIEW_INIT_FRAME];
    self.markdownTextView.markdownDelegate = self;
    self.moreButton = [[INMoreButton alloc]initWithFrame:IN_MORE_BUTTON_INIT_FRAME_EDIT delegate:self];
    self.characterCounter = [[INCharacterCounter alloc]initWithFrame:IN_CHARACTER_COUNTER_INIT_FRAME];
    self.attachmentContainer = [[INAttachmentContainer alloc]initWithFrame:IN_ATTACHMENT_CONTAINER_INIT_FRAME_EDIT];
    self.attachmentContainer.delegate = self;
    
    // Subviews setup.
    [self.view addSubview:self.markdownTextView];
    [self.view addSubview:self.moreButton];
    [self.view addSubview:self.characterCounter];
    [self.view addSubview:self.attachmentContainer];
    
    // Setup / populate views with data.
    [self setupData];
}

- (void)setupData
{
    [self.markdownTextView setText:self.post.text];
    [self.attachmentContainer setAttachmentImage:[UIImage imageWithData:self.post.image] usingSpringWithDamping:NO];
    [self.characterCounter setText:[NSString stringWithFormat:@"%i", 240 - (int)self.markdownTextView.text.length]];
}

- (void)presentImagePicker
{
    //
}

- (IBAction)publishButtonSelected:(id)sender
{
    //
}

#pragma mark - Markdown Text View Delegate

- (void)markdownTextViewDidUpdateCharactersCount:(int)count
{
    self.characterCounter.text = [NSString stringWithFormat:@"%i", count];
}

@end
