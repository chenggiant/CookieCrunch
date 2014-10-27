//
//  Level.h
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "Cookie.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject

- (NSSet *)shuffle;
- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;

@end
