//
//  CCGChain.m
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "CCGChain.h"

@implementation CCGChain {
    NSMutableArray *_cookies;
}


- (void)addCookie:(CCGCookie *)cookie {
    if (_cookies == nil) {
        _cookies = [NSMutableArray array];
    }
    [_cookies addObject:cookie];
}


- (NSArray *)cookies {
    return _cookies;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld cookies:%@", (long)self.chainType, self.cookies];
}



@end
