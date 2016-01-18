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
@end

@implementation BTSGameField

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.gameFieldDictionary = [NSMutableDictionary new];
    self.shipsPoints = [NSMutableArray new];
    
    return self;
}

static const NSInteger kMaxX = 9;
static const NSInteger kMaxY = 9;

- (void)generate {
    int countOfShips1 = 4;
    int countOfShips2 = 3;
    int countOfShips3 = 2;
//    NSInteger countOfShips4 = 1;
    
    for (int i=0; i<countOfShips1; i++) {
        NSInteger x = arc4random()%kMaxX;
        NSInteger y = arc4random()%kMaxY;
        
        while (![self possibleAddShipAtPointX:x posintY:y]) {
            x = arc4random()%kMaxX;
            y = arc4random()%kMaxY;
        }
        
        BTSFieldPoint *ship = [self addShipPointAtXPos:x YPos:y];
        [self.shipsPoints addObject:ship];
        [self addEnvironmentForPoints:@[ship]];
    }

    int arrOfCounts[2] = {countOfShips2, countOfShips3};
    for (int j=0; j<2; j++) {
        
        int k=0, m=0;
        int maxDeep = j+2;
        for (int i=0; i<arrOfCounts[j]; i++) {
            
            NSInteger x1 = k;
            NSInteger y1 = m;
            BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:x1 YPos:y1 value:BTSFieldPointValue_Ship];
            
            NSArray *arr = [self getPossiblePointForArray:@[point] deep:1 maxDeep:maxDeep];
            while (arr.count<3) {
                k++;
                if (k==kMaxX && m<kMaxY-1) {
                    k=0;
                    m++;
                }
                else {
                    NSLog(@"Oh, no...");
                    break;
                }
                x1 = k;
                y1 = m;
                point = [[BTSFieldPoint alloc] initWithXPos:x1 YPos:y1 value:BTSFieldPointValue_Ship];
                arr = [self getPossiblePointForArray:@[point] deep:1 maxDeep:maxDeep];
            }
            for (BTSFieldPoint *p in arr) {
                BTSFieldPoint *ship = [self addShipPointAtXPos:p.x YPos:p.y];
                [self.shipsPoints addObject:ship];
            }
            
            [self addEnvironmentForPoints:arr];
        }
    }
    
//    for (int i=0; i<countOfShips2; i++) {
//        
//        NSInteger x1 = arc4random()%kMaxX;
//        NSInteger y1 = arc4random()%kMaxY;
//        BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:x1 YPos:y1 value:BTSFieldPointValue_Ship];
//        
//        NSArray *arr = [self getPossiblePointForArray:@[point] deep:1 maxDeep:2];
//        while (arr.count<2) {
//            x1 = arc4random()%kMaxX;
//            y1 = arc4random()%kMaxY;
//            point = [[BTSFieldPoint alloc] initWithXPos:x1 YPos:y1 value:BTSFieldPointValue_Ship];
//            arr = [self getPossiblePointForArray:@[point] deep:1 maxDeep:2];
//        }
//        for (BTSFieldPoint *p in arr) {
//            BTSFieldPoint *ship = [self addShipPointAtXPos:p.x YPos:p.y];
//            [self.shipsPoints addObject:ship];
//        }
//        
//        [self addEnvironmentForPoints:arr];
//    }
    
    
    
}
- (NSArray*)getPossiblePointForArray:(NSArray*)arrWithAddedPoints deep:(int)deep maxDeep:(const int)maxDeep {
    deep++;
    
    BTSFieldPoint *prevPoint = arrWithAddedPoints.lastObject;
    NSArray *arr = [self possiblePointsForPoint:prevPoint exceptPoints:arrWithAddedPoints];
    
    for (int i=0; i<arr.count; i++) {
        
        
        BTSFieldPoint *newPoint = arr[i];
        
        NSMutableArray *newExceptions = [NSMutableArray arrayWithArray:arrWithAddedPoints];
        [newExceptions addObject:newPoint];
        
        if (deep<maxDeep) {
            NSArray* nextPoints = [self getPossiblePointForArray:newExceptions deep:deep maxDeep:maxDeep];//getPossiblePoint(newExceptions, deep, maxDeep);
            if (nextPoints.count>0) {
                [newExceptions addObject:nextPoints.firstObject];
                return [newExceptions copy];
            }
        }
        else {
            return [newExceptions copy];
        }
    }
        
    return nil;
}


- (NSArray*)possiblePointsForPoint:(BTSFieldPoint*)p exceptPoints:(NSArray*)arrOfExceptions {
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
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
                return NO;
            }
        }
        // center
        {
            indexX = x;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
                return NO;
            }
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
                return NO;
            }
        }
    }
    //left
    if (x-1>=0) {
        indexY = y;
        indexX = x-1;
        NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
        if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
            return NO;
        }
    }
    //right
    if (x+1<kMaxX) {
        indexY = y;
        indexX = x+1;
        NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
        if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
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
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
                return NO;
            }
        }
        // center
        {
            indexX = x;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
                return NO;
            }
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
            if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]]) {
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
