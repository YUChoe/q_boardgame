//
//  optionsLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import "OptionsLayer.h"
#import "menuLayer.h"

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
    // z:0 으로 배경 깔기 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *linenBG = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    linenBG.position = ccp( screenSize.width /2 , screenSize.height/2 ); // center 
    [self addChild:linenBG z:0 tag:100];

    id nextStep = [CCCallFuncN actionWithTarget:self selector:@selector(displayUI:)]; //  
    
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:0.5], nextStep, nil]];
  }
  
  return self;
}

- (void) displayUI:(id)sender 
{
  
  backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  //[[UIButton alloc] initWithFrame:CGRectMake(280, 20, 60, 40)];
  [backButton setFrame:CGRectMake(300, 20, 120, 40)];
  [backButton setAlpha:0.75f];
  [backButton setTitle:@"BACK" forState:UIControlStateNormal];
  [backButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  
  [backButton addTarget:self action:@selector(backTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: backButton];
}

- (void) saveTouched:(id)sender
{
  
}

- (void) backTouched:(id)sender
{
  [backButton removeFromSuperview];
  
  [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[menuLayer scene]]];
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
