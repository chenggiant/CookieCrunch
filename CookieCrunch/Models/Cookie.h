//
//  Cookie.h
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

@import SpriteKit;

static const NSUInteger NumCookieTypes = 6;

@interface Cookie : NSObject

@property (assign, atomic) NSInteger row;
@property (assign, atomic) NSInteger column;
@property (assign, nonatomic) NSUInteger cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;

@end
