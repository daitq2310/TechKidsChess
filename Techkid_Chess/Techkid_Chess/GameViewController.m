//
//  GameViewController.m
//  Go Game
//
//  Created by Hung Ga 123 on 5/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "GameViewController.h"
#import "ChatRoomViewController.h"
#import "Utils.h"
#import "DataManager.h"

@interface GameViewController () <ChatRoomViewControllerDelegate>
@property (nonatomic) BOOL currentlyMarkingStonesAsDead;
@property int count;
@property ChatRoomViewController *socketRoom;
@property int waiting1;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startTimer];
    self.socketRoom = [[ChatRoomViewController alloc] initWithUserName:self.username room:@"co_vay_69"];
    [self.socketRoom startSocket];
    self.socketRoom.delegate = self;
    
    [self.view setUserInteractionEnabled:YES];
    self.game = [[Game alloc] init];
    [self layoutInterface];
    _count = 0;
    
    [self customNavigation];
}



- (void) newGame {
    
}


#pragma mark - Using socket
- (void) handleMessage:(NSDictionary *)val;
{
    NSLog(@"ANOTHER USER SEND YOU MESSAGE %@", val);
    
    NSDictionary *dictValue = [Utils dictByJSONString:val[@"message"]];
    //NSDictionary *dictValueAgain = [Utils dictByJSONString:val[@"messageAgain"]];
    int rowNumber = [dictValue[@"rowValue"] intValue];
    int columnNumber = [dictValue[@"columnValue"] intValue];

    //int waiting = [dictValueAgain[@"waiting"] intValue];
    NSString *owner_id = dictValue[@"playerId"];
    if (owner_id != _username || ![owner_id isEqualToString:_username]) {
        [self.view setUserInteractionEnabled:YES];
        [self drawNewMoveWithColumnNumber:columnNumber andRowNumber:rowNumber];
        
    }

    

    
    //    if (waiting == 1) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play Again" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //        [alert show];
    //        [self viewDidLoad];
    //    }
    
    
    
    
}





#pragma mark - Draw move for each color
- (void)playMoveAtRow:(int)row column:(int)column forColor:(NSString *)color {
    
    [self.game playMoveAtRow:row column:column forColor:color];
    [self drawBoardForNewMove:row andColumn:column];
    if ([color isEqualToString:GobanBlackSpotString]) {
        self.blackCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%ld", self.game.capturedWhiteStones];
    }
    else if ([color isEqualToString:GobanWhiteSpotString]) {
        self.whiteCapturedStoneCountLabel.text = [NSString stringWithFormat:@"%ld", self.game.capturedBlackStones];
    }
}



#pragma mark - Draw New Move
- (void) drawNewMoveWithColumnNumber : (int) columnNumber andRowNumber : (int) rowNumber {
    if (self.currentlyMarkingStonesAsDead && [self.game isInBounds:rowNumber andForColumnValue:columnNumber]) {
        /*
         * Marking stones as dead
         */
        if([self.game.goban[rowNumber][columnNumber] isEqualToString:GobanBlackSpotString]) {
            [self.game markStoneClusterAsDeadFor:rowNumber andForColumnValue:columnNumber andForColor:GobanBlackSpotString];
        }
        else if([self.game.goban[rowNumber][columnNumber] isEqualToString:GobanWhiteSpotString]) {
            [self.game markStoneClusterAsDeadFor:rowNumber andForColumnValue:columnNumber andForColor:GobanWhiteSpotString];
        }
    }
    else if ([self.game isLegalMove:rowNumber andForColumnValue:columnNumber]) {
        if([self.game.turn isEqualToString:GobanBlackSpotString]) {
            [self playMoveAtRow:rowNumber column:columnNumber forColor:GobanBlackSpotString];
        }
        else {
            [self playMoveAtRow:rowNumber column:columnNumber forColor:GobanWhiteSpotString];
        }
    }
    
}




#pragma mark - UIGestureRecognizers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([StaticData shareInstance].lastUserId == self.userid) {
//        return;
//    }
    
    
    
    int rowValue = 0;
    int columnValue = 0;
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [touch locationInView:self.view];
        rowValue = (int)floor(touchPoint.x / stoneSize);
        columnValue = (int)floor((touchPoint.y - GobanMiddleOffsetSize) / stoneSize);
    }
    [self drawNewMoveWithColumnNumber:columnValue andRowNumber:rowValue];
    
    NSDictionary *dictData = @{@"rowValue" : @(rowValue), @"columnValue": @(columnValue), @"playerId" : self.socketRoom.userName};
    NSString *strData = [Utils stringJSONByDictionary:dictData];
    
    [self.socketRoom.socket emit:@"message" withItems:@[strData, self.socketRoom.roomName, self.socketRoom.userName]];
    [self.view setUserInteractionEnabled:NO];
    
    [Goban printBoardToConsole:self.game.goban];
    _count++;
    if(_count == 361){
        [self scoreGame];
        [_gameClock invalidate];
        [self.view setUserInteractionEnabled:NO];
    }
}



#pragma mark - Draw Board
- (void)drawNewMoveOnBoardForRow:(int)rowOfNewMove andColumn:(int)columnOfNewMove {
    CALayer *stoneLayer = [CALayer layer];
    if([self.game.goban[rowOfNewMove][columnOfNewMove] isEqualToString:GobanBlackSpotString]) {
        stoneLayer.frame = CGRectMake(rowOfNewMove * stoneSize,
                                      columnOfNewMove * stoneSize + GobanMiddleOffsetSize,
                                      stoneSize,
                                      stoneSize);
        stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
        [self.view.layer addSublayer:stoneLayer];
    }
    else if([self.game.goban[rowOfNewMove][columnOfNewMove] isEqualToString:GobanWhiteSpotString]) {
        stoneLayer.frame = CGRectMake(rowOfNewMove * stoneSize,
                                      columnOfNewMove * stoneSize + GobanMiddleOffsetSize,
                                      stoneSize,
                                      stoneSize);
        stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
    }
    [self.view.layer addSublayer:stoneLayer];
}



- (void)drawBoard {
    CALayer *boardLayer = [CALayer layer];
    boardLayer.frame = CGRectMake(0, GobanMiddleOffsetSize, 414, 414);
    boardLayer.contents = (id) [UIImage imageNamed:GobanBoardImageFileName].CGImage;
    [self.view.layer addSublayer:boardLayer];
}



#pragma mark - Draw all moves
- (void)drawAllMovesOnBoard {
    for(int i = 0 ;i < self.game.goban.count; i++) {
        for(int j = 0; j < self.game.goban.count; j++) {
            CALayer *stoneLayer = [CALayer layer];
            if([self.game.goban[j][i] isEqualToString:GobanBlackSpotString]) {
                stoneLayer.frame = CGRectMake(j * stoneSize,
                                              i * stoneSize + GobanMiddleOffsetSize,
                                              stoneSize,
                                              stoneSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
            }
            else if([self.game.goban[j][i] isEqualToString:GobanWhiteSpotString]) {
                stoneLayer.frame = CGRectMake(j * stoneSize,
                                              i * stoneSize + GobanMiddleOffsetSize,
                                              stoneSize,
                                              stoneSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
            }
            else if([self.game.goban[j][i] isEqualToString:@"w"]) {
                stoneLayer.frame = CGRectMake(j * stoneSize,
                                              i * stoneSize + GobanMiddleOffsetSize,
                                              stoneSize,
                                              stoneSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
                stoneLayer.opacity = 0.5;
            }
            else if([self.game.goban[j][i] isEqualToString:@"b"]) {
                stoneLayer.frame = CGRectMake(j * stoneSize,
                                              i * stoneSize + GobanMiddleOffsetSize,
                                              stoneSize,
                                              stoneSize);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
                stoneLayer.opacity = 0.5;
            }
            else if([self.game.goban[j][i] isEqualToString:@"Wp"]) {
                stoneLayer.frame = CGRectMake(j * stoneSize + (stoneSize / 4),
                                              i * stoneSize + (stoneSize / 4) + GobanMiddleOffsetSize, stoneSize / 2,stoneSize / 2);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanWhiteStoneFileName].CGImage;
            }
            else if([self.game.goban[j][i] isEqualToString:@"Bp"]) {
                stoneLayer.frame = CGRectMake(j * stoneSize + stoneSize / 4,
                                              i * stoneSize + (stoneSize / 4) + GobanMiddleOffsetSize,
                                              stoneSize / 2,
                                              stoneSize/2);
                stoneLayer.contents = (id)[UIImage imageNamed:GobanBlackStoneFileName].CGImage;
            }
            [self.view.layer addSublayer:stoneLayer];
        }
    }
}




- (void)drawBoardForNewMove:(int)rowOfNewMove andColumn:(int)columnOfNewMove {
    if(!self.game.redrawBoardNeeded) {
        [self drawNewMoveOnBoardForRow:rowOfNewMove andColumn:columnOfNewMove];
    }
    else {
        [self drawBoard];
        [self drawAllMovesOnBoard];
        self.game.redrawBoardNeeded = NO;
    }
}



#pragma mark - Layout interface
- (void)layoutInterface {
    // Add the main view image
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.frame = CGRectMake(0,GobanMiddleOffsetSize,414,414);
    sublayer.contents = (id) [UIImage imageNamed:GobanBoardImageFileName].CGImage;
    [self.view.layer addSublayer:sublayer];
    
    self.blackCapturedStoneCountLabel.textColor = [UIColor blackColor];
    self.whiteCapturedStoneCountLabel.textColor = [UIColor blackColor];
    self.whiteRemainingTimeLabel.textColor = [UIColor blackColor];
    self.blackRemainingTimeLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
}




#pragma mark - Game Scorings
-(void)scoreGame {
    NSLog(@"Scoring game");
    int points = 0;
    NSMutableArray *emptySpaces = [[NSMutableArray alloc] init];
    NSString *addingPointsFor = [[NSMutableString alloc] init];
    
    //Turn off mark stones as dead
    [self setCurrentlyMarkingStonesAsDead:NO];
    
    for(int i = 0 ; i < self.game.goban.count; i++) {
        for(int j = 0; j< self.game.goban.count; j++) {
            if([self.game.goban[j][i] isEqualToString:GobanEmptySpotString] ||
               [self.game.goban[j][i] isEqualToString:@"w"] ||
               [self.game.goban[j][i] isEqualToString:@"b"]) {
                if([addingPointsFor isEqualToString:GobanBlackSpotString]) {
                    //Mark the locations to draw half-stones for black at this position
                    self.game.goban[j][i] = @"Bp";
                    [self.game setBlackStones:(self.game.blackStones+1)];
                }
                else if([addingPointsFor isEqualToString:GobanWhiteSpotString]) {
                    //Just draw a half-stone for white at this position
                    self.game.goban[j][i] = @"Wp";
                    [self.game setWhiteStones:(self.game.whiteStones+1)];
                }
                else {
                    Stone *emptySpace = [[Stone alloc] initWithWithRow:j column:i];
                    [emptySpaces addObject:emptySpace];
                    points++;
                }
            }
            else if([self.game.goban[j][i] isEqualToString:GobanBlackSpotString])
            {
                //Marking any free spaces as black's points
                if(points > 0)
                {
                    //NSLog(@"Points need accounting for (black)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.game.goban[emptySpace.row][emptySpace.column] = @"Bp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = GobanBlackSpotString;
                [self.game setBlackStones:(self.game.blackStones+points+1)];
                points = 0;
            }
            else if([self.game.goban[j][i] isEqualToString:GobanWhiteSpotString])
            {
                //Marking any free spaces as white's points
                if(points > 0)
                {
                    // NSLog(@"Points need accounting for (white)");
                    while([emptySpaces count] > 0)
                    {
                        Stone *emptySpace = emptySpaces[0];
                        self.game.goban[emptySpace.row][emptySpace.column] = @"Wp";
                        [emptySpaces removeObjectAtIndex:0];
                    }
                }
                addingPointsFor = GobanWhiteSpotString;
                [self.game setWhiteStones:(self.game.whiteStones+points+1)];
                points = 0;
            }
        }
        addingPointsFor = @"Nobody";
    }
    
    //Redraw the board ot show the scored points
    [self.game setRedrawBoardNeeded:YES];
    [self drawBoardForNewMove:0 andColumn:0];
    
    //Convert both to floats and add the komi value to white
    double blackScore = (double)self.game.blackStones + (double)self.game.capturedWhiteStones;
    double whiteScore = (double)self.game.whiteStones + (double)self.game.capturedBlackStones + self.game.komi;
    
    NSString *pointTally = [NSString stringWithFormat:@"Black: %d points + %ld captures = %.1f\nWhite: %d points + %ld captures + %.1f komi = %.1f", self.game.blackStones, self.game.capturedWhiteStones, blackScore, self.game.whiteStones, self.game.capturedBlackStones, self.game.komi, whiteScore];
    
    NSString *title = nil;
    NSString *cancelButtonTitle = @"OK";
    NSString *playAgainButtleTitle = @"Play Again?";
    if(blackScore > whiteScore) {
        title = @"Black wins!";
    }
    else if(whiteScore > blackScore) {
        title = @"White wins!";
    }
    else {
        title = @"Tie?";
    }
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:pointTally
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnCancel = [UIAlertAction
                                actionWithTitle:cancelButtonTitle
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    UIAlertAction* btnPlayAgain = [UIAlertAction
                                   actionWithTitle:playAgainButtleTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [self viewDidLoad];
                                   }];
    
    [alert addAction:btnCancel];
    [alert addAction:btnPlayAgain];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Game Clock
- (void) startTimer {
    _whiteCapturedStoneCountLabel.text = @"0";
    _blackCapturedStoneCountLabel.text = @"0";
    _blackRemainingTimeLabel.text = @"10:00";
    _whiteRemainingTimeLabel.text = @"10:00";
    self.gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(timerCallback)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)timerCallback {
    NSMutableString *result = [NSMutableString string];
    int iMinutes = 25;
    int iSeconds = 0;
    
    if([self.game.turn isEqualToString:GobanBlackSpotString]) {
        iMinutes = [[self.blackRemainingTimeLabel.text substringToIndex:2] intValue];
        iSeconds = [[self.blackRemainingTimeLabel.text substringFromIndex:3] intValue];
        if(iMinutes < 0) {
            [self timeUp];
        }
        else if(iSeconds <= 0) {
            iMinutes--;
            iSeconds = 59;
        }
        else {
            iSeconds--;
        }
        
        if(iMinutes < 0) {
            [self.gameClock invalidate];
            self.gameClock = nil;
            [self timeUp];
        }
        else {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds];
            self.blackRemainingTimeLabel.text = result;
        }
    }
    else if([self.game.turn isEqualToString:GobanWhiteSpotString]) {
        iMinutes = [[self.whiteRemainingTimeLabel.text substringToIndex:2] intValue];
        iSeconds = [[self.whiteRemainingTimeLabel.text substringFromIndex:3] intValue];
        if(iSeconds <= 0) {
            iMinutes--;
            iSeconds = 59;
        }
        else {
            iSeconds--;
        }
        
        if(iMinutes < 0) {
            [self.gameClock invalidate];
            self.gameClock = nil;
            [self timeUp];
        }
        else {
            result = [NSMutableString stringWithFormat:@"%.2d:%.2d",iMinutes,iSeconds];
            self.whiteRemainingTimeLabel.text = result;
        }
    }
}

- (void)timeUp {
    NSString *title = nil;
    NSString *message = nil;
    NSString *cancelButtonTitle = @"OK";
    NSString *playAgainButtonTitle = @"Play Again";
    if([self.game.turn isEqualToString:GobanBlackSpotString]) {
        title = @"White Wins!";
        message = @"Black ran out of time!";
    }
    else {
        title = @"Black Wins!";
        message = @"White ran out of time!";
    }
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnCancel = [UIAlertAction
                                actionWithTitle:cancelButtonTitle
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    
    UIAlertAction* btnPlayAgain = [UIAlertAction
                                   actionWithTitle:playAgainButtonTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    
    [alert addAction:btnCancel];
    [alert addAction:btnPlayAgain];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - Custom navigation
- (void) customNavigation {
    //---------------------------------------------------------
    //change back button icon
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //---------------------------------------------------------
    //set first title
    self.navigationItem.title = @"Go Game";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:23], NSFontAttributeName, nil]];
    
    //---------------------------------------------------------
    //Right button
    UIButton *btnAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnAgainImage = [UIImage imageNamed:@"again"]  ;
    [btnAgain setBackgroundImage:btnAgainImage forState:UIControlStateNormal];
    [btnAgain addTarget:self action:@selector(btnPlayAgainTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnAgain.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *buttonAgain = [[UIBarButtonItem alloc] initWithCustomView:btnAgain];
    
    UIButton *btnChatWithPeople = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnChatImage = [UIImage imageNamed:@"chat"]  ;
    [btnChatWithPeople setBackgroundImage:btnChatImage forState:UIControlStateNormal];
    [btnChatWithPeople addTarget:self action:@selector(btnGoChatBoxTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnChatWithPeople.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *buttonChat = [[UIBarButtonItem alloc] initWithCustomView:btnChatWithPeople];
    self.navigationItem.rightBarButtonItems = @[buttonAgain, buttonChat];
}

#pragma mark - Play Again
- (void) btnPlayAgainTouchUpInside : (id) sender{
    //    int waiting = 1;
    //    if (true) {
    //        NSDictionary *dictData = @{@"waiting":@(waiting)};
    //        NSString *strData = [Utils stringJSONByDictionary:dictData];
    //
    //        [self.socketRoom.socket emit:@"messageAgain" withItems:@[strData, self.socketRoom.roomName, self.socketRoom.userName]];
    //    }
    //
    //    [self viewDidLoad];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"PLAY AGAIN"
                                  message:@"Do you want to play again?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self viewDidLoad];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Call chat box
- (void) goChat {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _chatBoxVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatBoxID"];
    
    UIView* myView = _chatBoxVC.view;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:myView];
}

- (void) btnGoChatBoxTouchUpInside : (id) sender {
    [self goChat];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
