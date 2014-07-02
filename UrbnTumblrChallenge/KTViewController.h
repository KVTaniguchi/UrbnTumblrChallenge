//
//  KTViewController.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"

@interface KTViewController : UIViewController <KTDataloaderDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *tumblrAvatar;
@property KTDataLoader *dataLoader;


@end
