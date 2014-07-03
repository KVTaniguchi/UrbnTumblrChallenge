//
//  KTViewController.m
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

//DONE  Enter a username or tumblr url to load a user's feed
//DONE  Display feed items for all posts
//TODO INFINITE SCROLLING: Feed should be infinitely scrollable collection view supporting a way to refresh DONE
//DONE If the post originated from another user, I should be able to tap another users avatar/user to transition to that users feed using a custom navigation transition
//DONE Full HTML rendering of posts (without web view)
//Client side persistence for using core data
//App should properly update when coming in and out of active states
//App should be resilient to loss of network connectivity where possible
//Unit tests are encouraged

#import "KTViewController.h"
#import "KTPostCVC.h"
#import "KTPostStore.h"

@interface KTViewController (){
    KTPostCVC *postsCVC;
}
- (IBAction)refreshButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UITextField *userSearchTextField;
@property (strong, nonatomic) IBOutlet UIView *postCVCContainerView;
@property (strong, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIView *searchResultsContainerView;
@property (strong, nonatomic) KTSearchResultsVC *searchResultsVC;
@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    _dataLoader.delegate = self;
    [_dataLoader makeSession];
    _userSearchTextField.delegate = self;
    [_postCVCContainerView setHidden:YES];
    [self hideTargetLabels];
    [self createSearchReultsVC];
    [self.view addSubview:_searchResultsContainerView];
    [self createCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hitDataLoaderBlogSearch) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)hitDataLoaderBlogSearch{
    [self hideTargetLabels];
    [[KTPostStore sharedStore]clearAllPosts];
    [postsCVC.collectionView reloadData];
    [_searchResultsContainerView setAlpha:1.0f];
    [_searchResultsContainerView setHidden:NO];
    [_dataLoader grabBlogInfoForUser:_userSearchTextField.text];
    [_postCVCContainerView setAlpha:0.0];
}

-(void)searchReturnedNoResults{
    [self hideSearchResultsViews];
}

-(void)setSearchResultsVCBlogTitle:(NSString *)blogTitle userName:(NSString *)userName description:(NSString *)description{
    [_dataLoader grabBlogAvatarForUser:userName];
    [_searchResultsVC.noResultsLabel setHidden:YES];
    [self unhideSearchResultsViews];
    _searchResultsVC.userName.text = userName;
    _searchResultsVC.blogTitleLabel.text = blogTitle;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _searchResultsVC.descriptionTextView.attributedText = attributedString;
}

-(void)setAvatarImage{
    NSLog(@"image setter called");
    dispatch_async(dispatch_get_main_queue(), ^{
        _searchResultsVC.userAvatarImageView.image = _dataLoader.downloadedImage;
    });
}

-(void)createSearchReultsVC{
    _searchResultsVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"KTSearchResultsVC"];
    _searchResultsVC.delegate = self;
    [_searchResultsVC.view setFrame:CGRectMake(0, 0, _searchResultsContainerView.frame.size.width, _searchResultsContainerView.frame.size.height)];
    [self addChildViewController:_searchResultsVC];
    [_searchResultsContainerView addSubview:_searchResultsVC.view];
    [self hideSearchResultsViews];
}

-(void)hideTargetLabels{
    _tumblrAvatar.hidden =YES;
    _userNameLabel.hidden = YES;
    _blogTitleLabel.hidden = YES;
    _refreshButton.hidden = YES;
}

-(void)showTargetLabels{
    _tumblrAvatar.hidden = NO;
    _userNameLabel.hidden = NO;
    _blogTitleLabel.hidden = NO;
    _refreshButton.hidden = NO;
}

-(void)hideSearchResultsViews{
    [_searchResultsVC.viewThisFeedButton setHidden:YES];
    [_searchResultsVC.noResultsLabel setHidden:NO];
    [_searchResultsVC.userName setHidden:YES];
    [_searchResultsVC.userAvatarImageView setHidden:YES];
    [_searchResultsVC.blogTitleLabel setHidden:YES];
    [_searchResultsVC.descriptionTextView setHidden:YES];
}

-(void)unhideSearchResultsViews{
    [_searchResultsVC.viewThisFeedButton setHidden:NO];
    [_searchResultsVC.myIntroLabel setHidden:YES];
    [_searchResultsVC.instructionsTextView setHidden:YES];
    [_searchResultsVC.noResultsLabel setHidden:YES];
    [_searchResultsVC.userName setHidden:NO];
    [_searchResultsVC.userAvatarImageView setHidden:NO];
    [_searchResultsVC.blogTitleLabel setHidden:NO];
    [_searchResultsVC.descriptionTextView setHidden:NO];
}

-(void)hideCollectionView{
    [_postCVCContainerView setHidden:YES];
}

-(void)unhideCollectionView{
    [_postCVCContainerView setHidden:NO];
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = .10;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    postsCVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"KTPostCVC"];
    [postsCVC.collectionView setCollectionViewLayout:flowLayout];
    [postsCVC setDelegate:self];
    [postsCVC.collectionView setDelegate:self];
    [postsCVC.collectionView setPagingEnabled:NO];
    [postsCVC.collectionView setUserInteractionEnabled:YES];
    [postsCVC.collectionView setDataSource:postsCVC];
    [postsCVC.collectionView setBackgroundColor:[UIColor yellowColor]];
    [postsCVC.view setBackgroundColor:[UIColor redColor]];
    postsCVC.numberOfPostsToShow = [NSNumber numberWithInt:1];
    [postsCVC.view setFrame:CGRectMake(0, 0, _postCVCContainerView.frame.size.width, _postCVCContainerView.frame.size.height)];
    [self addChildViewController:postsCVC];
    [_postCVCContainerView addSubview:postsCVC.view];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _postCVCContainerView.frame.size;
}

-(void)finishedDownloadingPosts{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTargetLabelValues];
        NSLog(@"dataloader posts count: %lu", (unsigned long)_dataLoader.posts.count);
        [postsCVC.collectionView reloadData];
    });
}

-(void)setTargetLabelValues{
    _tumblrAvatar.image = _dataLoader.downloadedImage;
    _blogTitleLabel.text = _dataLoader.blogtitle;
    _userNameLabel.text = _dataLoader.usernameToLoad;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_userSearchTextField isFirstResponder]) {
        [_userSearchTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pushToCollectionView{
    if ([_userSearchTextField isFirstResponder]) {
        [_userSearchTextField resignFirstResponder];
    }
    [UIView animateWithDuration:0.5f animations:^{
        [_searchResultsContainerView setAlpha:0.0f];
        [_searchResultsContainerView setHidden:YES];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:.5 animations:^{
                [_postCVCContainerView setAlpha:1.0];
                [self showTargetLabels];
            }];
            [self unhideCollectionView];
            [_dataLoader getPostsForUser:_dataLoader.usernameToLoad];
            [postsCVC.collectionView reloadData];
        }
    }];
}

-(void)rebloggerLoad:(NSString *)rebloggerName{
    NSLog(@"from view controller: %@", rebloggerName);
    _userSearchTextField.text = rebloggerName;
    // display custom view with animation simulating a traditional nav controller push
    UIView *fakeTransition = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, 568)];
    fakeTransition.backgroundColor = [UIColor colorWithRed:74.0f/255.0f green:229.0f/255.0f blue:74.0f/255.0f alpha:1.0];
    [self.view addSubview:fakeTransition];
    [UIView animateWithDuration:1.0 animations:^{
        fakeTransition.frame = CGRectMake(0, 0, 320, 568);
    } completion:^(BOOL finished) {
        [_dataLoader grabBlogInfoForUser:rebloggerName];
        [[KTPostStore sharedStore]clearAllPosts];
        [_dataLoader getPostsForUser:rebloggerName];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (finished) {
                [UIView animateWithDuration:1.0 animations:^{
                    fakeTransition.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [fakeTransition removeFromSuperview];
                    }
                }];
            }
        });
        
    }];
    
}

- (IBAction)refreshButtonPressed:(id)sender {
    [[KTPostStore sharedStore]clearAllPosts];
    [_dataLoader getPostsForUser:_dataLoader.usernameToLoad];
    [postsCVC.collectionView reloadData];
}
@end
