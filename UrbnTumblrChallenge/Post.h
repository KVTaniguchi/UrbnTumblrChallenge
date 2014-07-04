//
//  Post.h
//  UrbnTumblrChallenge
//
//  Created by Kevin Taniguchi on 7/4/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * rebloggerName;
@property (nonatomic, retain) NSString * slug;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSManagedObject *user;

@end
