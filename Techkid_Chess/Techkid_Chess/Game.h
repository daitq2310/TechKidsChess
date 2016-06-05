//
//  Game.h
//  Go Game
//
//  Created by Hung Ga 123 on 5/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Goban.h"
#import "GameConstants.h"
#import "Stone.h"
@interface Game : NSObject

@property (nonatomic, strong) NSMutableArray *goban;
@property (nonatomic, strong) NSMutableArray *previousStateOfBoard;
@property (nonatomic) int blackStones;
@property (nonatomic) int whiteStones;
@property (nonatomic) double komi;
@property (nonatomic, strong) NSString *turn;
@property (nonatomic) int moveNumber;
@property (nonatomic) long capturedBlackStones;
@property (nonatomic) long capturedWhiteStones;
@property (nonatomic) BOOL redrawBoardNeeded;
@property (nonatomic) BOOL whitePassed;
@property (nonatomic) BOOL blackPassed;
- (BOOL)isLegalMove:(int)rowValue andForColumnValue:(int)columnValue;
- (BOOL)isInBounds:(int)rowValue andForColumnValue:(int)columnValue;
- (BOOL)checkIfNodeHasBeenVisited:(NSMutableArray *)visitedNodeList
                      forRowValue:(int)rowValueToCheck
                andForColumnValue:(int)columnValueToCheck;
- (void)checkLifeOfAdjacentEnemyStones:(int)rowValue andForColumnValue:(int)columnValue;
- (void)checkLifeOfStone:(int)rowValue andForColumnValue:(int)columnValue;
- (void)killStones:(NSMutableArray *)stonesToKill;
- (void)back;
- (void)markStoneClusterAsDeadFor:(int)rowValue andForColumnValue:(int)columnValue andForColor:(NSString*)color;
- (void)playMoveAtRow:(int)row column:(int)column forColor:(NSString *)color;

@end
