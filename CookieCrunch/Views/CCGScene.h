//
//  GameScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class CCGLevel;
@class CCGSwap;

@interface CCGScene : SKScene

@property (strong, nonatomic) CCGLevel *level;

@property (copy, nonatomic) void (^swipeHandler)(CCGSwap *swap);

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;

- (void)animateSwap:(CCGSwap *)swap completion:(dispatch_block_t)completion;
- (void)animateInvalidSwap:(CCGSwap *)swap completion:(dispatch_block_t)completion;

- (void)animateMatchedCookies:(NSSet *)chains completion:(dispatch_block_t)completion;
- (void)animateFallingCookies:(NSArray *)columns completion:(dispatch_block_t)completion;
- (void)animateNewCookies:(NSArray *)columns completion:(dispatch_block_t)completion;

- (void)animateGameOver;
- (void)animateBeginGame;

- (void)removeAllCookieSprites;

@end
