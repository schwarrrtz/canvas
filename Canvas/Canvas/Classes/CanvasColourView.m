//
//  CanvasColourView.m
//  Canvas
//
//  Created by David Schwartz on 2014-01-12.
//  Copyright (c) 2014 Hybridity. All rights reserved.
//

#import "CanvasColourView.h"

@implementation CanvasColourView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        colour = [NSColor whiteColor];
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSColorPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard* pboard = [sender draggingPasteboard];
    NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
    
    if ([[pboard types] containsObject:NSColorPboardType])
    {
        if (sourceDragMask & NSDragOperationGeneric)
        {
            return NSDragOperationGeneric;
        }
    }
    
    return NSDragOperationNone;
}

- (BOOL) performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard* pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSColorPboardType])
    {
        colour = [NSColor colorFromPasteboard:pboard];
        [self setNeedsDisplay:YES];
    }
    
    return YES;
}

- (void)setBackgroundColour:(NSColor *)inputColour {
    colour = inputColour;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    /*
    // -- circles -- //
    [[NSColor grayColor] set];
    NSRectFill([self bounds]);
    NSRect inset = NSInsetRect([self bounds], 1.0f, 1.0f);
    NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:inset];
    [colour set];
    [circlePath fill];
    */
    
    // -- squares -- //
    [colour set];
    NSRectFill([self bounds]);
    
    [[NSColor blackColor] set];
    NSBezierPath *border = [NSBezierPath bezierPathWithRect:[self bounds]];
    [border setLineWidth:1.0f];
    [border stroke];
}

- (void)drawRect
{
    [self drawRect:[self bounds]];
}

@end
