//
//  GameViewController.m
//  CookieCrunch
//
//  Created by Chi on 27/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Level.h"


@interface GameViewController ()

@property (strong, nonatomic) Level *level;
@property (strong, nonatomic) GameScene *scene;

@end


@implementation GameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    // Create and configure the scene.
    self.scene = [GameScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the level.
    self.level = [[Level alloc] init];
    self.scene.level = self.level;
    
    // Present the scene.
    [skView presentScene:self.scene];
    
    // Let's start the game!
    [self beginGame];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)beginGame {
    [self shuffle];
}

- (void)shuffle {
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
}


@end
