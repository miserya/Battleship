//
//  BTSGameField.h
//  Battleship
//
//  Created by Mariya Golubeva on 1/18/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BTSFieldPointValue_Ship = 0,
    BTSFieldPointValue_Empty
}BTSFieldPointValue;

@interface BTSFieldPoint : NSObject
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;
@property (nonatomic, readonly) BTSFieldPointValue value;
- (instancetype)initWithXPos:(NSInteger)x YPos:(NSInteger)y value:(BTSFieldPointValue)value;
@end

@interface BTSGameField : NSObject
@property (nonatomic, readonly) NSMutableArray *shipsPoints;
- (void)generate;
@end
