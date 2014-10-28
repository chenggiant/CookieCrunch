//
//  Level.h
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "CCGCookie.h"
#import "CCGTile.h"
#import "CCGSwap.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface CCGLevel : NSObject

- (NSSet *)shuffle;
- (CCGCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;

- (instancetype)initWithFile:(NSString *)filename;
- (CCGTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)performSwap:(CCGSwap *)swap;
- (BOOL)isPossibleSwap:(CCGSwap *)swap;


@end
