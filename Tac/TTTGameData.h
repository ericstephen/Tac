//
//  TTTGameData.h
//  Tac
//
//  Created by Eric Williams on 8/28/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTGameData : NSObject

+ (TTTGameData *)mainData;

-(void)checkForWinner;

@property (nonatomic) NSMutableArray * spots;

@property (nonatomic) BOOL player1Turn;

@end
