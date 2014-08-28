//
//  TTTViewController.m
//  Tac
//
//  Created by Eric Williams on 7/29/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "TTTViewController.h"
#import "TTTTouchSpot.h"
#import "TTTGameData.h"


@interface TTTViewController () <UIAlertViewDelegate>

@end

@implementation TTTViewController

{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int spotWH = 80;
    
    int padding = 20;
    
    int gridWH = (spotWH * 3) + (padding * 2);
    
    float spacingW = (SCREEN_WIDTH - gridWH) / 2;
    
    float spacingH = (SCREEN_HEIGHT - gridWH) / 4;
    
    for (int row = 0; row < 3; row++)
    {
        // run for each row
        for (int col = 0; col < 3; col++)
        {
            // run for each col in each row
            int x = (spotWH + padding) * col + spacingW;
            
            int y = (spotWH + padding) * row + spacingH;
        
            TTTTouchSpot * spot = [[TTTTouchSpot alloc]initWithFrame:CGRectMake(x, y, spotWH, spotWH)];
            
            spot.player = 0;
            
            spot.layer.cornerRadius = (spotWH / 5);
            
            [self.view addSubview: spot];
            
            [[TTTGameData mainData].spots addObject: spot];
            
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"touched");
    
    UITouch * touch = [touches allObjects ][0];
    
    // NSLog(@"%d", spots.count);
    
    int spotWH = 80;
    
    for (TTTTouchSpot * spot in [TTTGameData mainData].spots)
    {
        CGPoint location = [touch locationInView: spot];
        
        if (location.x >= 0 && location.y >=0)
            if (location.x <= spotWH && location.y <= spotWH)
            {
                
                // change to spot.player
                if (spot.player == 0)
                {
                    NSLog(@"%@", spot);
                    
//                    UIColor * color = (player1Turn) ? [UIColor greenColor] : [UIColor redColor];
                    
//                    spot.backgroundColor = color;
                    
                    spot.player = ([TTTGameData mainData].player1Turn) ? 1 : 2;
                    
                    [TTTGameData mainData].player1Turn = ![TTTGameData mainData].player1Turn;
                    
                    [[TTTGameData mainData] checkForWinner];
                    
                    // spot touched

                }
            }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (TTTTouchSpot * spot in [TTTGameData mainData].spots) {
        spot.player = 0;
    }
}

@end
