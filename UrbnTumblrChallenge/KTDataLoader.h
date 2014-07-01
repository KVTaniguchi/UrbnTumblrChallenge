//
//  KTDataLoader.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTDataloaderDelegate <NSObject>
-(void)finishedDownloading;
@end

@interface KTDataLoader : NSObject <NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate>
-(void)grabBlogInfoForUser:(NSString*)textFieldEntry;
-(void)grabBlogAvatarForUser:(NSString*)userName;
-(void)makeSession;
@property (nonatomic,weak) id<KTDataloaderDelegate>delegate;
@property (nonatomic, strong) UIImage *downloadedImage;
@property (nonatomic,strong) NSString *usernameToLoad;
@end
