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

    id nextStep = [CCCallFunc actionWithTarget:self selector:@selector(displayUI)]; //  
    
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:0.5], nextStep, nil]];
  }
  
  return self;
}

- (void) displayUI
{
  // 설정파일 읽어오기 
  BOOL effectSound_config = YES; // default 값
  BOOL flip_config = YES;        // default 값 
  
  //
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *fileName = [documentsDirectory stringByAppendingPathComponent:CONFIG_FILE_NAME];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileName];
  
  if (dic != nil)
  {
    effectSound_config = ([[dic objectForKey:@"effectSound"] isEqualToString:@"YES"] ? YES : NO);
    flip_config = ([[dic objectForKey:@"flip"] isEqualToString:@"YES"] ? YES : NO);
  } else {
    // 파일 생성 
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"YES" forKey:@"effectSound"];
    [dic setObject:@"YES" forKey:@"flip"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:CONFIG_FILE_NAME];
    
    [dic writeToFile:fileName atomically:YES];
  }
  
  // Row 1
  // left 
  op = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 300, 40)];
  op.backgroundColor = [UIColor clearColor];
  [op setTextColor:[UIColor whiteColor]];
  [op setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:32]];
  [op setText:@"OPTIONS"];
  [[[CCDirector sharedDirector] openGLView] addSubview:op];
  // mid 

  // Row 2
  // left
  eflbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 300, 40)];
  eflbl.backgroundColor = [UIColor clearColor];
  [eflbl setTextColor:[UIColor whiteColor]];
  [eflbl setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:24]];
  [eflbl setText:@"SOUND EFFECTS"];
  [[[CCDirector sharedDirector] openGLView] addSubview:eflbl];
  // mid 
  effectSoundOnOff = [[UISwitch alloc] initWithFrame:CGRectMake(220, 105, 100, 30)];
  [effectSoundOnOff setOn:effectSound_config];
  [effectSoundOnOff setTag:200];
  [effectSoundOnOff addTarget:self action:@selector(OnOffToggle:) forControlEvents:UIControlEventValueChanged];
  [[[CCDirector sharedDirector] openGLView] addSubview:effectSoundOnOff];
  
  // Row 3
  // left
  fliplbl = [[UILabel alloc] initWithFrame:CGRectMake(140, 150, 300, 40)];
  fliplbl.backgroundColor = [UIColor clearColor];
  [fliplbl setTextColor:[UIColor whiteColor]];
  [fliplbl setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:24]];
  [fliplbl setText:@"FLIP"];
  [[[CCDirector sharedDirector] openGLView] addSubview:fliplbl];
  // mid
  flipOnOff = [[UISwitch alloc] initWithFrame:CGRectMake(220, 155, 100, 30)];
  [flipOnOff setOn:flip_config];
  [flipOnOff setTag:210];
  [flipOnOff addTarget:self action:@selector(OnOffToggle:) forControlEvents:UIControlEventValueChanged];
  [[[CCDirector sharedDirector] openGLView] addSubview:flipOnOff];
   
  // Row 4
  backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [backButton setFrame:CGRectMake(180, 240, 120, 40)];
  [backButton setAlpha:0.75f];
  [backButton setTitle:@"BACK" forState:UIControlStateNormal];
  [backButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  [backButton addTarget:self action:@selector(backTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: backButton];

}

- (void) OnOffToggle:(id)sender
{
  // 한번에 2개 다 저장 
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  
  [dic setObject:([effectSoundOnOff isOn] ? @"YES" : @"NO") forKey:@"effectSound"];
  [dic setObject:([flipOnOff isOn] ? @"YES" : @"NO") forKey:@"flip"];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *fileName = [documentsDirectory stringByAppendingPathComponent:CONFIG_FILE_NAME];
  //NSLog(@"filefullpath:%@",fileName);

  [dic writeToFile:fileName atomically:YES];
}

- (void) backTouched:(id)sender
{
  [op removeFromSuperview];
  [eflbl removeFromSuperview];
  [effectSoundOnOff removeFromSuperview];
  [fliplbl removeFromSuperview];
  [flipOnOff removeFromSuperview];
  
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
