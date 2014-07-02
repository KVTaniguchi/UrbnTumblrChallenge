//
//  KTViewController.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//
//Usage of cocoa pods and third party libraries is fine
//Enter a username or tumblr url to load a user's feed
//Display feed items for all posts
//Feed should be infinitely scrollable collection view supporting a way to refresh
//If the post originated from another user, I should be able to tap another users avatar/user to transition to that users feed using a custom navigation transition
//Full HTML rendering of posts (without web view)
//Client side persistence for using core data
//App should properly update when coming in and out of active states
//App should be resilient to loss of network connectivity where possible
//Unit tests are encouraged
//Use of animations are encouraged
//All code should be in Github



#import "KTViewController.h"


@interface KTViewController ()

@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    _dataLoader.slug = [NSString new];
    _dataLoader.captionHTML = [NSString new];
    _dataLoader.delegate = self;
    _avatarImage = [UIImageView new];
    [_dataLoader makeSession];
    [_dataLoader grabBlogInfoForUser:@"staff"];
    [_dataLoader grabBlogAvatarForUser:@"staff"];
    [_dataLoader getPostsForUser:@"staff"];
    [self.view setNeedsDisplay];
}

-(void)finishedDownloadingWithCaption:(NSString*)caption andSlug:(NSString*)slug{
    NSLog(@"finished downloading");
    NSLog(@"*** dataloader slug: %@", slug);
    NSLog(@"*** datalaoder caption: %@", caption);
    

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSLog(@"attr string: %@", attributedString);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _slugLabel.text = slug;
//        _caption.text = document.textContent;
        _caption.attributedText = attributedString;
        _avatarImage.frame = CGRectMake(100, 400, 64, 64);
        [_avatarImage setImage:_dataLoader.downloadedImage];
        [self.view addSubview:_avatarImage];
    });
}

//textView.attributedText=stringWithHTMLAttributes;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
