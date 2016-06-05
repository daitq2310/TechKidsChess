//
//  Goban.h
//  Go Game
//
//  Created by Hung Ga 123 on 5/25/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goban : NSObject
+ (void)printBoardToConsole:(NSArray *)goban;
+ (NSMutableArray *)emptyMutableBoardArray;

@end
