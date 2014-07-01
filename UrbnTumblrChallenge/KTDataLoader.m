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
    // api.tumblr.com/v2/blog/{base-hostname}/info?api_key={key}
    
    // http://api.tumblr.com/v2/blog/scipsy.tumblr.com/info
    // http://api.tumblr.com/v2/blog/good.tumblr.com/info
    
    
    // parse the textfield entry for the user name OR the tumblr url
    // easiest to just strip the tumblr.com off and feed in the blog name
    
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", textFieldEntry];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSLog(@"data");
        }
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"**** returned : %@", jsonData);
    }];
    [dataTask resume];
}

-(void)grabBlogAvatarForUser:(NSString*)userName{
    // http://api.tumblr.com/v2/blog/david.tumblr.com/avatar
    
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        NSLog(@"%@", self.downloadedImage.description);
        [[self delegate] finishedDownloading];
    }];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
}

// 1
//NSURLSessionDownloadTask *getImageTask =
//[session downloadTaskWithURL:[NSURL URLWithString:imageUrl]
// 
//           completionHandler:^(NSURL *location,
//                               NSURLResponse *response,
//                               NSError *error) {
//               // 2
//               UIImage *downloadedImage =
//               [UIImage imageWithData:
//                [NSData dataWithContentsOfURL:location]];
//               //3
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   // do stuff with image
//                   _imageWithBlock.image = downloadedImage;
//               });
//           }];

@end
