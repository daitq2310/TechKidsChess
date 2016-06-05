//
//  GameViewController.h
//  Go Game
//
//  Created by Hung Ga 123 on 5/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameConstants.h"
#import "Goban.h"
#import "ChatRoomViewController.h"
@interface GameViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *blackRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteRemainingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *blackCapturedStoneCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *whiteCapturedStoneCountLabel;
@property (nonatomic, strong) NSTimer *gameClock;
@property (nonatomic, strong) Game *game;

@property NSString *username;

@end
