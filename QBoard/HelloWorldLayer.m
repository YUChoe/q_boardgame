//
//  HelloWorldLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright noizze.net 2012년. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
//#import "aBlock.h"
#import <stdlib.h>
#import <time.h>

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
-(void)setBlock:(int)idx x:(int)x y:(int)y
{
  aBlock *cB = [aBlock spriteWithFile:@"woodenBlock_48x48.png"];
  _block_type tyB = [[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue];
  _block_color clB = [[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue];
  
  if (x == 20 && y == 20) {
    // 윈도의 센터 
    CGSize WinSize = [[CCDirector sharedDirector] winSize];
    // test 중에는 파일명이 없을 수도 있기 때문에 .. 
    [cB putBlockAtPosition:self position:ccp( WinSize.width/2, WinSize.height/2) type:tyB color:clB];
  } else {
    // 포지션은 20,20 에 있는 0번 블록에서 역산? 
    CCSprite *standardBlock = [[blocks objectAtIndex:0] objectAtIndex:0];
    float xx, yy;
    
    if (x <= 20)
    {
      xx = standardBlock.position.x - [standardBlock boundingBox].size.width * (20-x);
    } else {
      xx = standardBlock.position.x + [standardBlock boundingBox].size.width * (x-20);
    }
    
    if (y <= 20)
    {
      yy = standardBlock.position.y - [standardBlock boundingBox].size.height * (20-y);
    } else {
      yy = standardBlock.position.y + [standardBlock boundingBox].size.height * (y-20);
    }
    [cB putBlockAtPosition:self position:ccp(xx, yy) type:tyB color:clB];
  }
    
  NSMutableArray *blkUnit = [[NSMutableArray alloc] initWithObjects:cB,                  // 0:aBlock
                             [NSNumber numberWithInt:x], [NSNumber numberWithInt:y],     // 1,2:xy
                             [NSNumber numberWithInt:tyB], [NSNumber numberWithInt:clB], // 3,4:blocktype, blockcolor
                             nil];
  [blocks addObject:blkUnit];
  [blkQueue removeObjectAtIndex:idx];
  //NSLog(@"블록을 놓아서 큐 인덱스가 %d", [blkQueue count]);
  
  map[x][y] = (int)[blocks count];//  - 1; // 0으로 시작 
  map_mask[x][y] = 2; 
  //상하좌우 순서로 1로 마스크 
  // 판단을 여기서 하느냐 선택할때 하느냐 
  // 선택할때 즉, 오른쪽 6개 블록에서 선택할 때 결정 
  /*
  if (map_mask[x][y+1] != 2 && [self possibleGuess:x y:(y+1)]) map_mask[x][y+1] = 1;
  if (map_mask[x][y-1] != 2 && [self possibleGuess:x y:(y-1)]) map_mask[x][y-1] = 1;
  if (map_mask[x+1][y] != 2 && [self possibleGuess:(x+1) y:y]) map_mask[x+1][y] = 1;
  if (map_mask[x-1][y] != 2 && [self possibleGuess:(x-1) y:y]) map_mask[x-1][y] = 1;
   */
  [self removeHintBlocks];
  if (map_mask[x][y+1] != 2) map_mask[x][y+1] = 1;
  if (map_mask[x][y-1] != 2) map_mask[x][y-1] = 1;
  if (map_mask[x+1][y] != 2) map_mask[x+1][y] = 1;
  if (map_mask[x-1][y] != 2) map_mask[x-1][y] = 1;

  [self realignSixBlocksInQueue]; // 블록을 놓았으니 큐 정리 + 애니메이션 
  
  //NSLog(@"map[%d][%d] = %d", x, y, map[x][y]);
  //[self dump_map];
}
//

// 화면 오른쪽에 내가 가지고 있는 (큐의 6개)블록을 보여주는 기능 
// 애니메이션이 있어도 좋을 듯? 
-(void) realignSixBlocksInQueue
{
  // 먼저 초기화
  [self removeReadyBlocks];
  
  blackBg = [CCSprite spriteWithFile:@"bg_black_48*288.png"];
  //오른쪽 구석인데.. 
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  blackBg.position = CGPointMake(screenSize.width - 48/2, screenSize.height/2);
  // 너무 오른쪽에 붙었나 싶기는 한데 약간 투명하게 해 봐야지 
  blackBg.opacity = 128;
  [self addChild:blackBg z:6];
  
  for (int idx=0; idx<[blkQueue count]; idx++) 
  {
    if (idx > 5 || idx >= [blkQueue count]) break; 
    CCSprite *b = [CCSprite spriteWithFile:@"woodenBlock_48x48.png"];
    b.position = CGPointMake(blackBg.position.x, blackBg.position.y - 48*2 - 48/2 + idx*48);
    [self addChild:b z:7];
    
    CCSprite *s = [CCSprite spriteWithFile:[self blockTypeFileName:[[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue] blockColor:[[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue]]];
    s.position = b.position;
    [self addChild:s z:8];
     
    NSMutableArray *rBUnit = [NSMutableArray arrayWithObjects:b, [NSNumber numberWithInt:idx], s, nil];
    [readyBlocks addObject:rBUnit];
    //break;
  }
}
//

// 위치 x,y에 블록큐0을 놓을 수 있는지 검사하는 메소드 
-(BOOL) possibleGuess:(int)idx x:(int)x y:(int)y
{
  // 범위 체크 
  if (x < 0 || y < 0 || x > 39 || y > 39) return NO;
  // 체크 하고 싶은 위치가 오니까 십중팔구 비어 있는 셀임.. 셀이란 용어는 여기서 처음 사용 됨 
  // 큐의 0번 블록을 기준으로 
  _block_type tb = [[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue];
  _block_color cb = [[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue];

  // 현재 위치에 놓을 수 있으면 YES를 리턴 
  //NSLog(@"possibleGuess 상");
  int posValue = map[x][y+1];
  if (posValue != 0)     // 둘 곳(x,y) 의 위가 0(비어있으면) 다음 검사
  { 
    // 블록이 있다면 색이나 모양이 같은지?
    if ([[[blocks objectAtIndex:posValue-1] objectAtIndex:3] intValue] == tb 
        || [[[blocks objectAtIndex:posValue-1] objectAtIndex:4] intValue] == cb) return YES;  
  }
  //NSLog(@"possibleGuess 하");
  posValue = map[x][y-1];
  if (posValue != 0) 
  {
    if ([[[blocks objectAtIndex:posValue-1] objectAtIndex:3] intValue] == tb 
        || [[[blocks objectAtIndex:posValue-1] objectAtIndex:4] intValue] == cb) return YES;  
  }
  //NSLog(@"possibleGuess 좌");
  posValue = map[x-1][y];
  if (posValue != 0) 
  {
    if ([[[blocks objectAtIndex:posValue-1] objectAtIndex:3] intValue] == tb 
        || [[[blocks objectAtIndex:posValue-1] objectAtIndex:4] intValue] == cb) return YES;  
  }
  //NSLog(@"possibleGuess 우");
  posValue = map[x+1][y];
  if (posValue != 0) 
  {
    if ([[[blocks objectAtIndex:posValue-1] objectAtIndex:3] intValue] == tb 
        || [[[blocks objectAtIndex:posValue-1] objectAtIndex:4] intValue] == cb) return YES;  
  }

  return NO;
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
    xx = standardBlock.position.x - [standardBlock boundingBox].size.width * (20-x);
  } else {
    xx = standardBlock.position.x + [standardBlock boundingBox].size.width * (x-20);
  }
  
  if (y <= 20)
  {
    yy = standardBlock.position.y - [standardBlock boundingBox].size.height * (20-y);
  } else {
    yy = standardBlock.position.y + [standardBlock boundingBox].size.height * (y-20);
  }
  
  return CGPointMake(xx, yy);
}
//

// 블록의 타입과 색을 넣으면 스프라이트 파일명을 만들어 주는 메소드 
// 2중으로 작성 된 메쏘드 따로 헤더파일을 만들까 ?
// TODO: 스프라이트 시트를 이용하게 되면 다른 방법으로 구현 
-(NSString *)blockTypeFileName:(_block_type)blockType blockColor:(_block_color)blockColor
{
  NSString *blockTypeAsString = @"";
  if (blockType == blk_heart)        { blockTypeAsString = @"heart"; }
  else if (blockType == blk_spade)   { blockTypeAsString = @"spade"; } 
  else if (blockType == blk_diamond) { blockTypeAsString = @"diamond"; } 
  else if (blockType == blk_clover)  { blockTypeAsString = @"clover"; } 
  else if (blockType == blk_cross)   { blockTypeAsString = @"cross"; } 
  else if (blockType == blk_circle)  { blockTypeAsString = @"circle"; } 
  
  NSString *blockColorAsString = @"";
  if (blockColor == blk_color_cyan) { blockColorAsString = @"cyan"; }
  else if (blockColor == blk_color_orange) { blockColorAsString = @"orange"; }
  else if (blockColor == blk_color_yellow) { blockColorAsString = @"yellow"; }
  else if (blockColor == blk_color_green) { blockColorAsString = @"green"; }
  else if (blockColor == blk_color_red) { blockColorAsString = @"red"; }
  else if (blockColor == blk_color_purple) { blockColorAsString = @"purple"; }
  
  //  NSString *blockTypeFileName = 
  return [NSString stringWithFormat:@"blockType_%@_%@.png", blockTypeAsString, blockColorAsString];
}
//

// 스테이지 시작 할 때 블록의 6모양 * 6색 * 2벌 = 64개를 정의 하고 섞는 메소드 
-(void) initAndShuffleBlocks
{
  blkQueue = [[NSMutableArray alloc] init];
  
  for (int s = 1; s<=2; s++) // 2set
  {
    //for (int shape=0; shape<=5; shape++) // 6모양
    for (int shape=0; shape<=2; shape++) // test
    {
      for (int colour=0; colour<=5; colour++) // 6색 그냥 간지나 보이게 영국식 colour
      {
        NSString *fn = [self blockTypeFileName:shape blockColor:colour];
        NSMutableArray *qUnit = [NSMutableArray arrayWithObjects:fn, [NSNumber numberWithInt:shape], [NSNumber numberWithInt:colour], nil];
        // 0: 파일명 
        // 1: shape as Int
        // 2: colout as Int
        [blkQueue addObject:qUnit];
        //NSLog(@"q:%@", fn);
      }
    }
  }
  
  //shuffle
  srandom(time(NULL));
  NSUInteger count = [blkQueue count];
  for (NSUInteger i = 0; i < count; ++i) 
  {
    int nElements = count - i;
    int n = (random() % nElements) + i;
    [blkQueue exchangeObjectAtIndex:i withObjectAtIndex:n];
  }

  NSLog(@"initAndShuffleBlocks Done : %d", [blkQueue count]);
}
//

// cocos2d scene 초기화 
-(id) init
{
	if( (self=[super init])) 
  {
    self.isTouchEnabled = YES;

    blocks = [[NSMutableArray alloc] init];
    readyBlocks = [[NSMutableArray alloc] init];
    diffCamera = ccp(0,0); // 스크롤로 이동 된 카메라의 위치.. 터치 좌표를 상대좌표로 보정하기 위해 필요 
    
    // z:0 으로 배경 깔기 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *linenBG = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    linenBG.position = ccp( screenSize.width /2 , screenSize.height/2 ); // center 
    //[linenBG setScale:3.0f];
    [self addChild:linenBG z:0];
    // 40*40 전체에 맞게 확장하면 안그래도 jpg파일 용량이 300k 넘어 가는데, 성능에 문제가 될 수도?
    // 차라리 카메라 이동 할 때 다시 센터로 돌아가면? 
    
    //
    [self initAndShuffleBlocks]; // 1stage 에 사용 될 블록 정의 64개 
    gameStatus = 0; // 스테이지 시작 
    
    [self realignSixBlocksInQueue];
    [self setBlock:0 x:20 y:20];    // 먼저 센터에 기준 블록 하나를 위의 블록큐에서 

    gameStatus = 1; // 초기화 완료 
    //
    
    //[self mainGameLoop]; // game status 를 인자로 넘길 수도 있을테지만 1scene으로 작동되는 게임이니까 
    // 위의 0, 1도 게임루프 안에 들어가 있으면 일관성 있을 듯 
	}
  
	return self;
}

-(void) showHintBlocks:(int)idx
{
  hintBlocks = [[NSMutableArray alloc] init]; //  다시 초기화 
  for (int x=0; x<40; x++) 
  {
    for (int y=0; y<40; y++) 
    {
      if (map_mask[x][y] == 1)
      {
        if([self possibleGuess:idx x:x y:y]) 
        {
          // 둘 수 있음 
          //NSLog(@"idx:%d를 [%d][%d]에 둘 수 있음 ", idx, x, y);
          CCSprite *myBlk = [CCSprite spriteWithFile:@"woodenBlock_48x48.png"];
          myBlk.position = [self fromMapToPosition:x y:y];
          myBlk.opacity = 128;
          [self addChild:myBlk z:10];
          
          CCSprite *cBshadow = [CCSprite spriteWithFile:@"woodenBlock_48x48.png"];
          cBshadow.position = ccp( myBlk.position.x+3, myBlk.position.y-3);    
          cBshadow.color = ccc3(0,0,0);
          cBshadow.opacity = 128;
          cBshadow.scaleY = -1.0;
          [self addChild:cBshadow z:9];
          
          // 색/모양 
          _block_type tyB = [[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue]; // 현재 큐의 제일 처음 블록의 모양 
          _block_color clB = [[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue]; // 현재 큐의 제일 처음 블록의 색
          
          CCSprite *cBShape = [CCSprite spriteWithFile:[self blockTypeFileName:tyB blockColor:clB]];
          cBShape.position = myBlk.position;
          //cBShape.opacity = 150;
          [self addChild:cBShape z:8];
          
          NSMutableArray *myBlkUnit = [NSMutableArray arrayWithObjects:myBlk, [NSNumber numberWithInt:x], [NSNumber numberWithInt:y], cBshadow, cBShape, nil];
          //          NSMutableArray *myBlkUnit = [NSMutableArray arrayWithObjects:myBlk, [NSNumber numberWithInt:x], [NSNumber numberWithInt:y], cBshadow, nil];
          //NSLog(@"map_mask[%d][%d] added to hintBlocks", x, y);
          [hintBlocks addObject:myBlkUnit];
        } else {
          //NSLog(@"여기다 둘 수 없음 map[%d][%d]", x, y);
        }

      } // of if map_mask[x][y] == 1
    } // of for y
  } // of for x
  // 힌트블록 세팅 완료  
}

-(void) removeHintBlocks
{
  for (NSMutableArray *myBlkUnit in hintBlocks)
  {
    [self removeChild:[myBlkUnit objectAtIndex:0] cleanup:YES]; // 블록 본체
    [self removeChild:[myBlkUnit objectAtIndex:3] cleanup:YES]; // 블록 그림자         
    [self removeChild:[myBlkUnit objectAtIndex:4] cleanup:YES]; // 블록 색/모양       
  }
}

-(void) removeReadyBlocks
{
  for (NSMutableArray *rBUnit in readyBlocks) 
  {
    [self removeChild:[rBUnit objectAtIndex:0] cleanup:YES];
    [self removeChild:[rBUnit objectAtIndex:2] cleanup:YES];
  }
  readyBlocks = [[NSMutableArray alloc] init]; // reset
}

-(void) mainGameLoop
{
  /*
   // 1. 내 턴 - 블록 선택 
   // 2. 선택한 블록으로 힌트 블록 구성 
   // 3. 
  // game over 
  // 판정 
  */
  if (gameStatus == 1) // 내가 둘 곳을 정하기 
  {

//    gameStatus = 2; 
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
  int spriteSizeX = [spr boundingBox].size.width; //48;
  int spriteSizeY = [spr boundingBox].size.height; //48;
  // anchor가 디폴트로 가운데 있다고 가정 
  CGPoint sprPosition = ccpAdd(spr.position, diffCamera);

  float x1 = sprPosition.x - (spriteSizeX /2);
  float x2 = sprPosition.x + (spriteSizeX /2);
  float y1 = sprPosition.y - (spriteSizeY /2);
  float y2 = sprPosition.y + (spriteSizeY /2);
  // NSLog(@"(%.0f,%.0f)-(%.0f,%.0f) vs (%.0f,%.0f)", x1, x2,y1,y2, location.x, location.y);

  if( x1 > location.x || x2 < location.x || y1 > location.y || y2 < location.y)
  {    
    return NO;
  } else {
    // NSLog(@"CGRectContains");
    return YES; 

  }
}
//
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
    // 오른쪽 6개 블록 중에서 선택이 되었는가? 
    if (CGRectContainsPoint(blackBg.boundingBox, touchedlocation)) 
    {
      
      for (NSMutableArray *rbUnit in readyBlocks) 
      {
        CCSprite *rb = [rbUnit objectAtIndex:0];
        if (CGRectContainsPoint(rb.boundingBox, touchedlocation)) 
        {
          // 선택 !
          selectedBlock = [[rbUnit objectAtIndex:1] intValue];
          NSLog(@"%d touched", selectedBlock);
          [self removeHintBlocks];
          [self showHintBlocks:selectedBlock];             

          return;
        }
      }
    } else {
      // 일반 필드에서 선택 
      // 힌트 블록 중에서 터치 되었는가?
      
     for (NSMutableArray *myBlkUnit in hintBlocks)
     {
       CCSprite *myBlk = [myBlkUnit objectAtIndex:0];

       if ([self collusionWithSprite:myBlk location:touchedlocation] == YES) 
       {
         // myblk 자리에 블록을 놓고 
         int xx = [[myBlkUnit objectAtIndex:1] intValue];
         int yy = [[myBlkUnit objectAtIndex:2] intValue];
         // 선택 된 블록의 인덱스는? 
         [self setBlock:selectedBlock x:xx y:yy];
         // TODO
         map_mask[xx][yy] = 2;
         
         // 오른쪽 대기블록6개를 재배치 하기 위해 날려야 됨 
         //gameStatus = 3;
         //selectedBlock = 0;
         [self realignSixBlocksInQueue];
         break;
       } else {
         //NSLog(@"엉뚱한 클릭 ");
       }
     } // of for 
    } 

  } // of if touch == YES
}
//

// 두손가락으로 스크롤이 더 나을 듯? 
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
