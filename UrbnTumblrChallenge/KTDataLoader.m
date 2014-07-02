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
#import <MMMarkdown/MMMarkdown.h>
//#import <HTMLReader/HTMLReader.h>

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
            NSLog(@"got data");
        }
//        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"**** returned : %@", jsonData);
    }];
    [dataTask resume];
}

-(void)grabBlogAvatarForUser:(NSString*)userName{
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/info?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        self.downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        NSLog(@"%@", self.downloadedImage.description);
    }];
    [downloadTask resume];
}

-(void)getPostsForUser:(NSString*)userName{
    // api.tumblr.com/v2/blog/{base-hostname}/posts[/type]?api_key={key}&[optional-params=]
    NSString *link = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/posts/?api_key=oRjHa869ZJYZAhypDvVx20gDcy0RDF6KS07OXC8VdCZMPNR7sG&reblog_info=true", userName];
    NSURL *url = [NSURL URLWithString:link];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self parseJSON:jsonData];
    }];
    [dataTask resume];
}

-(void)parseJSON:(NSDictionary*)json{
    NSLog(@"****************************");
    NSDictionary *response = [json objectForKey:@"response"];
    NSArray *posts = [response objectForKey:@"posts"];
    NSLog(@"^^^^^^^^ posts count is: %lu", (unsigned long)posts.count);
    NSDictionary *mostRecentPost = [posts objectAtIndex:0];
    self.captionHTML =  [NSString stringWithString:[mostRecentPost objectForKey:@"caption"]];
    NSLog(@"captionHTML: %@", self.captionHTML);
    self.slug = [NSString stringWithString:[mostRecentPost objectForKey:@"slug"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self delegate] finishedDownloadingWithCaption:self.captionHTML andSlug:self.slug];
    });
}



//NSString *htmlString = @"<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
//NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//textView.attributedText = attributedString;

//NSString *html = [NSString stringWithFormat:@"<html><body>%@</body><html>", userText];
//
//// build the path where you're going to save the HTML
//
//NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//NSString *filename = [docsFolder stringByAppendingPathComponent:@"sample.html"];
//
//// save the NSString that contains the HTML to a file
//
//NSError *error;
//[html writeToFile:filename atomically:NO encoding:NSUTF8StringEncoding error:&error];
//NSURL *htmlString = [[NSBundle mainBundle]
//                     URLForResource: @"helloworld" withExtension:@"html"];
//NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithFileURL:htmlString options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//
//// Instantiate UITextView object
//UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20,20,self.view.frame.size.width,self.view.frame.size.height)];
//
//textView.attributedText=stringWithHTMLAttributes;
//
//[self.view addSubview:textView];


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
}
@end
