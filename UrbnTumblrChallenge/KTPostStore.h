//
//  KTPostStore.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/2/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPostStore : NSObject
{
    NSMutableArray *allPosts;
}

+(KTPostStore*)sharedStore;
-(NSArray*)allPosts;
-(NSArray*)setPosts:(NSArray*)posts;
-(void)clearAllPosts;
@end
