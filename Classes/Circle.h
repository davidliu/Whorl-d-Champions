//
//  Circle.h
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


#import <Foundation/Foundation.h>

#import "State.h"


@interface Circle : NSObject {
	double x;
	double y;
	NSTimeInterval lastChange;
	NSTimeInterval lastUpdate;
	NSTimeInterval nextChange;
	double xVelocity;
	double xAccel;
	double yVelocity;
	double yAccel;
	
	double velocity;
	double radians;
	double angleAccel;
	
	State state;
    
    CGFloat radius;
    
    NSTimeInterval dyingStart;
    
    float alpha;
    
    CGRect boardBounds;
}

@property (assign) double x;
@property (assign) double y;
@property (assign) State state;
@property (assign) double velocity;

@property (readonly) CGFloat radius;
@property (readonly) float alpha;

-(void)newPath;
-(void)update:(NSTimeInterval)now;
-(double)distanceToSquared:(double)x :(double)y;
-(BOOL)isTouched:(NSArray *)arrayOfLocations inView:(UIView*)view;   // Returns whether touched or not.

- (id)initWithBoardBounds:(CGRect)boardBounds;

@end
