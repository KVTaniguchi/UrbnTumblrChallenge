//
//  KTDataLoader.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 6/30/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTDataloaderDelegate <NSObject>
-(void)finishedDownloadingWithCaption:(NSString*)caption andSlug:(NSString*)slug;
@end

@interface KTDataLoader : NSObject <NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate>
-(void)grabBlogInfoForUser:(NSString*)textFieldEntry;
-(void)grabBlogAvatarForUser:(NSString*)userName;
-(void)makeSession;
-(void)getPostsForUser:(NSString*)userName;
@property (nonatomic,weak) id<KTDataloaderDelegate>delegate;
@property (nonatomic, strong) UIImage *downloadedImage;
@property (nonatomic,strong) NSString *usernameToLoad;
@property (nonatomic,strong) NSString *slug;
@property (nonatomic,strong) NSString *captionHTML;
@end
