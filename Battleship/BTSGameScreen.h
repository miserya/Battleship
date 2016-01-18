//
//  BTSGameScreen.h
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BTSGameScreenMode_OnePlayer = 0,
    BTSGameScreenMode_Player1,
    BTSGameScreenMode_Player2
}BTSGameScreenMode;

@interface BTSGameScreen : UIViewController
@property (nonatomic) BTSGameScreenMode gameScreenMode;
@end
