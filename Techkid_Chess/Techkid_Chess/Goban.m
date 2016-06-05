//
//  Goban.m
//  Go Game
//
//  Created by Hung Ga 123 on 5/25/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "Goban.h"
#import "GameConstants.h"
@implementation Goban

+ (NSMutableArray *)boardRow {
    return [NSMutableArray arrayWithObjects:GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            GobanEmptySpotString,
            nil];
}

+ (NSMutableArray *)emptyMutableBoardArray {
    return [NSMutableArray arrayWithObjects:[Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            [Goban boardRow],
            nil];
    
}

+ (void)printBoardToConsole:(NSArray *)goban {
    NSMutableString *printGobanString = [[NSMutableString alloc] init];
    [printGobanString appendString:@"\n"];
    for(int i = 0 ; i < GobanColumnLength; i++) {
        for(int j=0; j < GobanRowLength; j++) {
            [printGobanString appendString:goban[j][i]];
            [printGobanString appendString:@" "];
        }
        [printGobanString appendString:@"\n"];
    }
    
    NSLog(@"%@", printGobanString);
}


@end
