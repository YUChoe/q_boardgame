//
//  menuLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 7..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import "menuLayer.h"

#import "GamePlayLayer.h"
#import "optionsLayer.h"
#import "CreditsLayer.h"

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
    //self.isTouchEnabled = YES;
    
    CCSprite *bg = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    bg.position = ccp(240, 160);
    [self addChild:bg z:0 tag:100];

    id nextStep = [CCCallFunc actionWithTarget:self selector:@selector(displayUI)]; //  
    
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:0.5], nextStep, nil]];
  }
	return self;
}    

-(void)displayUI
{
  
  // 왼쪽에 블록 아이콘 배치  
  // 오른쪽에 메뉴
  // 1. 뉴게임
  
  newGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [newGameButton setFrame:CGRectMake(300, 120, 120, 40)]; // ccp좌표계가 아님 
  [newGameButton setAlpha:0.75f];
  [newGameButton setTitle:@"New game" forState:UIControlStateNormal];
  [newGameButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  [newGameButton addTarget:self action:@selector(newGameTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: newGameButton];
  
  // 2. 컨티뉴 ??
  // 3. 옵션
  optionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [optionsButton setFrame:CGRectMake(300, 170, 120, 40)]; // ccp좌표계가 아님 
  [optionsButton setAlpha:0.75f];
  [optionsButton setTitle:@"Options" forState:UIControlStateNormal];
  [optionsButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  [optionsButton addTarget:self action:@selector(optionsTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: optionsButton];
  
  // 4. 크리딧
  creditsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [creditsButton setFrame:CGRectMake(300, 220, 120, 40)]; // ccp좌표계가 아님 
  [creditsButton setAlpha:0.75f];
  [creditsButton setTitle:@"Credits" forState:UIControlStateNormal];
  [creditsButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  [creditsButton addTarget:self action:@selector(creditsTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: creditsButton];
  
  
}

-(void) newGameTouched:(id)sender
{ 
  [newGameButton removeFromSuperview];
  [optionsButton removeFromSuperview];
  [creditsButton removeFromSuperview];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[GamePlayLayer scene]]];
}

-(void) optionsTouched:(id)sender
{ 
  [newGameButton removeFromSuperview];
  [optionsButton removeFromSuperview];
  [creditsButton removeFromSuperview];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[OptionsLayer scene]]];  
}

-(void) creditsTouched:(id)sender
{  
  [newGameButton removeFromSuperview];
  [optionsButton removeFromSuperview];
  [creditsButton removeFromSuperview];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[CreditsLayer scene]]];  
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
  //[[self getChildByTag:100] release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end