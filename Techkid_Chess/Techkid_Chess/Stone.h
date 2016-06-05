//
//  Stone.h
//  Go Game
//
//  Created by Hung Ga 123 on 5/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stone : NSObject
@property (nonatomic, readonly) int row;
@property (nonatomic, readonly) int column;
- (instancetype)initWithWithRow:(int)row column:(int)column;
@end
