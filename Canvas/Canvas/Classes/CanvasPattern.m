//
//  CanvasPattern.m
//  Canvas
//
//  Created by David Schwartz on 2014-01-12.
//  Copyright (c) 2014 Hybridity. All rights reserved.
//

#import "CanvasPattern.h"

@implementation CanvasPattern

- (id)init
{
    self = [self initWithWidth:0 Height:0 Length:0];
    return self;
}

- (id)initWithWidth:(int)_width Height:(int)_height Length:(int)_length
{
    self = [super init];
    if (self) {
        width = _width;
        height = _height;
        length = _length;
        pixelArray = calloc(width*height*length, sizeof(CanvasPixel)); // set all black
    }
    return self;
}

- (id)initWithData:(NSData *)_data
{
    NSAssert(_data != nil, @"DATA IS NIL AGHHHH");
    
    int* prefixBuffer = malloc(3 * sizeof(int));
    [_data getBytes:prefixBuffer length:3 * sizeof(int)];
    self = [self initWithWidth:prefixBuffer[0] Height:prefixBuffer[1] Length:prefixBuffer[2]];
    free(prefixBuffer);
    
    NSRange pixelDataRange = {.location = 3 * sizeof(int), .length = width * height * length * sizeof(CanvasPixel)};
    double* buffer = malloc(width * height * length * sizeof(CanvasPixel));
    [_data getBytes:buffer range:pixelDataRange];
    
    for (int t = 0; t < length; t++)
    {
        for(int y = 0; y < height; y++)
        {
            for (int x = 0; x < width; x++)
            {
                int currentRedIndex = 3 * (width * height * t + width * y + x);
                int currentGreenIndex = currentRedIndex + 1;
                int currentBlueIndex = currentGreenIndex + 1;
                
                NSColor* currentColour = [NSColor colorWithCalibratedRed:buffer[currentRedIndex] green:buffer[currentGreenIndex] blue:buffer[currentBlueIndex] alpha:1.0f];
                
                [self setColour:currentColour AtLocationX:x LocationY:y Time:t];
            }
        }
    }
    free(buffer);
    
    return self;
}

-(NSData*)convertPatternToData
{
    int bufferLength = 3 * sizeof(int) + width * height * length * sizeof(CanvasPixel);
    void* buffer = malloc(bufferLength);
    int prefix [3] = {width, height, length};
    memcpy(buffer, prefix, 3 * sizeof(int));
    memcpy(buffer + 3 * sizeof(int), pixelArray, width * height * length * sizeof(CanvasPixel));
    
    NSData* patternData = [[NSData alloc] initWithBytes:buffer length:bufferLength];
    free(buffer);
    return patternData;
}

-(void)setColour:(NSColor *)colour AtLocationX:(int)x LocationY:(int)y Time:(int)t
{
    if ((x >= width) || (y >= height) || (t >= length))
    {
        NSLog(@"CanvasPattern setColour: location out of bounds");
    }
    else
    {
        // get components of input colour
        double red, green, blue;
        [colour getRed:&red green:&green blue:&blue alpha:NULL];
        
        // store new pixel
        CanvasPixel newPixel = { .r = red, .g = green, .b = blue };
        int index = width * height * t + width * y + x;
        pixelArray[index] = newPixel;
    }
}

- (NSColor*)getColourAtLocationX:(int)x LocationY:(int)y Time:(int)t
{
    if ((x >= width) || (y >= height) || (t >= length))
    {
        NSLog(@"CanvasPattern getColour: location out of bounds");
        return nil;
    }
    else
    {
        int index = width * height * t + width * y + x;
        CanvasPixel pixel = pixelArray[index];
        return [NSColor colorWithCalibratedRed:pixel.r green:pixel.g blue:pixel.b alpha:1.0f];
    }
}

- (void)dealloc
{
    free(pixelArray);
}

@end