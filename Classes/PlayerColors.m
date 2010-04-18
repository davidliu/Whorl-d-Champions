//
//  PlayerColors.m
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


#import "PlayerColors.h"

@implementation PlayerColors

#define COLOR_COUNT     10

+ (UIColor *)colorAtIndex:(NSUInteger)index {
    static UIColor *colors[COLOR_COUNT] = {0};
    if (colors[0] == nil) {
        colors[0] = [UIColor redColor];
        colors[1] = [UIColor greenColor];
        colors[2] = [UIColor blueColor];
        colors[3] = [UIColor cyanColor];
        colors[4] = [UIColor yellowColor];
        colors[5] = [UIColor magentaColor];
        colors[6] = [UIColor purpleColor];
        colors[7] = [UIColor brownColor];
        colors[8] = [UIColor darkGrayColor];
        colors[9] = [UIColor lightGrayColor];
    };

    if (index >= COLOR_COUNT) {
        [NSException raise:@"PlayerColorsException" format:@"Color at index %lu requested, but only %lu colors available!", (unsigned long)index, (unsigned long)COLOR_COUNT];;
    }
    
    return colors[index];
}

@end
