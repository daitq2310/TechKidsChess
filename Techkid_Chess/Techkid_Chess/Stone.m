//
//  Stone.m
//  Go Game
//
//  Created by Hung Ga 123 on 5/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "Stone.h"

@implementation Stone
- (instancetype)initWithWithRow:(int)row column:(int)column {
    if (self = [super init]) {
        _row = row;
        _column = column;
    }
    return self;
}
@end
