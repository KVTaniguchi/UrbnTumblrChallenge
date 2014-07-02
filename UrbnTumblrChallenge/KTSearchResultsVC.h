//
//  KTSearchResultsVC.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTSearchResultsVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
- (IBAction)viewThisFeedButtonPress:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *noResultsLabel;

@end
