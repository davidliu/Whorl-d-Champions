//
//  Circle.m
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



#import "Circle.h"

#import "WhorledAppDelegate.h"
#import "Group.h"

#define PI 3.14159265358979

@implementation Circle

@synthesize x,y;
@synthesize state;
@synthesize velocity;

@synthesize radius;
@synthesize alpha;

-(id)initWithBoardBounds:(CGRect)boardBounds{
	[super init];
	x = arc4random() % 750 + 9;
	y = arc4random() % 1000 + 9;
	
	// xy
	xVelocity = 0;
	yVelocity = 0;
	
	// angle
	velocity = 400.0;
	radians = (arc4random() % 360) / 360.0 * 2 * PI;
	
	self.state = isAlive;
    
    radius = 60.0;

	[self newPath];
	lastUpdate = lastChange;
    
    alpha = 1.0;
    
	return self;
}

-(void)newPath{
	nextChange = lastChange + 2.0 + ((arc4random() % 100) / 100.0);
	
	//NSLog(@"new path");
	// xy
	double oldXVelo = xVelocity;
	double oldYVelo = yVelocity;
	double newXVelo = (arc4random() % 201) - 100.0;
	double newYVelo = (arc4random() % 201) - 100.0;
	
		// accelTime = 50% to 100% of time till next change
	double accelTime = (nextChange - lastChange) * (((arc4random() % 20) / 40) + 0.5);
	xAccel = (newXVelo - oldXVelo)/accelTime;
	yAccel = (newYVelo - oldYVelo)/accelTime;

	
	// angle
	double newRadians = (arc4random() % 360) / 360.0 * 2 * PI;
	double radianChange = (newRadians - radians);
	
	if(radianChange > PI / 2){
		radianChange = PI / 2;
	}
	
	if(radianChange < -PI / 2){
		radianChange = -PI / 2;
	}
	double angleAccelTime = 0.5; //(nextChange - lastChange) * (((arc4random() % 20) / 40.0) + 0.5);
	angleAccel =  radianChange / angleAccelTime;
	//NSLog(@"angleAccel = %g", angleAccel);

}

- (void)updateAlive:(NSTimeInterval)now{
//individual movement here
	/*
	int offsetX = (arc4random() % 3) - 1;
	int offsetY = (arc4random() % 3) - 1;
	
	x += offsetX;
	y += offsetY;
	 */
	
	// calculate delta since last update
	NSTimeInterval delta = now - lastUpdate;
	lastUpdate = now;
	
	// Calculate how much of path we need to move
	
	float percent = delta / (nextChange - lastChange);
	if(percent > 1){
		percent = 0;
	}
	
	/*
	//NSLog(@"percent = %g, delta = %g, nextChange = %f, lastChange = %f, next-last=%f", percent, delta, nextChange, lastChange, (nextChange-lastChange));
	// change that much percent.
	xVelocity += xAccel * percent;
	if(xVelocity > 200.0){
		xVelocity = 100.0;
	}
	
	yVelocity += yAccel * percent;
	if(yVelocity > 200.0){
		yVelocity = 100.0;
	}
	x += xVelocity * percent;
	y += yVelocity * percent;
	
	//NSLog(@"x = %g, xvelocity = %g, xAccel = %g, y = %g, yvelocity = %g, yAccel = %g", x, xVelocity, xAccel, y, yVelocity, yAccel);
	if(x < 5 && xVelocity < 0){
		xVelocity *= -1;
		if(xAccel < 0){
			xAccel *= -1;
		}
	}
	else if(x > 763 && xVelocity > 0){
		xVelocity *= -1;
		if(xAccel > 0){
			xAccel *= -1;
		}
	}
	
	if(y < 5 && yVelocity < 0){
		yVelocity *= -1;
		if(yAccel < 0){
			yAccel *= -1;
		}
	}
	else if(y > 1019 && yVelocity > 0){
		yVelocity *= -1;
		if(yAccel > 0){
			yAccel *= -1;
		}
	}
	if(now > nextChange){
		lastChange = now;
		[self newPath];		
	}*/
	
	//NSLog(@"Radians = %g, x = %g, y = %g", radians, x, y );
	radians += angleAccel * percent;
	
	double xVelo = velocity * cos(radians);
	double yVelo = velocity * sin(radians);
	
	x += xVelo * percent;
	y += yVelo * percent;
	
	//NSLog(@"now = %f, nextChange = %f", now, nextChange);
	
	if(now > nextChange){
		lastChange = now;
		[self newPath];		
	}
	
	if(radians < 0){
		radians += 2 * PI;
	}
	if(radians > 2*PI){
		radians -= 2 * PI;
	}
	
	if(x < 5 && radians > (PI / 2) && radians < 3 * PI/2){
		double diff = PI/2 - radians;
		radians = PI/2 + diff;
		
		if(radians < 0){
			radians += 2 * PI;
		}
		if(radians > 2*PI){
			radians -= 2 * PI;
		}
	}
	else if(x > 763 && (radians < PI / 2 || radians > 3 *PI/2)){
		double diff = PI/2 - radians;
		radians = PI/2  + diff;
		
		if(radians < 0){
			radians += 2 * PI;
		}
		if(radians > 2*PI){
			radians -= 2 * PI;
		}
	}
	
	if(y > 1000 && radians > 0 && radians < PI){
		double diff = PI - radians;
		radians = PI + diff;
		
		if(radians < 0){
			radians += 2 * PI;
		}
		if(radians > 2*PI){
			radians -= 2 * PI;
		}
	}
	else if(y < 20 && radians < 2 * PI && radians > PI){
		double diff = PI - radians;
		radians = PI  + diff;
		
		if(radians < 0){
			radians += 2 * PI;
		}
		if(radians > 2*PI){
			radians -= 2 * PI;
		}
	}
}

- (void)setState:(State)newState {
    if (newState != state) {
        if (newState == isDying) {
            dyingStart = [[NSDate date] timeIntervalSince1970];
        }
    
        state = newState;
    }
}

-(void)update:(NSTimeInterval)now{
    switch (self.state) {
        case isAlive:
            [self updateAlive:now];
            break;
        case isDying: {
            float delta = (now - dyingStart) / [Group dyingInterval];
            
            radius = 60.0 + 200 * delta;
            
            alpha = 1.0 - delta;
        }
            break;
        case isDead:
            // Can't do nuthin', yer dead!
            break;
    }
}

-(BOOL)isTouched:(NSArray *)arrayOfLocations inView:(UIView*) view{
	for(UITouch * touch in arrayOfLocations){
		CGPoint point = [touch locationInView:view];
		if([self distanceToSquared:point.x :point.y] < 8100)
		{
			return YES;
		}
	}
	return NO;
}

-(double)distanceToSquared:(double)x2 :(double)y2{
	double xt = x - x2;
	double yt = y - y2;
	return xt*xt + yt*yt;
	
}

@end
