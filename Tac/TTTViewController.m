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


@interface TTTViewController ()

@end

@implementation TTTViewController
{
    UIView * gameResult;
    UIButton * startButton;
    UILabel * gameResultLabel;
    UIView * statView;
    
    BOOL statsScreenDisplayed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        statsScreenDisplayed = NO;
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:@"Completed Game"
                            object:nil
                             queue: [NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification * notification)
         {
             [self showGameResult:notification.object];
         }];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createGameResultComponents];
    
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
    
    UIButton * statsButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    UIImage * statPic = [UIImage imageNamed:@"score"];
    statsButton.layer.borderColor = [UIColor blackColor].CGColor;
    statsButton.layer.borderWidth = 2;
    statsButton.layer.cornerRadius = 25;
    [statsButton setImage:statPic forState:UIControlStateNormal];
    [statsButton addTarget:self action:@selector(statsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:statsButton];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (statsScreenDisplayed == YES)
    {
        [statView removeFromSuperview];
        statsScreenDisplayed = NO;
        return;
        
    } else {
        
        UITouch * touch = [touches allObjects ][0];
        
        int spotWH = 80;
        
        
        for (TTTTouchSpot * spot in [TTTGameData mainData].spots)
        {
            CGPoint location = [touch locationInView: spot];
            
            if (location.x >= 0 && location.y >= 0)
                if (location.x <= spotWH && location.y <= spotWH)
                {
                    if (spot.player == 0)
                    {
                        NSLog(@"%@", spot);
                        
                        spot.player = ([TTTGameData mainData].player1Turn) ? 1 : 2;
                        
                        
                        [[TTTGameData mainData] checkForWinner];
                        
                        [TTTGameData mainData].player1Turn = ![TTTGameData mainData].player1Turn;
                        
                    }
                }
        }
    }
}

-(void)createGameResultComponents
{
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    gameResult = [[UIView alloc] initWithFrame:self.view.frame];
    gameResult.backgroundColor = [UIColor grayColor];
    gameResult.alpha = 0.90f;
    
    gameResultLabel = [[UILabel alloc]initWithFrame:CGRectMake((w - 300)/2, (h - 150)/2, 300, 150)];
    gameResultLabel.backgroundColor = [UIColor colorWithRed:0.176f green:0.345f blue:0.475f alpha:1.0f];
    gameResultLabel.layer.cornerRadius = 20;
    gameResultLabel.font = [UIFont fontWithName:@"Helvetica-light" size:48];
    gameResultLabel.textColor = [UIColor whiteColor];
    gameResultLabel.textAlignment = NSTextAlignmentCenter;
    gameResultLabel.layer.masksToBounds = YES;
    [gameResult addSubview:gameResultLabel];
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake((w-100)/2, 450, 100, 100)];
    startButton.backgroundColor = [UIColor colorWithRed:0.427f green:0.745f blue:0.227f alpha:1.0f];
    startButton.layer.cornerRadius = 50;
    [startButton setTitle:@"start" forState:UIControlStateNormal];
    startButton.titleLabel.textColor = [UIColor whiteColor];
    startButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-light" size:30];
    [startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)showGameResult:(NSString *)message
{
    if ([self.view.subviews containsObject:gameResult])
    {
        
    }
    else
    {
        NSLog(@"OK showing the game Result objects");
        [self.view addSubview:gameResult];
        [self.view addSubview:startButton];
    }
    gameResultLabel.text = message;
    
}

- (void)startButtonClicked
{
    [[TTTGameData mainData] resetGame];
    [gameResult removeFromSuperview];
    [startButton removeFromSuperview];
}

- (void)statsButtonClicked
{
    statsScreenDisplayed = YES;
    
    statView = [[UIView alloc] initWithFrame:self.view.frame];
    statView.backgroundColor = [UIColor grayColor];
    statView.alpha = 0.88f;
    
    [self.view addSubview:statView];
    
    
    UILabel * winRecord = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 80, 80)];
    winRecord.backgroundColor = [UIColor colorWithRed:0.427f green:0.745f blue:0.227f alpha:1.0f];
    winRecord.layer.cornerRadius = 40;
    winRecord.layer.masksToBounds = YES;
    
    winRecord.text = [NSString stringWithFormat:@"%d", [TTTGameData mainData].playerWins];
    winRecord.textAlignment = NSTextAlignmentCenter;
    winRecord.font = [UIFont fontWithName:@"Helvetica-light" size:36];
    winRecord.textColor = [UIColor whiteColor];
    
    [statView addSubview:winRecord];
    
    
    UILabel * lossRecord = [[UILabel alloc] initWithFrame:CGRectMake(120, 400, 80, 80)];
    lossRecord.backgroundColor = [UIColor colorWithRed:0.749f green:0.169f blue:0.224f alpha:1.0f];
    lossRecord.layer.cornerRadius = 40;
    lossRecord.layer.masksToBounds = YES;
    
    lossRecord.text = [NSString stringWithFormat:@"%d", [TTTGameData mainData].playerLosses];
    lossRecord.textAlignment = NSTextAlignmentCenter;
    lossRecord.font = [UIFont fontWithName:@"Helvetica-light" size:36];
    lossRecord.textColor = [UIColor whiteColor];
    
    [statView addSubview:lossRecord];
    
    
    UILabel * drawRecord = [[UILabel alloc] initWithFrame:CGRectMake(220, 400, 80, 80)];
    drawRecord.backgroundColor = [UIColor colorWithRed:0.220f green:0.525f blue:0.784f alpha:1.0f];
    drawRecord.layer.cornerRadius = 40;
    drawRecord.layer.masksToBounds = YES;
    
    drawRecord.text = [NSString stringWithFormat:@"%d", [TTTGameData mainData].playerDraws];
    drawRecord.textAlignment = NSTextAlignmentCenter;
    drawRecord.font = [UIFont fontWithName:@"Helvetica-light" size:36];
    drawRecord.textColor = [UIColor whiteColor];
    
    [statView addSubview:drawRecord];
}

- (BOOL)prefersStatusBarHidden { return YES; }

@end
