//
//  CreditsLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import "CreditsLayer.h"
#import "menuLayer.h"


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
    //self.isTouchEnabled = YES;
    
    CCSprite *bg = [CCSprite spriteWithFile:@"noizze_logo.png"];
    bg.position = ccp(240, 160);
    [self addChild:bg z:0];

    id nextStep = [CCCallFuncN actionWithTarget:self selector:@selector(displayUI:)]; //  
    
    [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:0.5], nextStep, nil]];
  }
  
  return self;
}

- (void) displayUI:(id)sender 
{
  
  NSString *CreditsText =   @""
  "* License \n"
  "Copyright 2012 noizze.net, Yong-uk Choe \n"
  "\n"
  "* Bug tracker \n"
  "have a bug or suggest? \n"
  "https://github.com/YUChoe/q_boardgame/issues \n"
  "\n"
  "* Author \n"
  "+ blog : http://blog.noizze.net \n"
  "+ facebook group : http://www.facebook.com/groups/131873050221514/ \n"
  "+ twitter : http://twitter.com/ls_pp \n"
  "+ github : http://github.com/YUChoe \n";
  
  
  CreditsTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 260, 220)];
  //[CreditsTextField setDelegate:self];
  [CreditsTextView setFont:[UIFont fontWithName:@"Helvetica" size:12]];
  CreditsTextView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f]; //[UIColor clearColor];
  CreditsTextView.layer.cornerRadius = 5;
  CreditsTextView.editable = NO;
  
  [CreditsTextView setText:CreditsText];
  [[[CCDirector sharedDirector] openGLView] addSubview: CreditsTextView];
  
  backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  //[[UIButton alloc] initWithFrame:CGRectMake(280, 20, 60, 40)];
  [backButton setFrame:CGRectMake(300, 20, 120, 40)];
  [backButton setAlpha:0.75f];
  [backButton setTitle:@"BACK" forState:UIControlStateNormal];
  [backButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  
  [backButton addTarget:self action:@selector(backTouched:) forControlEvents:UIControlEventTouchUpInside];
  [[[CCDirector sharedDirector] openGLView] addSubview: backButton];
}

-(void)backTouched:(id)sender 
{
	//NSLog(@"Button was clicked");
  [CreditsTextView removeFromSuperview];
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
