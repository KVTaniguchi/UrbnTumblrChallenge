//
//  KTPostCVC.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTPostCVC.h"
#import "KTPostStore.h"
#import "KTDataLoader.h"

@interface KTPostCVC ()
@property (nonatomic,strong) NSNumber *numberOfItemsToShow;
@property (nonatomic,strong) KTDataLoader *dataLoader;
@end

@implementation KTPostCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    [_dataLoader makeSession];
    _dataLoader.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // TO DO: redo all post loading from core data

    KTPostCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    postCell.delegate = self;
    postCell.postImagesView.layer.shouldRasterize = YES;
    postCell.postImagesView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    Post *fetchedPost = [self.fetchedPostsForUser objectAtIndex:indexPath.row];
    
    if (fetchedPost.caption != nil) {
        NSString *caption = fetchedPost.caption;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;
    }
    if (fetchedPost.image != nil) {
        postCell.postImagesView.image = [UIImage imageWithData:fetchedPost.image];
        postCell.slugTextView.text = fetchedPost.slug;
    }
    if (fetchedPost.body != nil) {
        NSString *caption = fetchedPost.body;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;
    }
    if (fetchedPost.slug != nil) {
        postCell.slugTextView.text = fetchedPost.slug;
    }
    if (fetchedPost.rebloggerName != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.5 animations:^{
                [postCell.postImagesView setFrame:CGRectMake(0, 57, 165, 165)];
            } completion:^(BOOL finished) {
                [postCell.rebloggedLabel setHidden:NO];
                [postCell.rebloggerNameLabel setHidden:NO];
                [postCell.rebloggerAvatarImage setHidden:NO];
                NSString *reblogger = fetchedPost.rebloggerName;
                postCell.rebloggerNameLabel.text = reblogger;
                [_dataLoader grabReblogAvatarForUser:reblogger :^(BOOL completed) {
                    if (completed) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            postCell.rebloggerAvatarImage.image = _dataLoader.downloadedImage;
                        });
                    }
                }];
            }];
        });

    }else{
        [postCell.rebloggerNameLabel setHidden:YES];
        [postCell.rebloggedLabel setHidden:YES];
        [postCell.rebloggerAvatarImage setHidden:YES];
        [postCell.postImagesView setFrame:CGRectMake(58, 57, 165, 165)];
    }
    
    
//    if ([post objectForKey:@"caption"] != nil) {
//        NSString *caption = [NSString stringWithString:[post objectForKey:@"caption"]];
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        postCell.captionTextView.attributedText = attributedString;
//    }
//    else{
//        NSLog(@"handle no caption");
//    }
//    if ([post objectForKey:@"body"] != nil) {
//        NSString *body = [NSString stringWithString:[post objectForKey:@"body"]];
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[body dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        postCell.captionTextView.attributedText = attributedString;
//    }else if ([post objectForKey:@"caption"] == nil) {
//        NSLog(@"handle no body and no cpation");
//    }
//
//    if ([post objectForKey:@"slug"] != nil) {
//        postCell.slugTextView.text = [post objectForKey:@"slug"];
//    }
//    if ([post objectForKey:@"reblogged_from_name"] != nil) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:1.5 animations:^{
//                [postCell.postImagesView setFrame:CGRectMake(0, 57, 165, 165)];
//            } completion:^(BOOL finished) {
//                [postCell.rebloggedLabel setHidden:NO];
//                [postCell.rebloggerNameLabel setHidden:NO];
//                [postCell.rebloggerAvatarImage setHidden:NO];
//                NSString *reblogger = [post objectForKey:@"reblogged_from_name"];
//                postCell.rebloggerNameLabel.text = reblogger;
//                [_dataLoader grabReblogAvatarForUser:reblogger :^(BOOL completed) {
//                    if (completed) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            postCell.rebloggerAvatarImage.image = _dataLoader.downloadedImage;
//                        });
//                    }
//                }];
//            }];
//        });
//    }else{
//        [postCell.rebloggerNameLabel setHidden:YES];
//        [postCell.rebloggedLabel setHidden:YES];
//        [postCell.rebloggerAvatarImage setHidden:YES];
//        [postCell.postImagesView setFrame:CGRectMake(58, 57, 165, 165)];
//    }
    return postCell;
}



-(void)loadReblogger:(NSString *)rebloggerName{
    [[self delegate] rebloggerLoad:rebloggerName];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[KTPostStore sharedStore]allPosts] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
