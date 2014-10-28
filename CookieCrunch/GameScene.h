//
//  GameScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Level;

@interface GameScene : SKScene

@property (strong, nonatomic) Level *level;

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;

@end
