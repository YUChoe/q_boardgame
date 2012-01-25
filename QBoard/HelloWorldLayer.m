//
//  HelloWorldLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "aBlock.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) dump_map
{
  NSString *row = @"\n";
  for (int x=0; x<40; x++)
  {    
    for (int y=0; y<40; y++)
    {
      if (y==0) row = [NSString stringWithFormat:@"%@\n%02d:", row, x];
      row = [NSString stringWithFormat:@"%@[%02d]", row, map_mask[x][y]];
    }
  }
  NSLog(@"%@", row);
}

// 특정 위치에 블록 놓기 
/*
-(void)setBlock:(int)x y:(int)y
{
  CCSprite *cB = [CCSprite spriteWithFile:@"woodenBlock_64x64.png"];
  
  if (x == 20 && y == 20) {
    // 윈도의 센터 
    CGSize WinSize = [[CCDirector sharedDirector] winSize];
    cB.position = ccp( WinSize.width/2, WinSize.height/2);
  } else {
    // 포지션은 20,20 에 있는 0번 블록에서 역산? 
    CCSprite *standardBlock = [[blocks objectAtIndex:0] objectAtIndex:0];
    float xx, yy;
    
    if (x <= 20)
    {
      xx = standardBlock.position.x - 64 * (20-x);
    } else {
      xx = standardBlock.position.x + 64 * (x-20);
    }
    
    if (y <= 20)
    {
      yy = standardBlock.position.y - 64 * (20-y);
    } else {
      yy = standardBlock.position.y + 64 * (y-20);
    }
    cB.position = ccp(xx, yy);
  }
  [self addChild:cB z:10];
    
  CCSprite *cBshadow = [CCSprite spriteWithFile:@"woodenBlock_64x64.png"];
  cBshadow.position = ccp( cB.position.x+3, cB.position.y-3);    
  cBshadow.color = ccc3(0,0,0);
  cBshadow.opacity = 128;
  cBshadow.scaleY = -1.0;
  [self addChild:cBshadow z:9];
  
  NSMutableArray *blkUnit = [[NSMutableArray alloc] initWithObjects:cB, [NSNumber numberWithInt:x], [NSNumber numberWithInt:y], nil];
  [blocks addObject:blkUnit];
  
  map[x][y] = (int)[blocks count];//  - 1; // 0으로 시작 
  map_mask[x][y] = 2; 
  //상하좌우 순서로 1로 마스크 
  if (map_mask[x][y+1] != 2) map_mask[x][y+1] = 1;
  if (map_mask[x][y-1] != 2) map_mask[x][y-1] = 1;
  if (map_mask[x+1][y] != 2) map_mask[x+1][y] = 1;
  if (map_mask[x-1][y] != 2) map_mask[x-1][y] = 1;
  
  //NSLog(@"map[%d][%d] = %d", x, y, map[x][y]);
  //[self dump_map];
}
*/
-(void)setBlock:(int)x y:(int)y
{
  aBlock *cB = [aBlock spriteWithFile:@"woodenBlock_64x64.png"];

  if (x == 20 && y == 20) {
    // 윈도의 센터 
    CGSize WinSize = [[CCDirector sharedDirector] winSize];
    [cB putBlockAtPosition:self position:ccp( WinSize.width/2, WinSize.height/2) type:blk_heart color:blk_color_cyan];
  } else {
    // 포지션은 20,20 에 있는 0번 블록에서 역산? 
    CCSprite *standardBlock = [[blocks objectAtIndex:0] objectAtIndex:0];
    float xx, yy;
    
    if (x <= 20)
    {
      xx = standardBlock.position.x - 64 * (20-x);
    } else {
      xx = standardBlock.position.x + 64 * (x-20);
    }
    
    if (y <= 20)
    {
      yy = standardBlock.position.y - 64 * (20-y);
    } else {
      yy = standardBlock.position.y + 64 * (y-20);
    }
    [cB putBlockAtPosition:self position:ccp(xx, yy) type:blk_heart color:blk_color_cyan];
  }
  //[self addChild:cB z:10];
    
  NSMutableArray *blkUnit = [[NSMutableArray alloc] initWithObjects:cB, [NSNumber numberWithInt:x], [NSNumber numberWithInt:y], nil];
  [blocks addObject:blkUnit];
  
  map[x][y] = (int)[blocks count];//  - 1; // 0으로 시작 
  map_mask[x][y] = 2; 
  //상하좌우 순서로 1로 마스크 
  if (map_mask[x][y+1] != 2) map_mask[x][y+1] = 1;
  if (map_mask[x][y-1] != 2) map_mask[x][y-1] = 1;
  if (map_mask[x+1][y] != 2) map_mask[x+1][y] = 1;
  if (map_mask[x-1][y] != 2) map_mask[x-1][y] = 1;
  
  //NSLog(@"map[%d][%d] = %d", x, y, map[x][y]);
  //[self dump_map];
}
//

// xy 좌표로 ccp 값을 돌려 받는 메쏘드
-(CGPoint) fromMapToPosition:(int)x y:(int)y
{
  // 기준 블록에서부터 환산 
  CCSprite *standardBlock = [[blocks objectAtIndex:0] objectAtIndex:0];
  float xx, yy;
  
  if (x <= 20)
  {
    xx = standardBlock.position.x - 64 * (20-x);
  } else {
    xx = standardBlock.position.x + 64 * (x-20);
  }
  
  if (y <= 20)
  {
    yy = standardBlock.position.y - 64 * (20-y);
  } else {
    yy = standardBlock.position.y + 64 * (y-20);
  }
  
  return CGPointMake(xx, yy);
}
//

-(id) init
{
	if( (self=[super init])) 
  {
    self.isTouchEnabled = YES;
    gameStatus = 0; // 초기화 시작  
    
    blocks = [[NSMutableArray alloc] init];
    //hintBlocks = [[NSMutableArray alloc] init]; // 매번 초기화를 하니 필요 없을 수도 
    diffCamera = ccp(0,0);
    
    // 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    //NSLog(@"screenSize: width/height = %f/%f", screenSize.width, screenSize.height);

    // z 0 으로 배경 깔기 
    CCSprite *linenBG = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    linenBG.position = ccp( screenSize.width /2 , screenSize.height/2 ); // center 
    [linenBG setScale:2.0f];
    [self addChild:linenBG z:0];
    
    [self setBlock:20 y:20];    // 먼저 센터에 기준 블록 하나
    
    // class test
    /*
    aBlock *ccB = [aBlock spriteWithFile:@"woodenBlock_64x64.png"];
    [ccB putBlockAtPosition:self position:ccp(screenSize.width/2, screenSize.height/2)];
    
     */
    // end of test
     
    gameStatus = 1; // 초기화 완료 

    [self mainGameLoop]; // game status 를 인자로 넘길 수도 있을테지만 1scene으로 작동되는 게임이니까 
	}
  
	return self;
}

-(void) mainGameLoop
{
  /*
  // 조건이 되면  break 하면 게임 오버? 
  // 1. 둘 곳을 정하기 map_mask를 가지고 힌트 배열 \
     2. 그 중 한 곳 터치 할 때 까지 기다림 <- 말도 안돼 
  // 3. 터치 하면 막 정리 함 
  // 4. 컴-다른사람 차례를 위해 둘 곳을 정하기 
  // 5. 그 중 한 곳을 터치 할 때 까지 기다림 -_- 
  //  1로 
  
  // game over 
  // 판정 
  */
  if (gameStatus == 1) // 내가 둘 곳을 정하기 
  {
    hintBlocks = [[NSMutableArray alloc] init]; //  다시 초기화 
    for (int x=0; x<40; x++) 
    {
      for (int y=0; y<40; y++) 
      {
        if (map_mask[x][y] == 1)
        {
          CCSprite *myBlk = [CCSprite spriteWithFile:@"woodenBlock_64x64.png"];
          myBlk.position = [self fromMapToPosition:x y:y];
          myBlk.opacity = 128;
          [self addChild:myBlk z:10];
        
          CCSprite *cBshadow = [CCSprite spriteWithFile:@"woodenBlock_64x64.png"];
          cBshadow.position = ccp( myBlk.position.x+3, myBlk.position.y-3);    
          cBshadow.color = ccc3(0,0,0);
          cBshadow.opacity = 128;
          cBshadow.scaleY = -1.0;
          [self addChild:cBshadow z:9];
          
          NSMutableArray *myBlkUnit = [NSMutableArray arrayWithObjects:myBlk, [NSNumber numberWithInt:x], [NSNumber numberWithInt:y], cBshadow, nil];
          //NSLog(@"map_mask[%d][%d] added to hintBlocks", x, y);
          [hintBlocks addObject:myBlkUnit];
        } // of if map_mask[x][y] == 1
      }
    }

    gameStatus = 2; 
  } else if (gameStatus == 2) // 터치 할 때 까지 기다림  
  {
    // 기다린다 
    // 암것도 할게 없다 .. 여기선... 
    // ccTouchBegan 에서 처리 
  } else if (gameStatus == 3) // 블록을 놓은 후 정리 
  {
    // 마찬가지로 ccTouchBegan 에서 처리 
  } else if (gameStatus == 4) // 컴 또는 다른 사람 차례
  {
    //TODO:구현 
  }
}

- (BOOL) collusionWithSprite:(CCSprite *)spr location:(CGPoint)location
{
  int spriteSize = 64;
  // anchor가 디폴트로 가운데 있다고 가정 
  CGPoint sprPosition = ccpAdd(spr.position, diffCamera);
  /*
  float x1 = spr.position.x - (spriteSize /2);
  float x2 = spr.position.x + (spriteSize /2);
  float y1 = spr.position.y - (spriteSize /2);
  float y2 = spr.position.y + (spriteSize /2);
  NSLog(@"(%.0f,%.0f)-(%.0f,%.0f) vs (%.0f,%.0f)", x1, x2,y1,y2, location.x, location.y);
   */
  
  float x1 = sprPosition.x - (spriteSize /2);
  float x2 = sprPosition.x + (spriteSize /2);
  float y1 = sprPosition.y - (spriteSize /2);
  float y2 = sprPosition.y + (spriteSize /2);
  NSLog(@"(%.0f,%.0f)-(%.0f,%.0f) vs (%.0f,%.0f)", x1, x2,y1,y2, location.x, location.y);
  //CGRect bound = CGRectMake(x1, y2, 64, 64);
  //NSLog(@"%0.f,%0.f,64,64 <= location(%0.f,%0.f)", x1,y2,location.x, location.y);
  //if (CGRectContainsPoint(bound, location)) 
  if( x1 > location.x || x2 < location.x || y1 > location.y || y2 < location.y)
  {    
    return NO;
  } else {
    NSLog(@"CGRectContains");
    return YES; 

  }
}
/*
 설 연휴동안 너무 기름진 식사를 해서 체중관리가 걱정되신다면 집안에서 간단한 운동으로 조절하실 수 있습니다. 
 1.팔굽혀펴기 300개 
 2.윗몸일으키기 300개 
 3. 스퀏트 500개 
 4. 배근운동 300개 
 
 이렇게만 일주일정도 하시면 됩니다^^
 */
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  if (touch)
  {
    CGPoint touchedlocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];
    //CGPoint touchinview = [touch locationInView:touch.view]; // cocoa

    
    NSLog(@"touchedlocation: ccp(%.0f, %.0f)", touchedlocation.x, touchedlocation.y);
    //NSLog(@"gameStatus:%d", gameStatus);
    
    if (gameStatus == 2) // 내 턴 
    {
     for (NSMutableArray *myBlkUnit in hintBlocks)
     {
       CCSprite *myBlk = [myBlkUnit objectAtIndex:0];
       // TODO: 이걸 ccp 로 환산 해야 함 
       //if ( CGRectContainsPoint(myBlk.boundingBox, touchedlocation)) 
       if ([self collusionWithSprite:myBlk location:touchedlocation] == YES) 
       {
         //NSLog(@"제대로 클릭 했음");
         // myblk 자리에 블록을 놓고 
         int xx = [[myBlkUnit objectAtIndex:1] intValue];
         int yy = [[myBlkUnit objectAtIndex:2] intValue];
         [self setBlock:xx y:yy];
         map_mask[xx][yy] = 2;

         gameStatus = 3;
         break;
       } else {
         //NSLog(@"엉뚱한 클릭 ");
       }
     } // of for 
      
     // 정리 
     if (gameStatus == 3) // 정상적으로 블록을 놓았으면 3 으로 올라갔고 아니면 못올라 갔겠지 .. 아닌 경우는 어떤건지 예상 안되지만  
     {
       for (NSMutableArray *myBlkUnit in hintBlocks)
       {
         CCSprite *myBlk = [myBlkUnit objectAtIndex:0];
         CCSprite *myBlks = [myBlkUnit objectAtIndex:3];
         [self removeChild:myBlk cleanup:YES];
         [self removeChild:myBlks cleanup:YES];         
       }
       
       // 원랜 4단계로 넘어 가야 하지만 
       gameStatus = 4;
       // 혼자놀기로 다시 1단계로 ㄱㄱ 
       gameStatus = 1;
       
       [self mainGameLoop];
     }
      

    } // of if gameStatus == 2
  } // of if touch == YES
  //return YES;
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *myTouch = [touches anyObject];
  CGPoint location = [myTouch locationInView:[myTouch view]];
  location = [[CCDirector sharedDirector] convertToGL:location];
  
  for( UITouch *touch in touches ) 
  {
    CGPoint touchLocation = [touch locationInView: [touch view]];
    CGPoint prevLocation = [touch previousLocationInView: [touch view]];    
    
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    CGPoint diff = ccpSub(touchLocation,prevLocation);
    //diff.x = 0; // 위 아래 방향으로만 스크롤 고정 인 경우
    
    diffCamera = ccpAdd(self.position, diff);
    [self setPosition: ccpAdd(self.position, diff)];
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
