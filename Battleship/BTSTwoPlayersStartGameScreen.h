//
//  BTSTwoPlayersStartGameScreen.h
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTSGameField;

@interface BTSTwoPlayersStartGameScreen : UIViewController

@property (strong, nonatomic) BTSGameField *player1_GameField;
@property (strong, nonatomic) BTSGameField *player2_GameField;

@end
