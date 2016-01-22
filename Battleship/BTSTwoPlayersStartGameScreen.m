//
//  BTSTwoPlayersStartGameScreen.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSTwoPlayersStartGameScreen.h"
#import "BTSGameScreen.h"
#import "BTSGameField.h"

typedef enum {
    BTSPlayer_None = 0,
    BTSPlayer_1 = 1,
    BTSPlayer_2 = 2
}BTSPlayer;

@interface BTSTwoPlayersStartGameScreen ()

@property (weak, nonatomic) IBOutlet UIImageView *player1_Ship;
@property (weak, nonatomic) IBOutlet UIImageView *player2_Ship;
@property (nonatomic) BTSPlayer currentPlayer;

@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer1;
@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer2;

@end

@implementation BTSTwoPlayersStartGameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapped_gameFieldPlayer1 = [BTSGameField new];
    self.player1_GameField = [BTSGameField new];
    [self.player1_GameField generate];
    
    self.tapped_gameFieldPlayer2 = [BTSGameField new];
    self.player2_GameField = [BTSGameField new];
    [self.player2_GameField generate];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.player1_Ship.alpha = 1.f;
    self.player2_Ship.alpha = 1.f;
    
    __block __weak BTSTwoPlayersStartGameScreen *wSelf = self;
    void (^animateShip1)() = ^void() {
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            wSelf.player2_Ship.alpha = 0.2f;
        } completion:nil];
    };
    void (^animateShip2)() = ^void() {
        [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            wSelf.player1_Ship.alpha = 0.2f;
        } completion:nil];
    };
    
    if (self.currentPlayer == BTSPlayer_None) {
        animateShip1();
        animateShip2();
    }
    else if (self.currentPlayer == BTSPlayer_1) {
        animateShip1();
    }
    else if (self.currentPlayer == BTSPlayer_2) {
        animateShip2();
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[BTSGameScreen class]]) {
        ((BTSGameScreen*)segue.destinationViewController).gameScreenMode = (self.currentPlayer == BTSPlayer_1) ? BTSGameScreenMode_Player1 : BTSGameScreenMode_Player2;
        ((BTSGameScreen*)segue.destinationViewController).gameFieldPlayer1 = self.player1_GameField;
        ((BTSGameScreen*)segue.destinationViewController).gameFieldPlayer2 = self.player2_GameField;
        ((BTSGameScreen*)segue.destinationViewController).tapped_gameFieldPlayer1 = self.tapped_gameFieldPlayer1;
        ((BTSGameScreen*)segue.destinationViewController).tapped_gameFieldPlayer2 = self.tapped_gameFieldPlayer2;
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
