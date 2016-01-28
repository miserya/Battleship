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

@interface BTSTwoPlayersStartGameScreen () <BTSGameScreenDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *player1_Ship;
@property (weak, nonatomic) IBOutlet UIImageView *player2_Ship;
@property (nonatomic) BTSPlayer currentPlayer;
@property (nonatomic) BOOL isGameInitialized;

@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer1;
@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer2;

@property (nonatomic, copy) void (^animateShip1)();
@property (nonatomic, copy) void (^animateShip2)();
@property (nonatomic, copy) BOOL (^canAnimateShip1)();
@property (nonatomic, copy) BOOL (^canAnimateShip2)();

//@property (nonatomic, assign) NSString *prevousDescription;

@end

@implementation BTSTwoPlayersStartGameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGameInitialized = NO;
    
//    __block BTSTwoPlayersStartGameScreen *wSelf = self;
    
    self.canAnimateShip1 = ^BOOL() {
        return (self.currentPlayer != BTSPlayer_1);
    };
    self.canAnimateShip2 = ^BOOL() {
        return (self.currentPlayer != BTSPlayer_2);
    };
    self.animateShip1 = ^void() {
        if (YES && self.canAnimateShip2()) {
            [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
                self.player2_Ship.alpha = 0.2f;
            } completion:nil];
        }
    };
    self.animateShip2 = ^void() {
        if (YES && self.canAnimateShip1()) {
            [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
                self.player1_Ship.alpha = 0.2f;
            } completion:nil];
        }
    };
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.player1_Ship.alpha = 1.f;
    self.player2_Ship.alpha = 1.f;
    
    self.animateShip1();
    self.animateShip2();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"%@", self.prevousDescription);
    if ([segue.destinationViewController isKindOfClass:[BTSGameScreen class]]) {
        ((BTSGameScreen*)segue.destinationViewController).gameScreenMode = (self.currentPlayer == BTSPlayer_1) ? BTSGameScreenMode_Player1 : BTSGameScreenMode_Player2;
        ((BTSGameScreen*)segue.destinationViewController).gameFieldPlayer1 = self.player1_GameField;
        ((BTSGameScreen*)segue.destinationViewController).gameFieldPlayer2 = self.player2_GameField;
        ((BTSGameScreen*)segue.destinationViewController).tapped_gameFieldPlayer1 = self.tapped_gameFieldPlayer1;
        ((BTSGameScreen*)segue.destinationViewController).tapped_gameFieldPlayer2 = self.tapped_gameFieldPlayer2;
        ((BTSGameScreen*)segue.destinationViewController).delegate = self;
    }
}
- (void)initializeGame {
    if (!self.isGameInitialized) {
        self.tapped_gameFieldPlayer1 = [BTSGameField new];
        self.player1_GameField = [BTSGameField new];
        [self.player1_GameField generate];
        
        self.tapped_gameFieldPlayer2 = [BTSGameField new];
        self.player2_GameField = [BTSGameField new];
        [self.player2_GameField generate];
        self.isGameInitialized = YES;
    }
}
- (IBAction)onPlayer1:(id)sender {
    if (self.currentPlayer == BTSPlayer_None || self.currentPlayer == BTSPlayer_2) {
        self.currentPlayer = BTSPlayer_1;
        [self initializeGame];
        [self performSegueWithIdentifier:@"BTSShowGameScreen" sender:self];
    }
}
- (IBAction)onPlayer2:(id)sender {
    if (self.currentPlayer == BTSPlayer_None || self.currentPlayer == BTSPlayer_1) {
        self.currentPlayer = BTSPlayer_2;
        [self initializeGame];
        [self performSegueWithIdentifier:@"BTSShowGameScreen" sender:self];
    }
}
- (IBAction)onExit:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - BTSGameScreenDelegate

- (void)onDescriptionChanged:(BTSGameScreen *)gameScreen {
    
    __block __unsafe_unretained BTSGameScreen *wGameScreen = gameScreen;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES) {
            [wGameScreen doSmth];
        }
    });
}

@end
