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
#import "KTPostCVC.h"
#import "KTSearchResultsVC.h"

@interface KTViewController ()
- (IBAction)refreshButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UITextField *userSearchTextField;
@property (strong, nonatomic) IBOutlet UIView *postCVCContainerView;
@property (strong, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) KTPostCVC *postsCVC;
@property (strong, nonatomic) IBOutlet UIView *searchResultsContainerView;
@property (strong, nonatomic) KTSearchResultsVC *searchResultsVC;
@end

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataLoader = [KTDataLoader new];
    _dataLoader.slug = [NSString new];
    _dataLoader.captionHTML = [NSString new];
    _dataLoader.delegate = self;
    [_dataLoader makeSession];
    
    _userNameLabel.hidden = YES;
    _blogTitleLabel.hidden = YES;
    _refreshButton.hidden = YES;
    
    // call grab blog info IF the response is ok and you get a
    [_dataLoader grabBlogInfoForUser:@"staff"];
    
    [self createSearchReultsVC];
    
//    [_dataLoader grabBlogAvatarForUser:@"asd1341241"];
//    [_dataLoader getPostsForUser:@"asd1341241"];
    // call the above methods in response to delegate call from
    
    [self.view setNeedsDisplay];
    [self createCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hitDataLoaderBlogSearch) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)hitDataLoaderBlogSearch{
    [_dataLoader grabBlogInfoForUser:_userSearchTextField.text];
}

-(void)searchReturnedNoResults{
    
}

-(void)setSearchResultsVCBlogTitle:(NSString *)blogTitle userName:(NSString *)userName description:(NSString *)description{
    [_searchResultsVC.noResultsLabel setHidden:YES];
    [self unhideSearchResultsViews];
    _searchResultsVC.userName.text = userName;
    _searchResultsVC.blogTitleLabel.text = blogTitle;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _searchResultsVC.descriptionTextView.attributedText = attributedString;
}

-(void)createSearchReultsVC{
    _searchResultsVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"KTSearchResultsVC"];
    [_searchResultsVC.view setFrame:_searchResultsContainerView.frame];
    [self addChildViewController:_searchResultsVC];
    [_searchResultsContainerView addSubview:_searchResultsVC.view];
    [self hideSearchResultsViews];
}

-(void)hideSearchResultsViews{
    [_searchResultsVC.userName setHidden:YES];
    [_searchResultsVC.userAvatarImageView setHidden:YES];
    [_searchResultsVC.blogTitleLabel setHidden:YES];
    [_searchResultsVC.descriptionTextView setHidden:YES];
}

-(void)unhideSearchResultsViews{
    [_searchResultsVC.userName setHidden:NO];
    [_searchResultsVC.userAvatarImageView setHidden:NO];
    [_searchResultsVC.blogTitleLabel setHidden:NO];
    [_searchResultsVC.descriptionTextView setHidden:NO];
}
//\@property (strong, nonatomic) IBOutlet UILabel *userName;
//@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
//@property (strong, nonatomic) IBOutlet UILabel *blogTitleLabel;
//@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
//- (IBAction)viewThisFeedButtonPress:(id)sender;

-(void)populateSearchResultsVC{
    
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = .10;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _postsCVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"KTPostCVC"];
    [_postsCVC.collectionView setCollectionViewLayout:flowLayout];
    [_postsCVC.collectionView setDelegate:self];
    [_postsCVC.collectionView setPagingEnabled:NO];
    [_postsCVC.collectionView setUserInteractionEnabled:YES];
    [_postsCVC.collectionView setDataSource:_postsCVC];
    [_postsCVC.collectionView setBackgroundColor:[UIColor yellowColor]];
    [_postsCVC.view setBackgroundColor:[UIColor redColor]];
    [_postsCVC.view setFrame:CGRectMake(0, 0, _postCVCContainerView.frame.size.width, _postCVCContainerView.frame.size.height)];
    [self addChildViewController:_postsCVC];
    // set data for the collectionview
    [_postCVCContainerView addSubview:_postsCVC.view];
    [_postsCVC.collectionView reloadData];
}

//    collectionViewController.routesToDisplay = [NSMutableArray new];

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _postCVCContainerView.frame.size;
}

-(void)finishedDownloadingWithCaption:(NSString*)caption andSlug:(NSString*)slug{
    NSLog(@"finished downloading");
//    NSLog(@"*** dataloader slug: %@", slug);
//    NSLog(@"*** datalaoder caption: %@", caption);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[caption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        _tumblrAvatar.image = _dataLoader.downloadedImage;
        _blogTitleLabel.text = _dataLoader.blogtitle;
        _userNameLabel.text = _dataLoader.usernameToLoad;
//        _slugLabel.text = slug;
//        _caption.attributedText = attributedString;
//        _avatarImage.frame = CGRectMake(100, 400, 64, 64);
//        [_avatarImage setImage:_dataLoader.downloadedImage];
//        [self.view addSubview:_avatarImage];
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_userSearchTextField isFirstResponder]) {
        [_userSearchTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshButtonPressed:(id)sender {
}
@end
