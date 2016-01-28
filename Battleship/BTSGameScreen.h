//
//  BTSGameScreen.h
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSGameField;
@class BTSGameScreen;

@protocol BTSGameScreenDelegate <NSObject>
- (void)onDescriptionChanged:(BTSGameScreen*)gameField;
@end

typedef enum {
    BTSGameScreenMode_OnePlayer = 0,
    BTSGameScreenMode_Player1,
    BTSGameScreenMode_Player2
}BTSGameScreenMode;

@interface BTSGameScreen : UIViewController

@property (nonatomic) BTSGameScreenMode gameScreenMode;

@property (nonatomic, strong) BTSGameField *gameFieldPlayer1;
@property (nonatomic, strong) BTSGameField *gameFieldPlayer2;

@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer1;
@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer2;

@property (nonatomic, weak) id<BTSGameScreenDelegate> delegate;
- (void)doSmth;
@end
