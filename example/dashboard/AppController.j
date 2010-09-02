/*
 * AppController.j
 * dashboard
 *
 * Created by Saikat Chakrabarti on September 1, 2010.
 * Copyright 2010, Saikat Chakrabarti All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <SCSocket/SCSocket.j>
@import <LPKit/LPSparkLine.j>
@import <LPKit/LPChartView.j>

@implementation AppController : CPObject
{
    SCSocket theSocket;
    LPChartView barChart;
    LPSparkLine lineChart;
    CPArray values;
    CPArray lps;
    CPTextField label1;
    CPTextField label2;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{

    theSocket = [[SCSocket alloc] initWithURL:[CPURL URLWithString:"http://localhost:8080"] delegate:self];
    [theSocket connect];
}

- (void)socketDidConnect:(SCSocket)aSocket
{
    lps = [0];
    [theSocket sendMessage:{'authToken' : 'my_secret_token_for_the_dashboard_client'}];
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
    label1 = [CPTextField labelWithTitle:"Breakdown"];
    label2 = [CPTextField labelWithTitle:"Letters/Sec"];

    values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    [label1 setFont:[CPFont fontWithName:"Helvetica" size:48]];
    [label2 setFont:[CPFont fontWithName:"Helvetica" size:48]];

    [label1 setTextColor:[CPColor colorWithCalibratedRed:93.0 / 255.0 green:93.0 / 255.0 blue:93.0 / 255.0 alpha:1.0]];
    [label1 setTextShadowColor:[CPColor colorWithCalibratedRed:225.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.7]];
    [label1 setTextShadowOffset:CGSizeMake(0.0, 1.0)];

    [label2 setTextColor:[CPColor colorWithCalibratedRed:93.0 / 255.0 green:93.0 / 255.0 blue:93.0 / 255.0 alpha:1.0]];
    [label2 setTextShadowColor:[CPColor colorWithCalibratedRed:225.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:0.7]];
    [label2 setTextShadowOffset:CGSizeMake(0.0, 1.0)];

    [label1 sizeToFit];
    [label2 sizeToFit];

    lineChart = [[LPSparkLine alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    [lineChart setCenter:CGPointMake([contentView center].x + 250, [contentView center].y)];
    [lineChart setLineWeight:2.0];
    [lineChart setLineColor:[CPColor colorWithHexString:@"aad8ff"]];
    [lineChart setShadowColor:[CPColor colorWithHexString:@"999"]];
    [lineChart setData:[]];
    [contentView addSubview:lineChart];

    barChart = [[LPChartView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    [barChart setDrawView:[[LPChartDrawView alloc] init]];
    [barChart setCenter:CGPointMake([contentView center].x - 250, [contentView center].y)];
    [barChart setDataSource:self];
    [barChart setDisplayGrid:YES];
    [contentView addSubview:barChart];
    [contentView addSubview:label1];
    [contentView addSubview:label2];
    [label1 setCenter:CGPointMake([contentView center].x - 250, [barChart frame].origin.y + [barChart frame].size.height + 50)];
    [label2 setCenter:CGPointMake([contentView center].x + 250, [lineChart frame].origin.y + [barChart frame].size.height + 50)];
    
    var refreshSpark = function() {
        [label2 setStringValue:"Letters/Sec (" + lps[lps.length-1] + ")"];
        [label2 sizeToFit];
        lps.push(0);
        var theData = [CPArray arrayWithArray:lps];
        theData.splice(theData.length - 1, 1);
        [lineChart setData:theData.length > 0 ? theData : [0]];
        if (lps.length > 20)
            lps.shift();
        setTimeout(refreshSpark, 1000);
    }
    setTimeout(refreshSpark, 1000);

    [contentView setBackgroundColor:[CPColor colorWithHexString:"E0E0E0"]];
    [theWindow orderFront:self];
}

- (void)socket:(SCSocket)aSocket didReceiveMessage:(CPString)aMessage
{
    if (aMessage.body && aMessage.body.c)
    {
        var theLetter = aMessage.body.c;
        var theIndex = theLetter.charCodeAt(0) - 'a'.charCodeAt(0);
        values[theIndex]++;
        [barChart reloadData];
        lps[lps.length - 1]++;
    }
}

- (unsigned)numberOfSetsInChart:(LPChartView)aChart
{
    return 1;
}

- (CPString)chart:(LPChartView)aChart labelValueForIndex:(unsigned)anIndex
{
    return String.fromCharCode(anIndex + 65);
}

- (unsigned)chart:(LPChartView)aChart numberOfValuesInSet:(unsigned)setIndex
{
    return values.length;
}

- (unsigned)chart:(LPChartView)aChart valueForIndex:(unsigned)anIndex set:(unsigned)setIndex
{
    return values[anIndex];
}


@end
