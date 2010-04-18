//
//  TwistedWhorledView.m
//  Whorled
//
//  Created by David Liu on 4/17/10.
//
// Copyright (c) 2010, Andrew Pontious, David Liu, Farn-Yu Khong
// All rights reserved.
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
// •	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// •	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// •	Neither the name of the Whorl'd Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <QuartzCore/QuartzCore.h>
#import "TwistedWhorledView.h"
#import "WhorledAppDelegate.h"
#import "Group.h"
#import "Circle.h"
#import "PlayerColors.h"
#define PI 3.14159265358979

@implementation TwistedWhorledView

@synthesize listOfGroups;
@synthesize playing;

- (id)initWithFrame:(CGRect)frame numberOfPlayers:(NSUInteger)numberOfPlayers {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		NSLog(@"initialize");
		[self setMultipleTouchEnabled:YES];
		listOfGroups = [[NSMutableArray alloc] init];
		numPlayers = numberOfPlayers;
		for(int i = 0; i < numberOfPlayers; i++){
			Group * group = [[Group alloc] initWithBoardBounds:self.bounds];
            group.color = [PlayerColors colorAtIndex:i];
			NSLog(@"initialize %d",i);
			[listOfGroups addObject:group];
		}
		
		for(Group *group in listOfGroups){
			for(Circle * circle in group.listOfCircles){
				if(circle.y > 700){
					circle.y /= 2;
				}
			}
		}
		self.playing = NO;
        self.backgroundColor = [UIColor whiteColor];
		
    }
    return self;
}


// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	NSLog(@"Playing = %d.", playing);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[self layer] renderInContext:context];
	
	// Erase color
    [[UIColor whiteColor] setFill];
	
	for(Group * group in listOfGroups){
		for(Circle * circle in group.listOfCircles){
            
            CGContextFillRect(context, CGRectMake(circle.x - 30 -2, circle.y - 30 -2, 60.0 +4, 60.0 +4));
			CGContextFillPath(context);
		}
	}
	
//	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	
	//NSLog(@"now = %f", now);
	for(Group * group in listOfGroups){
		
        [group.color setStroke];
        [group.color setFill];
        
		if([group isAlive]){
			for(int j = 0; j < group.listOfCircles.count; j++){
				Circle * circle = [group.listOfCircles objectAtIndex:j];
				// Draw them with a 2.0 stroke width so they are a bit more visible.
				CGContextSetLineWidth(context, 2.0);
				
				// Add an ellipse circumscribed in the given rect to the current path, then stroke it
				CGContextAddEllipseInRect(context, CGRectMake(circle.x - 30, circle.y - 30, 60.0, 60.0));
				CGContextStrokePath(context);
				
				if([circle isTouched:[[lastEvent allTouches]allObjects]  inView:self]){
					CGContextFillEllipseInRect(context, CGRectMake(circle.x - 30, circle.y - 30, 60.0, 60.0));
					CGContextStrokePath(context);
				}
				
				else if(playing){
					if(circle != currentCircle){
						circle.state = isDead;
						NSLog(@"circle is dead");
						
						if(group == currentGroup){
							
							// Count how many circles touched
							int touchCount = 0;
							for(Circle * countCircle in group.listOfCircles){
								if([countCircle isTouched:[[lastEvent allTouches]allObjects] inView:self]){
									touchCount++;
								}
							}
							
							
							if(touchCount >= (numCurrentCircles - liftMax - 1)){
								[group.listOfCircles removeObject:circle];
								j--;
								
								//Erase circle from game view
								
								[[UIColor whiteColor] setFill];
								CGContextFillRect(context, CGRectMake(circle.x - 30 -2, circle.y - 30 -2, 60.0 +4, 60.0 +4));
								CGContextFillPath(context);
								[group.color setFill];
							}
							else{
								[self nextTurn];
							}
						}
						[self checkStopPlaying];
					}
				}
			}
		}
	}
	if(playing && [currentCircle isTouched:[[lastEvent allTouches]allObjects] inView:self]){
		[self nextTurn];
	}
	
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
//	NSLog(@"Began");	
//	[self touchDistances:event];
	
	if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
//	NSLog(@"Moved");
//	[self touchDistances:event];

	if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
	
//	NSLog(@"Ended");
    if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
	
//	NSLog(@"Cancelled");
    if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchDistances:(UIEvent *)event{
	double xold = -1;
	double yold = -1;
	for(UITouch *touch in [[event allTouches] allObjects]){
		if(xold < 0){
			xold = [touch locationInView:self].x;
			yold = [touch locationInView:self].y;
			continue;
		}
		double xnew = [touch locationInView:self].x;
		double ynew = [touch locationInView:self].y;
		NSLog(@"Distance between touch = %g", sqrt( (xold-xnew)*(xold-xnew) + (yold-ynew) *(yold-ynew) ));
	}
}

-(void)checkStartPlaying{
	
	if(playing)
    {   return; }
    
    BOOL allTouched = YES;
    for(Group * group in listOfGroups){
        if(!allTouched){
            return;
        }
        for(Circle * circle in group.listOfCircles){
            if(![circle isTouched:[[lastEvent allTouches]allObjects] inView:self]){
				allTouched = NO;
            }
        }
    }
    if(allTouched){
		playing = YES;
		NSLog(@"Playing!");
        WhorledAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate startDrawAnimation];
		
		currentPlayer = arc4random() % numPlayers;
		[self nextTurn];
    }
}

-(void) nextTurn{
	NSLog(@"next turn");
	do
	{
		currentPlayer = (currentPlayer + 1) % numPlayers;
		int count = 0;
		for(Group* group in listOfGroups){
			if(count == currentPlayer){
				currentGroup = group;
				break;
			}
			count++;
		}
	}
	while(![currentGroup isAlive]);
	currentCircle = [self newCircleInGroup:currentGroup];
	[[currentGroup listOfCircles] addObject:currentCircle];
	
	if([[currentGroup listOfCircles] count] > [self maxCirclesPerPlayer]){
		liftMax = 1;
	}
	else{
		liftMax = 0;
	}
	numCurrentCircles = [[currentGroup listOfCircles] count];
	liftCount = 0;
	
}


-(int) alivePlayers{
	int count = 0;
	
	for(Group * group in listOfGroups){
		if([group isAlive]){
			count ++;
		}
	}
	return count;
}
-(int) maxCirclesPerPlayer{
	if(numPlayers > 10){
		return 0;
	}
	if(numPlayers > 5){
		return 1;
	}
	if(numPlayers >= 4){
		return 2;
	}
	if(numPlayers == 3){
		return 3;
	}
	if(numPlayers == 2){
		return 4;
	}
	return 8;
}


-(Circle*) newCircleInGroup:(Group*)group{
	
	// Find average xy point
	double xAvg = 0;
	double yAvg = 0;
	int count = 0;
	for(Circle * circle in group.listOfCircles){
		count++;
		xAvg += circle.x;
		yAvg += circle.y;
	}
	
	if(count == 0){
		return nil;
	}
	
	xAvg /= count;
	yAvg /= count;
	
	NSLog(@"xAvg = %g, yAvg= %g", xAvg, yAvg);
	
	double xNew = -1;
	double yNew = -1;
	while(xNew < 20 || xNew > 748 || yNew < 20 || yNew > 700){
		double length = arc4random() % 300;
		double radians = (arc4random() % 360) / 360.0 * 2 * PI;
		
		
		xNew = xAvg + length * cos(radians);
		yNew = xAvg + length * sin(radians);
		
		for(Group * otherGroup in listOfGroups){
			for(Circle* circle in otherGroup.listOfCircles){
				if([circle distanceToSquared:xNew :yNew] < 200*200){
					xNew = -1;
					yNew = -1;
				}
			}
		}
	}
	
	Circle* newCircle = [[Circle alloc]initWithBoardBounds:self.bounds];
	newCircle.x = xNew;
	newCircle.y = yNew;
	
	NSLog(@"new circle at %g, %g", xNew, yNew);
	return newCircle;

}

-(void)checkStopPlaying{
	NSLog(@"Check stop playing");
	int aliveCount = 0;
	Group * aliveGroup;
	for(Group * group in listOfGroups){
		if([group isAlive]){
			aliveCount++;
			aliveGroup = group;
		}
	}
	
	if(aliveCount == 0 && numPlayers == 1){
		playing = NO;
		WhorledAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate stopDrawAnimation];
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		[alert autorelease];
	}
	
	if(aliveCount == 1 && numPlayers > 1){
		playing = NO;
		WhorledAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate stopDrawAnimation];
		
		
		NSString * playerColor = @"Nocolor";
		if(aliveGroup.color == [PlayerColors colorAtIndex:0])
		{	playerColor = @"Red ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:1])
		{	playerColor = @"Green ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:2])
		{	playerColor = @"Blue ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:3])
		{	playerColor = @"Cyan ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:4])
		{	playerColor = @"Yellow ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:5])
		{	playerColor = @"Magenta ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:6])
		{	playerColor = @"Purple ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:7])
		{	playerColor = @"Brown ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:8])
		{	playerColor = @"Dark Gray ";	}
		if(aliveGroup.color == [PlayerColors colorAtIndex:9])
		{	playerColor = @"Light Gray ";	}
		
		playerColor = [playerColor stringByAppendingString:@"has won the game!"];
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:playerColor delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert autorelease];
	}
	
	
    
}

- (void)dealloc {
	[listOfGroups dealloc];
    [super dealloc];
}

@end
