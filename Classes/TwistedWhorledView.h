//
//  TwistedWhorledView.h
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


#import <UIKit/UIKit.h>

@class Circle, Group;
@interface TwistedWhorledView : UIView {
	NSMutableArray * listOfGroups;
	UIEvent * lastEvent;
	NSInteger numPlayers;
	NSTimeInterval lastSpeedUp;
	double speedUpTimer;
    BOOL playing;
	
	Circle * currentCircle;
	Group * currentGroup;
	NSInteger currentPlayer;
	NSInteger numCurrentCircles;
	NSInteger liftCount;
	NSInteger liftMax;
}

@property(nonatomic,retain) NSMutableArray * listOfGroups;
@property(assign) BOOL playing;

-(void)checkStartPlaying;
-(void)checkStopPlaying;

-(void) nextTurn;
-(int) alivePlayers;
-(int) maxCirclesPerPlayer;
-(Circle *) newCircleInGroup:(Group *)group;
- (id)initWithFrame:(CGRect)frame numberOfPlayers:(NSUInteger)numberOfPlayers;

@end
