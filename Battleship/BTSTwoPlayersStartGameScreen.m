//
//  BTSTwoPlayersStartGameScreen.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSTwoPlayersStartGameScreen.h"
#import "BTSGameScreen.h"

typedef enum {
    BTSPlayer_None = 0,
    BTSPlayer_1 = 1,
    BTSPlayer_2 = 2
}BTSPlayer;

@interface BTSTwoPlayersStartGameScreen ()

@property (weak, nonatomic) IBOutlet UIImageView *player1_Ship;
@property (weak, nonatomic) IBOutlet UIImageView *player2_Ship;
@property (nonatomic) BTSPlayer currentPlayer;

@end

@implementation BTSTwoPlayersStartGameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[BTSGameScreen class]]) {
        ((BTSGameScreen*)segue.destinationViewController).gameScreenMode = (self.currentPlayer == BTSPlayer_1) ? BTSGameScreenMode_Player1 : BTSGameScreenMode_Player2;
    }
}

- (IBAction)onPlayer1:(id)sender {
    if (self.currentPlayer == BTSPlayer_None || self.currentPlayer == BTSPlayer_2) {
        self.currentPlayer = BTSPlayer_1;
        [self performSegueWithIdentifier:@"BTSShowGameScreen" sender:self];
    }
}
- (IBAction)onPlayer2:(id)sender {
    if (self.currentPlayer == BTSPlayer_None || self.currentPlayer == BTSPlayer_1) {
        self.currentPlayer = BTSPlayer_2;
        [self performSegueWithIdentifier:@"BTSShowGameScreen" sender:self];
    }
}
- (IBAction)onExit:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
