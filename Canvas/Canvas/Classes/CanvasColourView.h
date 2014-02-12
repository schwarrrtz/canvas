//
//  CanvasColourView.h
//  Canvas
//
//  Created by David Schwartz on 2014-01-12.
//  Copyright (c) 2014 Hybridity. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CanvasColourViewDelegate <NSObject>

@end

@interface CanvasColourView : NSView <NSDraggingDestination>
{
    NSColor *colour;
}

- (void)setBackgroundColour:(NSColor *)inputColour;
- (void)drawRect;

@end
