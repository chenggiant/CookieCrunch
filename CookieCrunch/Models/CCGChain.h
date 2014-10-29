//
//  CCGChain.h
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCGCookie;

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface CCGChain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;

@property (assign, nonatomic) ChainType chainType;

@property (assign, nonatomic) NSUInteger score;


- (void)addCookie:(CCGCookie *)cookie;

@end
