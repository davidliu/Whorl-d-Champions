//
//  WhorledAppDelegate.m
//  Whorled
//
//  Created by David Liu on 4/16/10.
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


#import "WhorledAppDelegate.h"
#import "WhorledViewController.h"
#import "WhorledView.h"
#import "TwistedWhorledView.h"
#import <QuartzCore/QuartzCore.h>

#define kArcLayerAnimationKey @"kArcLayerAnimationKey"

@implementation WhorledAppDelegate

@synthesize window;
@synthesize viewController;

@synthesize numberOfPlayers;


- (void)startWorldInMotionWithPlayerCount:(NSUInteger)playerCount {
	
	self.numberOfPlayers = playerCount;
	
	whorledView = [[WhorledView alloc] initWithFrame:CGRectMake(0, 0, 768,1024) numberOfPlayers:self.numberOfPlayers];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
    
	[window addSubview:whorledView];
	[UIView commitAnimations];

	[window makeKeyAndVisible];
}

- (void)startTwistedWorldWithPlayerCount:(NSUInteger)playerCount {
	
	self.numberOfPlayers = playerCount;
	
	twistedWorldView = [[TwistedWhorledView alloc] initWithFrame:CGRectMake(0, 0, 768,1024) numberOfPlayers:self.numberOfPlayers];

	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:window cache:YES];
	
	[window addSubview:twistedWorldView];
	[UIView commitAnimations];

	[window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
	return YES;
}

-(void) drawAgain{
	NSLog(@"drawagain");
	if (whorledView != nil) {
		NSLog(@"whorled drawing");
        [whorledView setNeedsDisplay];
    } else {
 		NSLog(@"twisted whorled drawing");
		[twistedWorldView setNeedsDisplay];
    }
}

-(IBAction) startDrawAnimation{
	[self stopDrawAnimation];
	startDrawArcAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(drawAgain) userInfo:nil repeats:YES];
	
	NSLog(@"start");
}

-(IBAction) stopDrawAnimation{
	NSLog(@"Stopped");
	[[whorledView layer] removeAnimationForKey:kArcLayerAnimationKey];
}



- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
