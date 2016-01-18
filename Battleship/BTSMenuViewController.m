//
//  BTSMenuViewController.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSMenuViewController.h"
#import "BTSGameScreen.h"

typedef enum {
    BTSGameMode_OnePlayer = 0,
    BTSGameMode_TwoPlayers
}BTSGameMode;

@interface BTSMenuViewController ()
@property (nonatomic) BTSGameMode curentGameMode;
@end

@implementation BTSMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[BTSGameScreen class]]) {
        if (self.curentGameMode == BTSGameMode_OnePlayer) {
            ((BTSGameScreen*)segue.destinationViewController).gameScreenMode = BTSGameScreenMode_OnePlayer;
        }
    }
}

- (IBAction)onOnePlayer:(id)sender {
    self.curentGameMode = BTSGameMode_OnePlayer;
}
- (IBAction)onTwoPlayers:(id)sender {
    self.curentGameMode = BTSGameMode_TwoPlayers;
}

@end
