//
//  Level.m
//  CookieCrunch
//
//  Created by Chi on 28/10/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "CCGLevel.h"


@interface CCGLevel()
@property (strong, nonatomic) NSSet *possibleSwaps;
@property (assign, nonatomic) NSUInteger comboMultiplier;

@end


@implementation CCGLevel {
    CCGCookie *_cookies[NumColumns][NumRows];
    CCGTile *_tiles[NumColumns][NumRows];
}


- (instancetype)initWithFile:(NSString *)filename {
    self = [super init];
    if (self != nil) {
        NSDictionary *dictionary = [self loadJSON:filename];
        
        // Loop through the rows
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            
            // Loop through the columns in the current row
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                // so we need to read this file upside down.
                NSInteger tileRow = NumRows - row - 1;
                
                // If the value is 1, create a tile object.
                if ([value integerValue] == 1) {
                    _tiles[column][tileRow] = [[CCGTile alloc] init];
                }
            }];
        }];
        self.targetScore = [dictionary[@"targetScore"] unsignedIntegerValue];
        self.maximumMoves = [dictionary[@"moves"] unsignedIntegerValue];
    }

    return self;
}

- (CCGTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _tiles[column][row];
}

- (NSDictionary *)loadJSON:(NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file: %@", filename);
        return nil;
    }
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return dictionary;
}

- (CCGCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

- (NSSet *)shuffle {
    NSSet *set;
    do {
        set = [self createInitialCookies];
        [self detectPossibleSwaps];
        NSLog(@"possible swaps: %@", self.possibleSwaps);
    }
    while ([self.possibleSwaps count] == 0);
    return set;
}


- (void)detectPossibleSwaps {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            CCGCookie *cookie = _cookies[column][row];
            if (cookie != nil) {
                if (column < NumColumns - 1) {
                    CCGCookie *other = _cookies[column + 1][row];
                    if (other != nil) {
                        // swap them
                        _cookies[column][row] = other;
                        _cookies[column + 1][row] = cookie;
                        
                        // check if the cookie is part of a chain
                        if ([self hasChainAtColumn:column + 1 row:row] || [self hasChainAtColumn:column row:row]) {
                            CCGSwap *swap = [[CCGSwap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        
                        // swap them back
                        _cookies[column][row] = cookie;
                        _cookies[column + 1][row] = other;
                    }
                }
                
                if (row < NumRows - 1) {
                    CCGCookie *other = _cookies[column][row + 1];
                    if (other != nil) {
                        // Swap them
                        _cookies[column][row] = other;
                        _cookies[column][row + 1] = cookie;
                        
                        if ([self hasChainAtColumn:column row:row + 1] ||
                            [self hasChainAtColumn:column row:row]) {
                            
                            CCGSwap *swap = [[CCGSwap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        
                        _cookies[column][row] = cookie;
                        _cookies[column][row + 1] = other;
                    }
                }
            }
        }
    }
    
    self.possibleSwaps = set;
}


- (BOOL)isPossibleSwap:(CCGSwap *)swap {
    return [self.possibleSwaps containsObject:swap];
}


- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
    NSUInteger cookieType = _cookies[column][row].cookieType;
    
    NSUInteger horzLength = 1;
    for (NSInteger i = column - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, horzLength++) ;
    for (NSInteger i = column + 1; i < NumColumns && _cookies[i][row].cookieType == cookieType; i++, horzLength++) ;
    if (horzLength >= 3) return YES;
    
    NSUInteger vertLength = 1;
    for (NSInteger i = row - 1; i >= 0 && _cookies[column][i].cookieType == cookieType; i--, vertLength++) ;
    for (NSInteger i = row + 1; i < NumRows && _cookies[column][i].cookieType == cookieType; i++, vertLength++) ;
    return (vertLength >= 3);
}




- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    // 1
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            if (_tiles[column][row] != nil) {

                // 2
                NSUInteger cookieType;
                do {
                    cookieType = arc4random_uniform(NumCookieTypes) + 1;
                }
                while ((column >= 2 &&
                        _cookies[column - 1][row].cookieType == cookieType &&
                        _cookies[column - 2][row].cookieType == cookieType)
                       ||
                       (row >= 2 &&
                        _cookies[column][row - 1].cookieType == cookieType &&
                        _cookies[column][row - 2].cookieType == cookieType));
                
                // 3
                CCGCookie *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
            
                // 4
                [set addObject:cookie];
            }
        }
    }
    return set;
}

- (CCGCookie *)createCookieAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType {
    CCGCookie *cookie = [[CCGCookie alloc] init];
    cookie.cookieType = cookieType;
    cookie.column = column;
    cookie.row = row;
    _cookies[column][row] = cookie;
    return cookie;
}

- (void)performSwap:(CCGSwap *)swap {
    NSInteger columnA = swap.cookieA.column;
    NSInteger rowA = swap.cookieA.row;
    NSInteger columnB = swap.cookieB.column;
    NSInteger rowB = swap.cookieB.row;
    
    _cookies[columnA][rowA] = swap.cookieB;
    swap.cookieB.column = columnA;
    swap.cookieB.row = rowA;
    
    _cookies[columnB][rowB] = swap.cookieA;
    swap.cookieA.column = columnB;
    swap.cookieA.row = rowB;
}


- (NSSet *)detectHorizontalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns - 2; ) {
            if (_cookies[column][row] != nil) {
                NSUInteger matchType = _cookies[column][row].cookieType;
                
                if (_cookies[column + 1][row].cookieType == matchType && _cookies[column + 2][row].cookieType == matchType) {
                    CCGChain *chain = [[CCGChain alloc] init];
                    chain.chainType = ChainTypeHorizontal;
                    while (column < NumColumns && _cookies[column][row].cookieType == matchType) {
                        [chain addCookie:_cookies[column][row]];
                        column++;
                    }
                    [set addObject:chain];
                    continue;
                }
            }
            column++;
        }
    }
    return set;
}

- (NSSet *)detectVerticalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        for (NSInteger row = 0; row < NumRows - 2; ) {
            if (_cookies[column][row] != nil) {
                NSUInteger matchType = _cookies[column][row].cookieType;

                if (_cookies[column][row + 1].cookieType == matchType && _cookies[column][row + 2].cookieType == matchType) {
                    CCGChain *chain = [[CCGChain alloc] init];
                    chain.chainType = ChainTypeVertical;
                    
                    while (row < NumRows && _cookies[column][row].cookieType == matchType) {
                        [chain addCookie:_cookies[column][row]];
                        row++;
                    }
                [set addObject:chain];
                continue;
                }
            }
            row++;
        }
    }
    return set;
}

- (NSSet *)removeMatches {
    NSSet *horizontalChains = [self detectHorizontalMatches];
    NSSet *verticalChains = [self detectVerticalMatches];
    
    [self removeCookies:horizontalChains];
    [self removeCookies:verticalChains];
    
    [self calculateScores:horizontalChains];
    [self calculateScores:verticalChains];
    
    return [horizontalChains setByAddingObjectsFromSet:verticalChains];
}

- (void)removeCookies:(NSSet *)chains {
    for (CCGChain *chain in chains) {
        for (CCGCookie *cookie in chain.cookies) {
            _cookies[cookie.column][cookie.row] = nil;
        }
    }
}

- (NSArray *)fillHoles {
    NSMutableArray *columns = [NSMutableArray array];
    
    // 1
    for (NSInteger column = 0; column < NumColumns; column++) {
        
        NSMutableArray *array;
        for (NSInteger row = 0; row < NumRows; row++) {
            
            // 2
            if (_tiles[column][row] != nil && _cookies[column][row] == nil) {
                
                // 3
                for (NSInteger lookup = row + 1; lookup < NumRows; lookup++) {
                    CCGCookie *cookie = _cookies[column][lookup];
                    if (cookie != nil) {
                        // 4
                        _cookies[column][lookup] = nil;
                        _cookies[column][row] = cookie;
                        cookie.row = row;
                        
                        // 5
                        if (array == nil) {
                            array = [NSMutableArray array];
                            [columns addObject:array];
                        }
                        [array addObject:cookie];
                        
                        // 6
                        break;
                    }
                }
            }
        }
    }
    return columns;
}

- (NSArray *)topUpCookies {
    NSMutableArray *columns = [NSMutableArray array];
    
    NSUInteger cookieType = 0;
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        
        NSMutableArray *array;
        
        // 1
        for (NSInteger row = NumRows - 1; row >= 0 && _cookies[column][row] == nil; row--) {
            
            // 2
            if (_tiles[column][row] != nil) {
                
                // 3
                NSUInteger newCookieType;
                do {
                    newCookieType = arc4random_uniform(NumCookieTypes) + 1;
                } while (newCookieType == cookieType);
                cookieType = newCookieType;
                
                // 4
                CCGCookie *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
                
                // 5
                if (array == nil) {
                    array = [NSMutableArray array];
                    [columns addObject:array];
                }
                [array addObject:cookie];
            }
        }
    }
    return columns;
}

- (void)calculateScores:(NSSet *)chains {
    for (CCGChain *chain in chains) {
        chain.score = 60 * ([chain.cookies count] - 2) * self.comboMultiplier;
        self.comboMultiplier++;
    }
}

- (void)resetComboMultiplier {
    self.comboMultiplier = 1;
}



@end
