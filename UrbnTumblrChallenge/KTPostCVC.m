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
    KTPostCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
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
