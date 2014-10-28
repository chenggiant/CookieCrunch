//
//  GameScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Level;
@class Swap;

@interface GameScene : SKScene

@property (strong, nonatomic) Level *level;

@property (copy, nonatomic) void (^swipeHandler)(Swap *swap);

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;

- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion;


@end
