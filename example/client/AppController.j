/*
 * AppController.j
 * client
 *
 * Created by Saikat Chakrabarti on September 1, 2010.
 * Copyright 2010, Saikat Chakrabarti All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <SCSocket/SCSocket.j>
@import <LPKit/LPMultiLineTextField.j>

@implementation SocketMultilineTextField : LPMultiLineTextField
{ 
    SCSocket theSocket @accessors;
}

// NOTE: I wouldn't recommend actually logging every single key press from an application.
// This just makes for a cool demo.
- (void)keyDown:(CPEvent)anEvent
{
    [super keyDown:anEvent];
    [theSocket sendMessage:{'c' : [anEvent characters]}];
}
@end

@implementation AppController : CPObject
{
    SCSocket theSocket;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    theSocket = [[SCSocket alloc] initWithURL:[CPURL URLWithString:"http://localhost:8080"] delegate:self];
    [theSocket connect];
}

- (void)socketDidConnect:(SCSocket)aSocket
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView],
        label = [CPTextField labelWithTitle:"Type something:"];

    [label setFont:[CPFont fontWithName:"Helvetica" size:48]];

    [label setTextColor:[CPColor colorWithCalibratedRed:93.0 / 255.0 green:93.0 / 255.0 blue:93.0 / 255.0 alpha:1.0]];
    [label setTextShadowColor:[CPColor colorWithCalibratedRed:225.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.7]];
    [label setTextShadowOffset:CGSizeMake(0.0, 1.0)];

    [label sizeToFit];
    var inputField = [[SocketMultilineTextField alloc] initWithFrame:CGRectMake(0, 0, 600, 400)];
    [inputField setTextShadowColor:[CPColor colorWithCalibratedRed:225.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.7]];
    [inputField setTextShadowOffset:CGSizeMake(0.0, 1.0)];
    [inputField setEditable:YES];
    [inputField setBackgroundColor:[CPColor colorWithHexString:"D1D1D1"]];
    [inputField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [inputField setCenter:[contentView center]];
    [inputField setTheSocket:theSocket];
    [contentView addSubview:inputField];
    [contentView addSubview:label];
    [contentView setBackgroundColor:[CPColor colorWithHexString:"E0E0E0"]];

    [label setCenter:CGPointMake([contentView center].x, [inputField frame].origin.y - 50)];

    [theWindow orderFront:self];
}

@end
