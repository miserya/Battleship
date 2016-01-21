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
@property (weak, nonatomic) IBOutlet UIButton *btnDone_player1_bigView;
@property (weak, nonatomic) IBOutlet UILabel *label_player2_bigView;
@property (weak, nonatomic) IBOutlet UILabel *label_player1_smallView;

@property (weak, nonatomic) IBOutlet UIButton *btnExitForOnePlayerGame;

@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer1;
@property (nonatomic, strong) BTSGameField *tapped_gameFieldPlayer2;

@property (nonatomic, weak) UIImageView *currentFirePoint;
@property (nonatomic, strong) BTSFieldPoint *currentFireFieldPoint;

@property (nonatomic, assign) BOOL isUserTapped;

@end

@implementation BTSGameScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUserTapped = NO;
    self.tapped_gameFieldPlayer1 = [BTSGameField new];
    self.tapped_gameFieldPlayer2 = [BTSGameField new];
    
    switch (self.gameScreenMode) {
        case BTSGameScreenMode_OnePlayer: {
//            [self.btnDone_player2_bigView setTitle:@"Exit Game" forState:UIControlStateNormal];
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
            
            self.btnExitForOnePlayerGame.hidden = NO;
            
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
    
    
    CGPoint offset_sm = (CGPoint){10.1, 10.1};
    CGPoint itemSize_sm = (CGPoint){18.75, 18.75};
    
    if (!self.player1_smallView.hidden) {
        for (BTSFieldPoint *p in self.gameFieldPlayer1.shipsPoints) {
            UIImage *ship = [UIImage imageNamed:@"ship_light_sm"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            [self.player1_smallView_gameScreen addSubview:imgView];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.tappedShipPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *mark = [UIImage imageNamed:@"shipFired_light_sm"];
            UIImageView *imgViewMark = [[UIImageView alloc] initWithImage:mark];
            imgViewMark.center = center;
            [self.player1_smallView_gameScreen addSubview:imgViewMark];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.emptyPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *empty = [UIImage imageNamed:@"firePin_light_sm"];
            UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:empty];
            imgViewEmpty.center = center;
            [self.player1_smallView_gameScreen addSubview:imgViewEmpty];
        }
    }
    [self updatePlayer1_BigView];
    
    if (!self.player2_smallView.hidden) {
        for (BTSFieldPoint *p in self.gameFieldPlayer2.shipsPoints) {
            UIImage *ship = [UIImage imageNamed:@"ship_dark_sm"];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            [self.player2_smallView_gameScreen addSubview:imgView];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer2.tappedShipPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *mark = [UIImage imageNamed:@"shipFired_dark_sm"];
            UIImageView *imgViewMark = [[UIImageView alloc] initWithImage:mark];
            imgViewMark.center = center;
            [self.player2_smallView_gameScreen addSubview:imgViewMark];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer2.emptyPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *empty = [UIImage imageNamed:@"firePin_dark_sm"];
            UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:empty];
            imgViewEmpty.center = center;
            [self.player2_smallView_gameScreen addSubview:imgViewEmpty];
        }
    }
    [self updatePlayer2_BigView];
    
//    for (BTSFieldPoint *p in self.gameFieldPlayer1.shipsPoints) {
//        if (!self.player1_bigView.hidden) {
//            UIImage *ship = [UIImage imageNamed:@"ship_light"];
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
//            imgView.center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
//            [self.player1_bigView_gameScreen addSubview:imgView];
//        }
//        else if (!self.player1_smallView.hidden) {
//            UIImage *ship = [UIImage imageNamed:@"ship_light_sm"];
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
//            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
//            [self.player1_smallView_gameScreen addSubview:imgView];
//        }
//    }
    
//    for (BTSFieldPoint *p in self.gameFieldPlayer2.shipsPoints) {
//        if (!self.player2_bigView.hidden) {
//            UIImage *ship = [UIImage imageNamed:@"ship_dark"];
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
//            imgView.center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
//            [self.player2_bigView_gameScreen addSubview:imgView];
//        }
//        else if (!self.player2_smallView.hidden) {
//            UIImage *ship = [UIImage imageNamed:@"ship_dark_sm"];
//            UIImageView *imgView = [[UIImageView alloc] initWithImage:ship];
//            imgView.center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
//            [self.player2_smallView_gameScreen addSubview:imgView];
//        }
//    }
}

#pragma mark - Updates of view

- (void)updatePlayer1_BigView {
    if (!self.player1_bigView.hidden) {
        
        for (UIView *v in self.player1_bigView_gameScreen.subviews) {
            if (v.tag == 1111) {
                [v removeFromSuperview];
            }
        }
        
        CGPoint offset = (CGPoint){17, 17};
        CGPoint itemSize = (CGPoint){33.4, 33.4};
        
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.tappedShipPoints) {
            CGPoint center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            
            UIImage *ship = [UIImage imageNamed:@"ship_light"];
            UIImageView *imgViewShip = [[UIImageView alloc] initWithImage:ship];
            imgViewShip.tag = 1111;
            imgViewShip.center = center;
            [self.player1_bigView_gameScreen addSubview:imgViewShip];
            
            UIImage *mark = [UIImage imageNamed:@"shipFired_light"];
            UIImageView *imgViewMark = [[UIImageView alloc] initWithImage:mark];
            imgViewMark.tag = 1111;
            imgViewMark.center = center;
            [self.player1_bigView_gameScreen addSubview:imgViewMark];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.emptyPoints) {
            CGPoint center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            
            UIImage *empty = [UIImage imageNamed:@"firePin_light"];
            UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:empty];
            imgViewEmpty.tag = 1111;
            imgViewEmpty.center = center;
            [self.player1_bigView_gameScreen addSubview:imgViewEmpty];
        }
    }
}
- (void)updatePlayer1_SmallView {
    if (!self.player1_smallView.hidden) {
        
        for (UIView *v in self.player1_smallView_gameScreen.subviews) {
            if (v.tag == 1111) {
                [v removeFromSuperview];
            }
        }
        
        CGPoint offset_sm = (CGPoint){10.1, 10.1};
        CGPoint itemSize_sm = (CGPoint){18.75, 18.75};
        
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.tappedShipPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *mark = [UIImage imageNamed:@"shipFired_light_sm"];
            UIImageView *imgViewMark = [[UIImageView alloc] initWithImage:mark];
            imgViewMark.center = center;
            imgViewMark.tag = 1111;
            [self.player1_smallView_gameScreen addSubview:imgViewMark];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer1.emptyPoints) {
            CGPoint center = CGPointMake(offset_sm.x+p.x*itemSize_sm.x, offset_sm.y+p.y*itemSize_sm.y);
            
            UIImage *empty = [UIImage imageNamed:@"firePin_light_sm"];
            UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:empty];
            imgViewEmpty.center = center;
            imgViewEmpty.tag = 1111;
            [self.player1_smallView_gameScreen addSubview:imgViewEmpty];
        }
    }
}
- (void)updatePlayer2_BigView {
    if (!self.player2_bigView.hidden) {
        
        for (UIView *v in self.player2_bigView_gameScreen.subviews) {
            if (v.tag == 2222) {
                [v removeFromSuperview];
            }
        }
        
        CGPoint offset = (CGPoint){17, 17};
        CGPoint itemSize = (CGPoint){33.4, 33.4};
        
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer2.tappedShipPoints) {
            CGPoint center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            
            UIImage *ship = [UIImage imageNamed:@"ship_dark"];
            UIImageView *imgViewShip = [[UIImageView alloc] initWithImage:ship];
            imgViewShip.tag = 2222;
            imgViewShip.center = center;
            [self.player2_bigView_gameScreen addSubview:imgViewShip];
            
            UIImage *mark = [UIImage imageNamed:@"shipFired_dark"];
            UIImageView *imgViewMark = [[UIImageView alloc] initWithImage:mark];
            imgViewMark.tag = 2222;
            imgViewMark.center = center;
            [self.player2_bigView_gameScreen addSubview:imgViewMark];
        }
        for (BTSFieldPoint *p in self.tapped_gameFieldPlayer2.emptyPoints) {
            CGPoint center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
            
            UIImage *empty = [UIImage imageNamed:@"firePin_dark"];
            UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:empty];
            imgViewEmpty.tag = 2222;
            imgViewEmpty.center = center;
            [self.player2_bigView_gameScreen addSubview:imgViewEmpty];
        }
        
        // test
//        {
//            CGPoint offset = (CGPoint){17, 17};
//            CGPoint itemSize = (CGPoint){33.4, 33.4};
//            
//            for (BTSFieldPoint *p in self.gameFieldPlayer2.shipsPoints) {
//                CGPoint center = CGPointMake(offset.x+p.x*itemSize.x, offset.y+p.y*itemSize.y);
//                
//                UIImage *ship = [UIImage imageNamed:@"ship_dark"];
//                UIImageView *imgViewShip = [[UIImageView alloc] initWithImage:ship];
//                imgViewShip.tag = 2222;
//                imgViewShip.center = center;
//                [self.player2_bigView_gameScreen addSubview:imgViewShip];
//            }
//        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Touch Handlers

- (IBAction)on_player1_Done:(id)sender {
    
    if ((!self.isUserTapped || self.gameScreenMode == BTSGameScreenMode_OnePlayer) && self.currentFireFieldPoint) {
        if (self.gameScreenMode != BTSGameScreenMode_OnePlayer) {
            [self.btnDone_player1_bigView setTitle:@"<< Done" forState:UIControlStateNormal];
        }
        
        NSLog(@"========== 1 FIRE! ===========");
        
        BTSFieldPointValue value = [self.gameFieldPlayer1 valueForPoint:self.currentFireFieldPoint];
        BTSFieldPointValue newValue = value == BTSFieldPointValue_Ship ? BTSFieldPointValue_TappedShip : value;
        [self.tapped_gameFieldPlayer1 setValue:newValue forPointWithX:self.currentFireFieldPoint.x Y:self.currentFireFieldPoint.y];
        
        if (newValue == BTSFieldPointValue_TappedShip) {
            
            NSLog(@"Ship tapped");
            
            NSArray *arrOfConnectedTappedPoints = [self.tapped_gameFieldPlayer1 arrOfConnectedPointsForPoint:self.currentFireFieldPoint];
            if (arrOfConnectedTappedPoints.count>4) {
                NSLog(@"Catched!");
            }
            
            NSLog(@"%d connected tapped ship_points", (int)arrOfConnectedTappedPoints.count);
            
            if ([self.gameFieldPlayer1 canArrangePointsOfShip:arrOfConnectedTappedPoints]) {
                NSLog(@"Ship is desctroyed!");
                NSArray *arrOfEmptyPoints = [self.tapped_gameFieldPlayer1 environmentOfEmptyFieldsForShipWithPoint:arrOfConnectedTappedPoints];
                NSLog(@"%d empty points", (int)arrOfEmptyPoints.count);
                for (BTSFieldPoint *p in arrOfEmptyPoints) {
                    [self.tapped_gameFieldPlayer1 setValue:BTSFieldPointValue_Empty forPointWithX:p.x Y:p.y];
                }
            }
        }
        
        [self updatePlayer1_BigView];
        if (self.gameScreenMode == BTSGameScreenMode_OnePlayer) {
            [self updatePlayer1_SmallView];
        }
        
        self.currentFireFieldPoint = nil;
        self.currentFirePoint.hidden = YES;
        self.isUserTapped = YES;
        
        if (self.gameScreenMode == BTSGameScreenMode_OnePlayer) {
            self.btnDone_player2_bigView.enabled = YES;
        }
        
        if (self.gameFieldPlayer1.shipsPoints.count == self.tapped_gameFieldPlayer1.tappedShipPoints.count) {
            NSString *message;
            if (self.gameScreenMode == BTSGameScreenMode_OnePlayer) {
                message = @"Computer is winner!";
            }
            else {
                message = @"Player2 wins!";
            }
            
            [self endGameWithNotification:message];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)on_player2_Done:(id)sender {
    if ((!self.isUserTapped || self.gameScreenMode == BTSGameScreenMode_OnePlayer) && self.currentFireFieldPoint) {
        if (self.gameScreenMode != BTSGameScreenMode_OnePlayer) {
            [self.btnDone_player2_bigView setTitle:@"<< Done" forState:UIControlStateNormal];
        }
        
        NSLog(@"========== 2 FIRE! ===========");
        
        BTSFieldPointValue value = [self.gameFieldPlayer2 valueForPoint:self.currentFireFieldPoint];
        BTSFieldPointValue newValue = value == BTSFieldPointValue_Ship ? BTSFieldPointValue_TappedShip : value;
        [self.tapped_gameFieldPlayer2 setValue:newValue forPointWithX:self.currentFireFieldPoint.x Y:self.currentFireFieldPoint.y];
        
        if (newValue == BTSFieldPointValue_TappedShip) {
            
            NSLog(@"Ship tapped");
            
            NSArray *arrOfConnectedTappedPoints = [self.tapped_gameFieldPlayer2 arrOfConnectedPointsForPoint:self.currentFireFieldPoint];
            
            NSLog(@"%d connected tapped ship_points", (int)arrOfConnectedTappedPoints.count);
            
            if ([self.gameFieldPlayer2 canArrangePointsOfShip:arrOfConnectedTappedPoints]) {
                NSLog(@"Ship is desctroyed!");
                NSArray *arrOfEmptyPoints = [self.tapped_gameFieldPlayer2 environmentOfEmptyFieldsForShipWithPoint:arrOfConnectedTappedPoints];
                NSLog(@"%d empty points", (int)arrOfEmptyPoints.count);
                for (BTSFieldPoint *p in arrOfEmptyPoints) {
                    [self.tapped_gameFieldPlayer2 setValue:BTSFieldPointValue_Empty forPointWithX:p.x Y:p.y];
                }
            }
        }
        
        [self updatePlayer2_BigView];
        
        self.currentFireFieldPoint = nil;
        self.currentFirePoint.hidden = YES;
        self.isUserTapped = YES;
        
        if (self.gameScreenMode == BTSGameScreenMode_OnePlayer) {
            self.btnDone_player2_bigView.enabled = NO;
            BTSFieldPoint *fire = [self.tapped_gameFieldPlayer1 randomFire];
            self.currentFireFieldPoint = fire;
            [self on_player1_Done:nil];
        }
        
        if (self.gameFieldPlayer2.shipsPoints.count == self.tapped_gameFieldPlayer2.tappedShipPoints.count) {
            NSString *message;
            if (self.gameScreenMode == BTSGameScreenMode_OnePlayer) {
                message = @"You are winner!";
            }
            else {
                message = @"Player1 wins!";
            }
            
            [self endGameWithNotification:message];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onExit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)endGameWithNotification:(NSString*)notificationMessage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:notificationMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Menu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

static const NSInteger kMaxX = 9;
static const NSInteger kMaxY = 9;

- (IBAction)onPlayer1_bigGameScreen_Tapped:(UITapGestureRecognizer*)sender {
    float stepX = self.player1_bigView_gameScreen.frame.size.width/kMaxX;
    float stepY = self.player1_bigView_gameScreen.frame.size.height/kMaxY;
    CGPoint pos = [sender locationInView:self.player1_bigView_gameScreen];
    NSInteger x = pos.x/stepX;
    NSInteger y = pos.y/stepY;
    self.currentFireFieldPoint = [[BTSFieldPoint alloc] initWithXPos:x YPos:y value:BTSFieldPointValue_Possible];
    CGPoint offset = (CGPoint){17, 17};
    CGPoint itemSize = (CGPoint){33.4, 33.4};
    
    if (!self.currentFirePoint) {
        UIImageView *fp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire_point_light"]];
        [self.player1_bigView_gameScreen addSubview:fp];
        self.currentFirePoint = fp;
    }
    else {
        self.currentFirePoint.hidden = NO;
    }
    
    self.currentFirePoint.center = CGPointMake(self.player1_bigView_gameScreen.frame.origin.x+offset.x+x*itemSize.x, self.player1_bigView_gameScreen.frame.origin.y+offset.y+y*itemSize.y);
    self.currentFirePoint.hidden = NO;
}
- (IBAction)onPlayer2_bigGameScreen_Tapped:(UITapGestureRecognizer*)sender {
    float stepX = self.player2_bigView_gameScreen.frame.size.width/kMaxX;
    float stepY = self.player2_bigView_gameScreen.frame.size.height/kMaxY;
    CGPoint pos = [sender locationInView:self.player2_bigView_gameScreen];
    NSInteger x = pos.x/stepX;
    NSInteger y = pos.y/stepY;
    self.currentFireFieldPoint = [[BTSFieldPoint alloc] initWithXPos:x YPos:y value:BTSFieldPointValue_Possible];
    CGPoint offset = (CGPoint){17, 17};
    CGPoint itemSize = (CGPoint){33.4, 33.4};
    
    if (!self.currentFirePoint) {
        UIImageView *fp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire_point_dark"]];
        [self.player2_bigView_gameScreen addSubview:fp];
        self.currentFirePoint = fp;
    }
    else {
        self.currentFirePoint.hidden = NO;
    }
    
    self.currentFirePoint.center = CGPointMake(offset.x+x*itemSize.x, offset.y+y*itemSize.y);
    self.currentFirePoint.hidden = NO;
}

@end
