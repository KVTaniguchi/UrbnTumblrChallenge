//
//  KTDataLoader.m
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

// OAuth Consumer Key:

#import "KTDataLoader.h"
#import "KTPostStore.h"

@interface KTDataLoader ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *config;

@end

@implementation KTDataLoader

-(void)makeSession{
    self.config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:self.config];
    self.downloadedImage = [UIImage new];
}

-(void)grabBlogInfoForUser:(NSString*)textFieldEntry{
    NSLog(@"called");
    // http://api.tumblr.com/v2/blog/scipsy.tumblr.com/info
    // http://api.tumblr.com/v2/blog/good.tumblr.com/info
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", textFieldEntry];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response) {
            NSHTTPURLResponse *status = (NSHTTPURLResponse*)response;
            if (status.statusCode != 200) {
                [[self delegate] searchReturnedNoResults];
            }else if (status.statusCode == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSDictionary *response = [jsonData objectForKey:@"response"];
                    NSDictionary *blog = [response objectForKey:@"blog"];
                    self.blogtitle = [blog objectForKey:@"title"];
                    self.usernameToLoad = [blog objectForKey:@"name"];
                    NSString *blogDescription = [NSString stringWithString:[blog objectForKey:@"description"]];
                    [[self delegate] setSearchResultsVCBlogTitle:self.blogtitle userName:self.usernameToLoad description:blogDescription];
                });
            }
        }else{
            NSLog(@"no response with response %@", response.description);
        }
    }];
    [dataTask resume];
}

-(void)grabBlogAvatarForUser:(NSString*)userName{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        [[self delegate] setAvatarImage];
    }];
    [downloadTask resume];
}

-(void)getPostsForUser:(NSString*)userName{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/posts/?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG&reblog_info=true", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self parseJSON:jsonData];
    }];
    [dataTask resume];
}

-(void)parseJSON:(NSDictionary*)json{
    NSDictionary *response = [json objectForKey:@"response"];
    _posts = [response objectForKey:@"posts"];
    for (int x = 0; x < _posts.count; x++) {
        [[KTPostStore sharedStore]setPosts:[_posts objectAtIndex:x]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self delegate] finishedDownloadingPosts];
    });
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
}
@end
