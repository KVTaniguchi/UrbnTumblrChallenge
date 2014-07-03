//
//  KTPostCVC.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTPostCVC.h"
#import "KTPostCell.h"
#import "KTPostStore.h"

@interface KTPostCVC ()
@property (nonatomic,strong) NSNumber *numberOfItemsToShow;
@end

@implementation KTPostCVC


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setNumberOfCVCItems:(NSNumber *)number{
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *post = [[[KTPostStore sharedStore]allPosts]objectAtIndex:indexPath.row];
    NSLog(@"post: %@", post);
    KTPostCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    if ([post objectForKey:@"caption"] != nil) {
        NSString *caption = [NSString stringWithString:[post objectForKey:@"caption"]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        postCell.captionTextView.attributedText = attributedString;
    }
    
    if ([post objectForKey:@"photos"] != nil) {
        NSArray *photoContainer = [post objectForKey:@"photos"];
        NSDictionary *photoInfo = [photoContainer objectAtIndex:0];
        NSArray *altSizes = [photoInfo objectForKey:@"alt_sizes"];
        NSDictionary *photo = [altSizes lastObject];
        NSURL *photoURL = [NSURL URLWithString:[photo objectForKey:@"url"]];
        postCell.postImagesView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
    }
    
    if ([post objectForKey:@"slug"] != nil) {
        postCell.slugTextView.text = [post objectForKey:@"slug"];
    }
    if ([post objectForKey:@"reblogged"] != nil) {
        
    }
    
    
    return postCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"post store count: %lu", (unsigned long)[[[KTPostStore sharedStore]allPosts] count]);
    return [[[KTPostStore sharedStore]allPosts] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


@end
