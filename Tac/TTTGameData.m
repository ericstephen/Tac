//
//  TTTGameData.m
//  Tac
//
//  Created by Eric Williams on 8/28/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "TTTGameData.h"
#import "TTTTouchSpot.h"
#import "TTTScoreView.h"


@implementation TTTGameData
{
    NSArray * possibilities;
    TTTScoreView * scoreView;
}

+ (TTTGameData *)mainData
{
    static dispatch_once_t onceToken;
    static TTTGameData * singleton = nil;
    
    dispatch_once(&onceToken, ^{
        
        singleton = [[TTTGameData alloc]init];
        
    });
    
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.spots = [@[]mutableCopy];
        self.player1Turn = YES;
        
        possibilities = @[
                          @[@0,@1,@2],
                          @[@3,@4,@5],
                          @[@6,@7,@8],
                          @[@0,@3,@6],
                          @[@1,@4,@7],
                          @[@2,@5,@8],
                          @[@0,@4,@8],
                          @[@2,@4,@6]
                          ];
        
        _playerWins = 0;
        _playerLosses = 0;
        _playerDraws = 0;
    }
    return self;
}

-(void)setPlayer1Turn:(BOOL)player1Turn
{
    _player1Turn = player1Turn;
    
    if (player1Turn == 0)
    {
        [self robotChooseSpot];
    }
}

- (void)robotChooseSpot
{
    
    if ([self findWinningSpot])
    {
        self.player1Turn = !self.player1Turn;
        [self checkForWinner];
        return;
    }
    
    if ([self findBlockingSpot])
    {
        self.player1Turn = !self.player1Turn;
        [self checkForWinner];
        return;
    }
    
    for (TTTTouchSpot * spot in self.spots)
    {
        if (spot.player == 0)
        {
            spot.player = 2;
            
            self.player1Turn = !self.player1Turn;
            
            [self checkForWinner];
            
            return;
        }
        
    }
}


-(BOOL)findWinningSpot
{
    for (NSArray * possibility in possibilities)
    {
        if([self checkForSpotWithSpots:possibility player:2]) return YES;
        
        NSArray * possibility2 = @[possibility[2],possibility[0],possibility[1]];
        if([self checkForSpotWithSpots:possibility2 player:2]) return YES;
        
        NSArray * possibility3 = @[possibility[1],possibility[2],possibility[0]];
        if([self checkForSpotWithSpots:possibility3 player:2]) return YES;
    }
    return NO;
    
}


-(BOOL)findBlockingSpot
{
    for (NSArray * possibility in possibilities)
    {
        if([self checkForSpotWithSpots:possibility player:1]) return YES;
        
        NSArray * possibility2 = @[possibility[2],possibility[0],possibility[1]];
        if([self checkForSpotWithSpots:possibility2 player:1]) return YES;
        
        NSArray * possibility3 = @[possibility[1],possibility[2],possibility[0]];
        if([self checkForSpotWithSpots:possibility3 player:1]) return YES;
    }
    return NO;
}

-(BOOL)checkForSpotWithSpots:(NSArray *)spots player:(int)player
{
    TTTTouchSpot * spot0 = self.spots[[spots [ 0 ] intValue]];
    TTTTouchSpot * spot1 = self.spots[[spots [ 1 ] intValue]];
    TTTTouchSpot * spot2 = self.spots[[spots [ 2 ] intValue]];
    
    if (spot0.player == player && spot1.player == player && spot2.player == 0)
    {
        spot2.player = 2;
        return YES;
    }
    return NO;
}

-(void)checkForWinner
{
    
    BOOL winner = NO;
    
    // Just to see if there is a winner
    for (NSArray * possibility in possibilities)
    {
        TTTTouchSpot * spot0 = self.spots[[possibility [ 0 ] intValue]];
        TTTTouchSpot * spot1 = self.spots[[possibility [ 1 ] intValue]];
        TTTTouchSpot * spot2 = self.spots[[possibility [ 2 ] intValue]];
        
        if (spot0.player == spot1.player && spot1.player == spot2.player && spot0.player != 0)
        {
            winner = YES;
            NSLog (@"player %d won", spot0.player);
            
            if (spot0.player == 1)
            {
                [self showCurrentGameResults:@"you win!"];

                _playerWins++;
                
            } else {
                
                [self showCurrentGameResults:@"you lose!"];

                _playerLosses++;
            }
            return;
        }
    }
    
    // Ok so if we do NOT have a winner, then check if it's a draw (no more spots to click)
    int emptySpots = 0;
    
    for (TTTTouchSpot * spot in self.spots)
        if (spot.player == 0)
            emptySpots++;
    
    if (emptySpots == 0 && !winner)
    {
        [self showCurrentGameResults:@"draw!"];
        
        _playerDraws++;
        
    }
}


- (void)showCurrentGameResults:(NSString *)message
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Completed Game" object:message];

}

- (void)resetGame
{
    self.player1Turn = YES;
    
    for (TTTTouchSpot * spot in self.spots) {
        spot.player = 0;
    }
}

@end
