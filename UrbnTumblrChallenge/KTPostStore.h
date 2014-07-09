//
//  KTPostStore.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
@import CoreData;

@interface KTPostStore : NSObject
{
    NSMutableArray *allPosts;
    NSManagedObjectModel *model;
}
+(KTPostStore*)sharedStore;
-(NSString*)itemArchivePath;
-(NSArray*)allPosts;
-(NSArray*)setPosts:(id)post withSequence:(NSInteger)sequence;
-(Post*)addNewPost;
-(void)clearAllPosts;
-(BOOL)saveChanges;
-(NSArray*)fetchAllPostsForUser:(NSString*)user;
-(void)deleteAllPostsForUser:(NSString*)user;
-(BOOL)storeHasPostsForUser:(NSString*)user;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end
