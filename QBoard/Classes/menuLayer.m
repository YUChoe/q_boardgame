//
//  menuLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 7..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import "menuLayer.h"
#import "GamePlayLayer.h"


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
    
    CCSprite *bg = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    bg.position = ccp(240, 160);
    [self addChild:bg z:0 tag:100];
    
    // 왼쪽에 블록 아이콘 같은 것 
    // 오른쪽에 메뉴
    // 1. 뉴게임
    CCSprite *b1 = [CCSprite spriteWithFile:@"NewGameButton.png"];
    b1.position = ccp(340, 160);
    [self addChild:b1 z:10 tag:201];
    CCSprite *o1 = [CCSprite spriteWithFile:@"NewGameButton_over.png"];
    o1.position = b1.position;
    o1.visible = NO;
    [self addChild:o1 z:11 tag:301];
    // 2. 컨티뉴 ??
    // 3. 옵션
    CCSprite *b2 = [CCSprite spriteWithFile:@"OptionsButton.png"];
    b2.position = ccp(340, 120);
    [self addChild:b2 z:10 tag:203];
    CCSprite *o2 = [CCSprite spriteWithFile:@"OptionsButton_over.png"];
    o2.position = b2.position;
    o2.visible = NO;
    [self addChild:o2 z:11 tag:303];    // 4. 크리딧
    CCSprite *b3 = [CCSprite spriteWithFile:@"CreditsButton.png"];
    b3.position = ccp(340, 80);
    [self addChild:b3 z:10 tag:204];
    CCSprite *o3 = [CCSprite spriteWithFile:@"CreditsButton_over.png"];
    o3.position = b3.position;
    o3.visible = NO;
    [self addChild:o3 z:11 tag:304];
  }
	return self;
}    

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
  //아이콘 반전 
  UITouch *touch = [touches anyObject];
  
  if (touch)
  {
    CGPoint touchedlocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
    [self getChildByTag:301].visible = NO;
    //[self getChildByTag:302].visible = NO;
    [self getChildByTag:303].visible = NO;
    [self getChildByTag:304].visible = NO;

    if (CGRectContainsPoint([[self getChildByTag:201] boundingBox], touchedlocation))
    {
      [self getChildByTag:301].visible = YES;
    } else if (CGRectContainsPoint([[self getChildByTag:203] boundingBox], touchedlocation))
    {
      [self getChildByTag:303].visible = YES;
    } else if (CGRectContainsPoint([[self getChildByTag:204] boundingBox], touchedlocation))
    {
      [self getChildByTag:304].visible = YES;
    }
  }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  // 레이어 전환 
  UITouch *touch = [touches anyObject];
  
  if (touch)
  {
    CGPoint touchedlocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
    [self getChildByTag:301].visible = NO;
    //[self getChildByTag:302].visible = NO;
    [self getChildByTag:303].visible = NO;
    [self getChildByTag:304].visible = NO;
    
    if (CGRectContainsPoint([[self getChildByTag:201] boundingBox], touchedlocation))
    {
      [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[GamePlayLayer scene]]];
    } else if (CGRectContainsPoint([[self getChildByTag:203] boundingBox], touchedlocation))
    {
    
    } else if (CGRectContainsPoint([[self getChildByTag:204] boundingBox], touchedlocation))
    {
    
    }

  }
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