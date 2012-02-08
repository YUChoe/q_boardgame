//
//  CreditsLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 __MyCompanyName__. All rights reserved.
//

#import "CreditsLayer.h"


@implementation CreditsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsLayer *layer = [CreditsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
  {
    self.isTouchEnabled = YES;
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
