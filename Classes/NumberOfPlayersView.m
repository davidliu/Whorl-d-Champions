//
//  NumberOfPlayersView.m
//  Whorled
//
//  Created by Andrew Pontious on 4/17/10.
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



#import "NumberOfPlayersView.h"

#import "PlayerColors.h"


@implementation NumberOfPlayersView

@synthesize numberOfPlayers;
@synthesize previousNumberOfPlayers;

- (void)numberOfPlayersViewInit {
    self.contentMode = UIViewContentModeRedraw;
}

- (id)init {
    self = [super init];
    
    [self numberOfPlayersViewInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [self numberOfPlayersViewInit];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self numberOfPlayersViewInit];
    }
    return self;
}

#undef FRAME_TEST

#define CIRCLE_COUNT        10
#define LINE_WIDTH         5.0
#define POINT_SIZE        24.0

- (void)drawRect:(CGRect)rect {
    const CGRect bounds = [self bounds];
        
    [[UIColor blackColor] setStroke];
#ifdef FRAME_TEST
    UIBezierPath *frame = [UIBezierPath bezierPathWithRect:bounds];
    [frame stroke];
#endif
    const CGFloat radius = bounds.size.height;
    
    const CGFloat divisibleWidth = bounds.size.width - radius;
    
    const CGFloat spacing = divisibleWidth/(CIRCLE_COUNT-1);

    for (NSUInteger i = 0; i < CIRCLE_COUNT; ++i) {
    
        if (i < self.numberOfPlayers) {
            CGFloat x = i * spacing;
            CGFloat y = 0.0;
            CGFloat width = radius;
            CGFloat height = radius;
        
            CGRect rect = CGRectMake(x, y, width, height);
        
            UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
            
            [[PlayerColors colorAtIndex:i] setFill];
            
            [circle fill];
        } else {
            // Draw circle
            CGFloat x = i * spacing + LINE_WIDTH / 2;
            CGFloat y = LINE_WIDTH / 2;
            CGFloat width = radius - (LINE_WIDTH);
            CGFloat height = radius - (LINE_WIDTH);
        
            CGRect rect = CGRectMake(x, y, width, height);
        
            UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:rect];
            
            circle.lineWidth = LINE_WIDTH;
        
            [circle stroke];

            // Draw text
            CGContextRef ctx = UIGraphicsGetCurrentContext();

            NSString *number = [NSString stringWithFormat:@"%lu", (unsigned long)(i+1)];
            CGContextSelectFont(ctx, "Helvetica", 24.0, kCGEncodingMacRoman);
            CGContextSetTextDrawingMode(ctx, kCGTextFill);
            CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);
 
            CGAffineTransform xform = CGAffineTransformMake(
                    1.0,  0.0,
                    0.0, -1.0,
                    0.0,  0.0);
            CGContextSetTextMatrix(ctx, xform);
 
            CGContextShowTextAtPoint(ctx, 
                                     x + ((radius - POINT_SIZE) / 2), 
                                     y + (radius/* + POINT_SIZE*/) / 2, 
                                     [number UTF8String], 
                                     strlen([number UTF8String]));
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGRect bounds = [self bounds];

    const CGFloat radius = bounds.size.height;
    
    const CGFloat divisibleWidth = bounds.size.width - radius;
    
    const CGFloat spacing = divisibleWidth/(CIRCLE_COUNT-1);

    NSUInteger newNumberOfPlayers = 0;

    for (UITouch *touch in [event touchesForView:self]) {
        CGPoint touchPoint = [touch locationInView:self];

        for (NSUInteger i = 0; i < CIRCLE_COUNT; ++i) {
        
            CGFloat x = i * spacing;
            CGFloat y = 0.0;
            CGFloat width = radius;
            CGFloat height = radius;

            CGRect rect = CGRectMake(x, y, width, height);
            
            if (touchPoint.x >= rect.origin.x && touchPoint.y >= rect.origin.y &&
                touchPoint.x <= rect.origin.x + rect.size.width &&
                touchPoint.y <= rect.origin.y + rect.size.height) {

                if (i + 1 > newNumberOfPlayers) {
                    newNumberOfPlayers = i + 1;
                }

                break;
            }
        }
    }
    
    if (newNumberOfPlayers > 0) {
        numberOfPlayers = newNumberOfPlayers;
        
        // TODO localize
        numberOfPlayersTextField.text = [NSString stringWithFormat:@"Number of Players: %lu", (unsigned long)numberOfPlayers];
        
        startWorldInMotionButton.enabled = YES;
        startTwistedWorldButton.enabled = YES;
        
        [self setNeedsDisplay];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


- (void)dealloc {
    [super dealloc];
}


@end
