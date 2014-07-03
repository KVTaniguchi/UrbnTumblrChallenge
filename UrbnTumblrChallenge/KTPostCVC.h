//
//  KTPostCVC.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDataLoader.h"
#import "KTPostCell.h"

@protocol KTPostCVCDelegate <NSObject>

@optional
-(void)rebloggerLoad:(NSString*)rebloggerName;
@end

@interface KTPostCVC : UICollectionViewController <KTDataloaderDelegate, KTPostCellDelegate>
@property (nonatomic,strong) id<KTPostCVCDelegate>delegate;
@property (nonatomic,strong) NSNumber *numberOfPostsToShow;
@end
