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

// 1 type in username into tumblr api to get a response
// 2 parse the text entry to add it to .tumblr.com



#import "KTViewController.h"

@interface KTViewController ()
@property KTDataLoader *dataLoader;
@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dataLoader = [KTDataLoader new];
    self.avatarImage = [UIImageView new];
    [self.dataLoader makeSession];
    [self.dataLoader grabBlogInfoForUser:@"dcastilaw32"];
    [self.dataLoader grabBlogAvatarForUser:@"dcastilaw32"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dataloaderimage : %@", self.dataLoader.downloadedImage.debugDescription);
            self.avatarImage.frame = CGRectMake(10, 300, 64, 64);
            [self.avatarImage setImage:self.dataLoader.downloadedImage];
            [self.view addSubview:self.avatarImage];
            
        });
    });
    [self.view setNeedsDisplay];
}

-(void)finishedDownloading{
    NSLog(@"finished downloading");
    [self.tumblrAvatar setImage:self.dataLoader.downloadedImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
