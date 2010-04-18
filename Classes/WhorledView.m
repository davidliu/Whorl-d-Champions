//
//  WhorledView.m
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
#import "WhorledAppDelegate.h"
#import "WhorledView.h"
#import "Group.h"
#import "Circle.h"
#import "PlayerColors.h"

@implementation WhorledView

@synthesize listOfGroups;
@synthesize playing;

- (id)initWithFrame:(CGRect)frame numberOfPlayers:(NSUInteger)numberOfPlayers {
    if ((self = [super initWithFrame:frame])) {
        self.multipleTouchEnabled = YES;
    
        // Initialization code
		listOfGroups = [[NSMutableArray alloc] init];
		numPlayers = numberOfPlayers;
		for(int i = 0; i < numberOfPlayers; i++){
			Group * group = [[Group alloc] initWithBoardBounds:self.bounds];
            group.color = [PlayerColors colorAtIndex:i];

			[listOfGroups addObject:group];
		}
		lastSpeedUp = -1;
		speedUpTimer = 5;
		self.playing = NO;
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[self layer] renderInContext:context];
	
    //
	// Erase old circles
    //
    
    CGContextSetAlpha(context, 1.0);


    [[UIColor whiteColor] setFill];
	
	for(Group * group in listOfGroups){
		for(Circle * circle in group.listOfCircles){
            CGFloat radius = circle.radius;
            
            // To be sure we get rid of all artifacts, draw a rectangle larger than original circle
            CGContextFillRect(context, CGRectMake(circle.x - radius/2 -2, circle.y - radius/2 -2, radius +4, radius +4));
			CGContextFillPath(context);
		}
	}
	
    //
	// Calculate and apply speedup
    //

	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	
	if(playing){
		if(lastSpeedUp < 0){
			lastSpeedUp = now;
		}
		
		if((now - lastSpeedUp) > speedUpTimer){
			lastSpeedUp = now;
			speedUpTimer *= 0.9;
			for(Group * group in listOfGroups){
				for(Circle * circle in group.listOfCircles){
					circle.velocity += 50; 
				}
			}
		}
	}
	
    //
	// Draw new circles
    //

	for(Group * group in listOfGroups){
        [group.color setStroke];
        [group.color setFill];
        if(playing && group.state != isDead){
            [group update:now];
		}
        
		if(group.state != isDead){
			for(Circle * circle in group.listOfCircles){
                CGFloat radius = circle.radius;
                
                CGContextSetAlpha(context, circle.alpha);

				// Draw them with a 2.0 stroke width so they are a bit more visible.
				CGContextSetLineWidth(context, 2.0);
				
				// Add an ellipse circumscribed in the given rect to the current path, then stroke it
				CGContextAddEllipseInRect(context, CGRectMake(circle.x - radius/2, circle.y - radius/2, radius, radius));
				CGContextStrokePath(context);
				
				if([circle isTouched:[[lastEvent allTouches]allObjects]  inView:self]){
					CGContextFillEllipseInRect(context, CGRectMake(circle.x - radius/2, circle.y - radius/2, radius, radius));
					CGContextStrokePath(context);
				} else if(playing) {
					group.state = isDying;
				}
			}
		}
	}

    [self checkStopPlaying];				
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
	if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
	if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
    if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
	}
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	lastEvent = event;
    if(!playing){
		[self setNeedsDisplay];
		[self checkStartPlaying];
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
        WhorledAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate startDrawAnimation];
    }
}

-(void)checkStopPlaying{
	
	int aliveCount = 0;
	Group * aliveGroup;
	for(Group * group in listOfGroups){
		if(group.state == isAlive){
			aliveCount++;
			aliveGroup = group;
		}
	}
	
	if(aliveCount == 0 && numPlayers == 1){
		WhorledAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate stopDrawAnimation];
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

		[alert show];
		[alert autorelease];
	}
	
	if(aliveCount == 1 && numPlayers > 1){
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
