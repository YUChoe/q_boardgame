//
//  optionsLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 __MyCompanyName__. All rights reserved.
//

#import "OptionsLayer.h"


@implementation OptionsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionsLayer *layer = [OptionsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
  {
    //self.isTouchEnabled = YES;
    
    CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 460.0);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    [webView setBackgroundColor:[UIColor whiteColor]];
    NSString *urlAddress = @"http://www.google.com";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    [self addSubview:webView]; 
    [webView release];
    
  }
  
  return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
