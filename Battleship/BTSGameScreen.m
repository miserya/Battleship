//
//  BTSGameScreen.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSGameScreen.h"

@interface BTSGameScreen ()

@property (weak, nonatomic) IBOutlet UIView *player1_bigView;
@property (weak, nonatomic) IBOutlet UIView *player1_bigView_gameScreen;
@property (weak, nonatomic) IBOutlet UIView *player2_smallView;
@property (weak, nonatomic) IBOutlet UIView *player2_smallView_gameScreen;

@property (weak, nonatomic) IBOutlet UIView *player1_smallView;
@property (weak, nonatomic) IBOutlet UIView *player1_smallView_gameScreen;
@property (weak, nonatomic) IBOutlet UIView *player2_bigView;
@property (weak, nonatomic) IBOutlet UIView *player2_bigView_gameScreen;

@property (weak, nonatomic) IBOutlet UIButton *btnDone_player2_bigView;
@property (weak, nonatomic) IBOutlet UILabel *label_player2_bigView;
@property (weak, nonatomic) IBOutlet UILabel *label_player1_smallView;

@end

@implementation BTSGameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.gameScreenMode) {
        case BTSGameScreenMode_OnePlayer: {
            [self.btnDone_player2_bigView setTitle:@"Exit Game" forState:UIControlStateNormal];
//            [self.btnDone_player2_bigView setImage:[UIImage imageNamed:@"btnExit"] forState:UIControlStateNormal];
            [self.label_player1_smallView setText:@"You"];
            [self.label_player2_bigView setText:@"Computer"];
            break;
        }
        case BTSGameScreenMode_Player1: {
            self.player1_bigView.hidden = YES;
            self.player2_smallView.hidden = YES;
            self.player2_bigView.hidden = NO;
            self.player1_smallView.hidden = NO;
            break;
        }
        case BTSGameScreenMode_Player2: {
            self.player1_bigView.hidden = NO;
            self.player2_smallView.hidden = NO;
            self.player2_bigView.hidden = YES;
            self.player1_smallView.hidden = YES;
            break;
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)on_player1_Done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)on_player2_Done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
