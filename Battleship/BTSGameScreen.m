//
//  BTSGameScreen.m
//  Battleship
//
//  Created by Mariya Golubeva on 1/14/16.
//  Copyright © 2016 Mariya Golubeva. All rights reserved.
//

#import "BTSGameScreen.h"
#import "BTSGameField.h"

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
            
            self.gameFieldPlayer1 = [BTSGameField new];
            [self.gameFieldPlayer1 generate];
    
            self.gameFieldPlayer2 = [BTSGameField new];
            [self.gameFieldPlayer2 generate];
            
            self.player1_bigView.hidden = YES;
            self.player2_smallView.hidden = YES;
            self.player2_bigView.hidden = NO;
            self.player1_smallView.hidden = NO;
            
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
    
    CGPoint offset = (CGPoint){17, 17};
    CGPoint offset_sm = (CGPoint){9, 9};
    CGPoint itemSize = (CGPoint){33.4, 33.4};
    CGPoint itemSize_sm = (CGPoint){16.6, 16.6};
    
    for (BTSFieldPoint *p in self.gameFieldPlayer1.shipsPoints) {
        if (!self.player1_bigView.hidden) {
            UIImage *ship = [UIImage imageNamed:@"ship_light"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            [self.player1_bigView_gameScreen addSubview:imgView];
        }
        else if (!self.player1_smallView.hidden) {
            UIImage *ship = [UIImage imageNamed:@"ship_light_sm"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            [self.player1_smallView_gameScreen addSubview:imgView];
        }
    }
    
    for (BTSFieldPoint *p in self.gameFieldPlayer2.shipsPoints) {
        if (!self.player2_bigView.hidden) {
            UIImage *ship = [UIImage imageNamed:@"ship_dark"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            [self.player2_bigView_gameScreen addSubview:imgView];
        }
        else if (!self.player2_smallView.hidden) {
            UIImage *ship = [UIImage imageNamed:@"ship_dark_sm"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            [self.player2_smallView_gameScreen addSubview:imgView];
        }
    }
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
