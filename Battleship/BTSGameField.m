//
//  BTSGameField.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/18/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSGameField.h"

@implementation BTSFieldPoint

- (instancetype)initWithXPos:(NSInteger)x YPos:(NSInteger)y value:(BTSFieldPointValue)value {
    self = [super init];
    if (!self) return nil;
    
    _x = x;
    _y = y;
    _value = value;
    
    return self;
}

@end


@interface BTSGameField()
@property (nonatomic, strong) NSMutableDictionary *gameFieldDictionary;
@property (nonatomic, strong) NSMutableArray *shipsPoints;
@property (nonatomic, strong) NSMutableArray *tappedShipPoints;
@property (nonatomic, strong) NSMutableArray *emptyPoints;
@end

@implementation BTSGameField

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.gameFieldDictionary = [NSMutableDictionary new];
    self.shipsPoints = [NSMutableArray new];
    self.tappedShipPoints = [NSMutableArray new];
    self.emptyPoints = [NSMutableArray new];
    
    return self;
}
- (BTSFieldPointValue)valueForPoint:(BTSFieldPoint*)point {
    NSString *key = [NSString stringWithFormat:@"%ld%ld", point.x, point.y];
    if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
        BTSFieldPoint *p = self.gameFieldDictionary[key];
        return p.value;
    }
    return BTSFieldPointValue_Empty;
}
- (void)setValue:(BTSFieldPointValue)value forPointWithX:(NSInteger)x Y:(NSInteger)y {
    NSString *key = [NSString stringWithFormat:@"%ld%ld", x, y];
    BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:x YPos:y value:value];
    self.gameFieldDictionary[key] = point;
    
    if (value == BTSFieldPointValue_Empty) {
        [self.emptyPoints addObject:point];
    }
    else if (value == BTSFieldPointValue_TappedShip) {
        [self.tappedShipPoints addObject:point];
    }
}

#pragma mark - GameField Generation

static const NSInteger kMaxX = 9;
static const NSInteger kMaxY = 9;

- (void)generate {
    for (int j=1; j<5; j++) {
        
        int maxDeep = 5-j;
        for (int i=0; i<j; i++) {
            
            NSInteger x1;
            NSInteger y1;

            BTSFieldPoint *point;
            
            NSArray *arr = nil;
            while (![self possibleAddShipAtPointX:x1 posintY:y1] || arr.count<maxDeep) {
                x1 = arc4random()%kMaxX;
                y1 = arc4random()%kMaxY;
                
                point = [[BTSFieldPoint alloc] initWithXPos:x1 YPos:y1 value:BTSFieldPointValue_Ship];
                if (maxDeep==1) {
                    arr = @[point];
                }
                else {
                    arr = [self getPossiblePointForArray:@[point] deep:1 maxDeep:maxDeep];
                }
            }
            for (BTSFieldPoint *p in arr) {
                BTSFieldPoint *ship = [self addShipPointAtXPos:p.x YPos:p.y];
                [self.shipsPoints addObject:ship];
            }
            
            [self addEnvironmentForPoints:arr];
        }
    }
}

#pragma mark helpers methods

- (NSArray*)getPossiblePointForArray:(NSArray*)arrWithAddedPoints deep:(int)deep maxDeep:(const int)maxDeep {
    NSArray* (^randomIndexesWithRange)(NSRange) = ^(NSRange range) {
        NSMutableArray *arr = [NSMutableArray new];
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSInteger i=range.location; i<range.location+range.length; i++) {
            [tempArr addObject:[NSNumber numberWithInteger:i]];
        }
        for (NSInteger i=range.location; i<(range.location+range.length); i++) {
            NSInteger randomIndex = arc4random()%tempArr.count;
            [arr addObject:tempArr[randomIndex]];
            [tempArr removeObjectAtIndex:randomIndex];
        }
        return [arr copy];
    };
    
    deep++;
    
    BTSFieldPoint *prevPoint = arrWithAddedPoints.lastObject;
    NSArray *arr = [self possibleNextPointsForPoint:prevPoint exceptPoints:arrWithAddedPoints];

    if (arr.count>0) {
        NSArray *indexes = randomIndexesWithRange(NSMakeRange(0, arr.count));
        for (int i=0; i<arr.count; i++) {
            BTSFieldPoint *newPoint = arr[[indexes[i] integerValue]];
            
            NSMutableArray *newExceptions = [NSMutableArray arrayWithArray:arrWithAddedPoints];
            [newExceptions addObject:newPoint];
            
            if (deep<maxDeep) {
                NSArray* nextPoints = [self getPossiblePointForArray:newExceptions deep:deep maxDeep:maxDeep];//getPossiblePoint(newExceptions, deep, maxDeep);
                if (nextPoints.count>0) {
                    if (nextPoints.count == maxDeep) {
                        return nextPoints;
                    }
                    else {
                        [newExceptions addObject:nextPoints.firstObject];
                        return [newExceptions copy];
                    }
                }
            }
            else {
                return [newExceptions copy];
            }
        }
    }
    
    return nil;
}
- (NSArray*)possibleNextPointsForPoint:(BTSFieldPoint*)p exceptPoints:(NSArray*)arrOfExceptions {
    NSMutableArray *arr = [NSMutableArray new];
    
    NSInteger x1 = p.x;
    NSInteger y1 = p.y;
    
    __weak NSArray *helperArr = arrOfExceptions;
    BOOL (^isException)(NSInteger, NSInteger) = ^BOOL(NSInteger x2, NSInteger y2) {
        for (BTSFieldPoint *p in helperArr) {
            if (p.x==x2 && p.y==y2) {
                return YES;
            }
        }
        return NO;
    };
    
    NSInteger x2 = x1+1;
    NSInteger y2 = y1;
    if ([self possibleAddShipAtPointX:x2 posintY:y2] && !isException(x2, y2)) {
        [arr addObject:[[BTSFieldPoint alloc] initWithXPos:x2 YPos:y2 value:BTSFieldPointValue_Ship]];
    }
    
    x2 = x1;
    y2 = y1+1;
    if ([self possibleAddShipAtPointX:x2 posintY:y2] && !isException(x2, y2)) {
        [arr addObject:[[BTSFieldPoint alloc] initWithXPos:x2 YPos:y2 value:BTSFieldPointValue_Ship]];
    }
    
    x2 = x1-1;
    y2 = y1;
    if ([self possibleAddShipAtPointX:x2 posintY:y2] && !isException(x2, y2)) {
        [arr addObject:[[BTSFieldPoint alloc] initWithXPos:x2 YPos:y2 value:BTSFieldPointValue_Ship]];
    }
    
    x2 = x1;
    y2 = y1-1;
    if ([self possibleAddShipAtPointX:x2 posintY:y2] && !isException(x2, y2)) {
        [arr addObject:[[BTSFieldPoint alloc] initWithXPos:x2 YPos:y2 value:BTSFieldPointValue_Ship]];
    }
    
    return [arr copy];
}
- (BOOL)possibleAddShipAtPointX:(NSInteger)x posintY:(NSInteger)y {
    
    if (x>=kMaxX || y>=kMaxY || x<0 || y<0)
        return NO;
    
    NSInteger indexY, indexX;
    
    // top
    if (y-1>=0) {
        indexY = y-1;
        
        // left
        if (x-1>=0)
        {
            indexX = x-1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
        // center
        {
            indexX = x;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
    }
    //left
    if (x-1>=0) {
        indexY = y;
        indexX = x-1;
        NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
        if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
            return NO;
        }
    }
    //right
    if (x+1<kMaxX) {
        indexY = y;
        indexX = x+1;
        NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
        if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
            return NO;
        }
    }
    // bottom
    if (y+1<kMaxY) {
        indexY = y+1;
        
        // left
        if (x-1>=0)
        {
            indexX = x-1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
        // center
        {
            indexX = x;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)self.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
                return NO;
            }
        }
    }
    return YES;
}
- (void)addEnvironmentForPoints:(NSArray*)points {
    
    __weak NSArray *helperArr = points;
    BOOL (^isException)(NSInteger, NSInteger) = ^BOOL(NSInteger x2, NSInteger y2) {
        for (BTSFieldPoint *p in helperArr) {
            if (p.x==x2 && p.y==y2) {
                return YES;
            }
        }
        return NO;
    };
    
    for (BTSFieldPoint *p in points) {
        
        NSInteger x = p.x, y = p.y;
        
        NSInteger indexY, indexX;
        
        // top
        if (y-1>=0) {
            indexY = y-1;
            
            // left
            if (x-1>=0)
            {
                indexX = x-1;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
            // center
            {
                indexX = x;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
            // right
            if (x+1<kMaxX)
            {
                indexX = x+1;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
        }
        //left
        if (x-1>=0) {
            indexY = y;
            indexX = x-1;
            if (!isException(indexX, indexY)) {
                [self addEmptyPointAtXPos:indexX YPos:indexY];
            }
        }
        //right
        if (x+1<kMaxX) {
            indexY = y;
            indexX = x+1;
            if (!isException(indexX, indexY)) {
                [self addEmptyPointAtXPos:indexX YPos:indexY];
            }
        }
        // bottom
        if (y+1<kMaxY) {
            indexY = y+1;
            
            // left
            if (x-1>=0)
            {
                indexX = x-1;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
            // center
            {
                indexX = x;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
            // right
            if (x+1<kMaxX)
            {
                indexX = x+1;
                if (!isException(indexX, indexY)) {
                    [self addEmptyPointAtXPos:indexX YPos:indexY];
                }
            }
        }
    }
}

#pragma mark add points

- (BTSFieldPoint*)addShipPointAtXPos:(NSInteger)xPos YPos:(NSInteger)yPos {
    return [self addPoint:BTSFieldPointValue_Ship atXPos:xPos YPos:yPos];
}
- (BTSFieldPoint*)addEmptyPointAtXPos:(NSInteger)xPos YPos:(NSInteger)yPos {
    return [self addPoint:BTSFieldPointValue_Empty atXPos:xPos YPos:yPos];
}
- (BTSFieldPoint*)addPoint:(BTSFieldPointValue)value atXPos:(NSInteger)xPos YPos:(NSInteger)yPos {
    BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:xPos YPos:yPos value:value];
    NSString *key = [NSString stringWithFormat:@"%ld%ld", xPos, yPos];
    self.gameFieldDictionary[key] = point;
    return point;
}

@end
