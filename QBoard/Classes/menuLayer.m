//
//  menuLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 7..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import "menuLayer.h"


@implementation menuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	menuLayer *layer = [menuLayer node];
	
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

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
  //아이콘 반전 
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  // 레이어 전환 
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