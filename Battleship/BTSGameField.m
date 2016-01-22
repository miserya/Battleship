//
//  BTSGameField.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/18/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSGameField.h"
@import UIKit;

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

@property (nonatomic, copy) BOOL (^isException)(NSInteger, NSInteger, NSArray*);
@property (nonatomic, copy) NSArray* (^shipsArrRelatedToPoint)(BTSFieldPoint*, NSArray*);

@property (nonatomic, strong) NSMutableArray *arrOfFreePositions;

@end

@implementation BTSGameField

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.gameFieldDictionary = [NSMutableDictionary new];
    self.shipsPoints = [NSMutableArray new];
    self.tappedShipPoints = [NSMutableArray new];
    self.emptyPoints = [NSMutableArray new];
    
    __block __weak BTSGameField *wSelf = self;
    
    self.isException = ^BOOL(NSInteger x2, NSInteger y2, NSArray* exceptions) {
        if (!exceptions)
            return NO;
        
        for (BTSFieldPoint *p in exceptions) {
            if (p.x==x2 && p.y==y2) {
                return YES;
            }
        }
        return NO;
    };
    self.shipsArrRelatedToPoint = ^NSArray*(BTSFieldPoint* point, NSArray *exceptions) {
        
        __block NSMutableArray *arr = [NSMutableArray new];
        __block NSMutableArray *arrOfExceptions = [NSMutableArray arrayWithArray:exceptions];
        void (^addPoint) (NSInteger, NSInteger) = ^void (NSInteger x, NSInteger y) {
            NSString *key = [NSString stringWithFormat:@"%ld%ld", x, y];
            BTSFieldPoint *p = wSelf.gameFieldDictionary[key];
            if (p && ![p isKindOfClass:[NSNull class]]
                && (p.value == BTSFieldPointValue_Ship || p.value == BTSFieldPointValue_TappedShip)
                && !self.isException(p.x, p.y, arrOfExceptions)) {
                [arr addObject:p];
                [arrOfExceptions addObject:p];
            }
        };
        
        NSInteger x = point.x;
        NSInteger y = point.y;
        
        NSInteger x1 = x;
        NSInteger y1 = y;
        
        //top
        if (y-1>=0)
        {
            x1 = x;
            y1 = y-1;
//            NSString *key = [NSString stringWithFormat:@"%ld%ld", x1, y1];
//            BTSFieldPoint *p = wSelf.gameFieldDictionary[key];
//            if (p && ![p isKindOfClass:[NSNull class]] && (p.value == BTSFieldPointValue_Ship || p.value == BTSFieldPointValue_TappedShip) && !self.isException(p.x, p.y, exceptions)) {
//                [arr addObject:p];
//            }
            addPoint(x1, y1);
        }
        //left
        if (x-1>=0)
        {
            x1 = x-1;
            y1 = y;
            addPoint(x1, y1);
        }
        //right
        if (x+1<kMaxX)
        {
            x1 = x+1;
            y1 = y;
            addPoint(x1, y1);
        }
        //bottom
        if (y+1<kMaxY)
        {
            x1 = x;
            y1 = y+1;
            addPoint(x1, y1);
        }
        
        return [arr copy];
    };
    
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
    
    if (self.arrOfFreePositions) {
        for (NSValue *value in self.arrOfFreePositions) {
            CGPoint point = [value CGPointValue];
            if ((NSInteger)point.x == x && (NSInteger)point.y == y) {
                [self.arrOfFreePositions removeObject:value];
                break;
            }
        }
    }
}
- (BOOL)isPointAlreadyTapped:(BTSFieldPoint*)point {
    NSString *key = [NSString stringWithFormat:@"%ld%ld", point.x, point.y];
    if (self.gameFieldDictionary[key] && ![self.gameFieldDictionary[key] isKindOfClass:[NSNull class]])
        return YES;
    return NO;
}

- (BTSFieldPoint*)randomFire {
    if (!self.arrOfFreePositions) {
        self.arrOfFreePositions = [NSMutableArray new];
        for (NSInteger i=0; i<kMaxX; i++) {
            for (NSInteger j=0; j<kMaxY; j++) {
                [self.arrOfFreePositions addObject:[NSValue valueWithCGPoint:CGPointMake(i, j)]];
            }
        }
    }
    
    NSInteger randomIndex = arc4random()%self.arrOfFreePositions.count;
    NSValue *value = self.arrOfFreePositions[randomIndex];
    CGPoint index = [value CGPointValue];
    BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:index.x YPos:index.y value:BTSFieldPointValue_Possible];
    return point;
}

#pragma mark - Ship Detection

- (NSArray*)arrOfConnectedPointsForPoint:(BTSFieldPoint*)point {
    NSMutableArray *arrOfExceptions = [@[point] mutableCopy];
    NSArray *arr = self.shipsArrRelatedToPoint(point, [arrOfExceptions copy]);
    while (arr.count>0) {
        [arrOfExceptions addObjectsFromArray:arr];
        
        NSMutableArray *newExceptions = [NSMutableArray new];
        for (BTSFieldPoint *p in arr) {
            NSArray *tempArr = self.shipsArrRelatedToPoint(p, [arrOfExceptions copy]);
            [newExceptions addObjectsFromArray:tempArr];
        }
        
        arr = [newExceptions copy];
    }
    
    //check for points repeting
    {
        NSMutableArray *arrToDelete = [NSMutableArray new];
        for (int i=0; i<arrOfExceptions.count; i++) {
            BTSFieldPoint *p1 = arrOfExceptions[i];
            for (int j=i; j<arrOfExceptions.count; j++) {
                BTSFieldPoint *p2 = arrOfExceptions[j];
                if (p1!=p2 && p1.x==p2.x && p1.y==p2.y) {
                    NSLog(@"Catched!");
                    [arrToDelete addObject:p2];
                }
            }
        }
    }
    return arrOfExceptions;
}
- (BOOL)canArrangePointsOfShip:(NSArray*)shipsPoints {
    
    for (BTSFieldPoint *p in shipsPoints) {
        NSString *key = [NSString stringWithFormat:@"%ld%ld", p.x, p.y];
        NSArray *arr = self.shipsArrRelatedToPoint(self.gameFieldDictionary[key], shipsPoints);
        if (arr.count>0)
            return NO;
    }
    return YES;
}
- (NSArray*)environmentOfEmptyFieldsForShipWithPoint:(NSArray*)points {
    return [self environmentForPoints:points];
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
            
            NSArray *arrayOfEmptyPoints = [self environmentForPoints:arr];
            for (BTSFieldPoint *p in arrayOfEmptyPoints) {
                [self addEmptyPointAtXPos:p.x YPos:p.y];
            }
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

    __block NSMutableArray *arr = [NSMutableArray new];
    __block NSMutableArray *exceptions = [arrOfExceptions mutableCopy];

    void (^addPoint)(NSInteger, NSInteger) = ^void(NSInteger x, NSInteger y) {
        if ([self possibleAddShipAtPointX:x posintY:y] && !self.isException(x, y, exceptions)) {
            BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:x YPos:y value:BTSFieldPointValue_Ship];
            [arr addObject:point];
            [exceptions addObject:point];
        }
    };
    
    NSInteger x1 = p.x;
    NSInteger y1 = p.y;

    NSInteger x2 = x1+1;
    NSInteger y2 = y1;
    
    if (x1+1<kMaxX) {
        x2 = x1+1;
        y2 = y1;
//        if ([self possibleAddShipAtPointX:x2 posintY:y2] && !self.isException(x2, y2, arrOfExceptions)) {
//            [arr addObject:[[BTSFieldPoint alloc] initWithXPos:x2 YPos:y2 value:BTSFieldPointValue_Ship]];
//        }
        addPoint(x2, y2);
    }
    
    if (y1+1<kMaxY) {
        x2 = x1;
        y2 = y1+1;
        addPoint(x2, y2);
    }
    
    if (x1-1>=0) {
        x2 = x1-1;
        y2 = y1;
        addPoint(x2, y2);
    }
    
    if (y1-1>=0) {
        x2 = x1;
        y2 = y1-1;
        addPoint(x2, y2);
    }
    
    return [arr copy];
}
- (BOOL)possibleAddShipAtPointX:(NSInteger)x posintY:(NSInteger)y {
    
    if (x>=kMaxX || y>=kMaxY || x<0 || y<0)
        return NO;
    
    __block __weak BTSGameField *wSelf = self;
    BOOL (^checkPoint)(NSInteger, NSInteger) = ^BOOL (NSInteger indexX, NSInteger indexY) {
        NSString *key = [NSString stringWithFormat:@"%ld%ld", indexX, indexY];
        if (wSelf.gameFieldDictionary[key] && ![wSelf.gameFieldDictionary[key] isKindOfClass:[NSNull class]] && ((BTSFieldPoint*)wSelf.gameFieldDictionary[key]).value == BTSFieldPointValue_Ship) {
            return NO;
        }
        return YES;
    };
    
    NSInteger indexY, indexX;
    //center
    {
        indexX = x;
        indexY = y;
        if (!checkPoint(indexX, indexY)) return NO;
    }
    // top
    if (y-1>=0) {
        indexY = y-1;
        
        // left
        if (x-1>=0)
        {
            indexX = x-1;
            if (!checkPoint(indexX, indexY)) return NO;
        }
        // center
        {
            indexX = x;
            if (!checkPoint(indexX, indexY)) return NO;
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            if (!checkPoint(indexX, indexY)) return NO;
        }
    }
    //left
    if (x-1>=0) {
        indexY = y;
        indexX = x-1;
        if (!checkPoint(indexX, indexY)) return NO;
    }
    //right
    if (x+1<kMaxX) {
        indexY = y;
        indexX = x+1;
        if (!checkPoint(indexX, indexY)) return NO;
    }
    // bottom
    if (y+1<kMaxY) {
        indexY = y+1;
        
        // left
        if (x-1>=0)
        {
            indexX = x-1;
            if (!checkPoint(indexX, indexY)) return NO;
        }
        // center
        {
            indexX = x;
            if (!checkPoint(indexX, indexY)) return NO;
        }
        // right
        if (x+1<kMaxX)
        {
            indexX = x+1;
            if (!checkPoint(indexX, indexY)) return NO;
        }
    }
    return YES;
}
- (NSArray*)environmentForPoints:(NSArray*)points {
    __block NSMutableArray *arr = [NSMutableArray new];
    __block NSMutableArray *exceptions = [points mutableCopy];
    
    void (^addPoint)(NSInteger, NSInteger) = ^void (NSInteger x, NSInteger y) {
        if (!self.isException(x, y, exceptions)) {
            BTSFieldPoint *point = [[BTSFieldPoint alloc] initWithXPos:x YPos:y value:BTSFieldPointValue_Empty];
            [arr addObject:point];
            [exceptions addObject:point];
        }
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
                addPoint(indexX, indexY);
            }
            // center
            {
                indexX = x;
                addPoint(indexX, indexY);
            }
            // right
            if (x+1<kMaxX)
            {
                indexX = x+1;
                addPoint(indexX, indexY);
            }
        }
        //left
        if (x-1>=0) {
            indexY = y;
            indexX = x-1;
            addPoint(indexX, indexY);
        }
        //right
        if (x+1<kMaxX) {
            indexY = y;
            indexX = x+1;
            addPoint(indexX, indexY);
        }
        // bottom
        if (y+1<kMaxY) {
            indexY = y+1;
            
            // left
            if (x-1>=0)
            {
                indexX = x-1;
                addPoint(indexX, indexY);
            }
            // center
            {
                indexX = x;
                addPoint(indexX, indexY);
            }
            // right
            if (x+1<kMaxX)
            {
                indexX = x+1;
                addPoint(indexX, indexY);
            }
        }
    }
    
    return [arr copy];
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
