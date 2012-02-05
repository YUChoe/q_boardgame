//
//  GamePlayLayer.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright noizze.net 2012년. All rights reserved.
//


// Import the interfaces
#import "GamePlayLayer.h"
#import <stdlib.h>
#import <time.h>

@implementation GamePlayLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePlayLayer *layer = [GamePlayLayer node];
	
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
  [self removeHintBlocks];
  if (map_mask[x][y+1] != 2) map_mask[x][y+1] = 1;
  if (map_mask[x][y-1] != 2) map_mask[x][y-1] = 1;
  if (map_mask[x+1][y] != 2) map_mask[x+1][y] = 1;
  if (map_mask[x-1][y] != 2) map_mask[x-1][y] = 1;

  // 블록을 다 놓았으니
  if (myTurn == YES) 
  {
   myScore = myScore + 1; // TODO: 연속해서 두는 경우 점수 증가 되어야 함  
  } else {
    oppScore = oppScore = 1;
  }
  
  [self drawScore]; // 점수를 그리고 
  [self realignSixBlocksInQueue]; //큐 정리 + 애니메이션 
  
}
//

// 화면 오른쪽에 내가 가지고 있는 (큐의 6개)블록을 보여주는 기능 
// 애니메이션이 있어도 좋을 듯? 
-(void) realignSixBlocksInQueue
{
  // 먼저 초기화
  [self removeReadyBlocks];

  // 레디블록 바닥에 까는 배경 (터치이벤트 확인 용)
  if ([self getChildByTag:101] == NULL)
  {
    blackBg = [CCSprite spriteWithFile:@"bg_black_48*288.png"];
    //오른쪽 구석인데.. 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    blackBg.position = CGPointMake(screenSize.width - 48/2, screenSize.height/2 + 16);
    // 너무 오른쪽에 붙었나 싶기는 한데 약간 투명하게 해 봐야지 
    blackBg.opacity = 128;
    [self addChild:blackBg z:26 tag:101];
  } else {
    // 이미 생성 되어 있다면 자리만 옮김 
    if (myTurn == YES)
    {
      CGSize screenSize = [[CCDirector sharedDirector] winSize];
      blackBg.position = CGPointMake(screenSize.width - 48/2, screenSize.height/2 + 16);      
    } else {
      blackBg.position = ccp(24, 144);
    }
  }
  
  if ([self getChildByTag:102] == NULL) 
  {
    passButton = [CCSprite spriteWithFile:@"pass_48*32.png"];
    passButton.position = CGPointMake(blackBg.position.x, blackBg.position.y - blackBg.boundingBox.size.height/2 - passButton.boundingBox.size.height/2);
    [self addChild:passButton z:26 tag:102];
  } else {
    // 이미 생성 되어 있으면 자리만 옮김
    if (myTurn == YES) {
      passButton.position = CGPointMake(blackBg.position.x, blackBg.position.y - blackBg.boundingBox.size.height/2 - passButton.boundingBox.size.height/2);
      passButton.rotation = 0;
    } else {
      passButton.position = ccp(24, 288+16);
      passButton.rotation = 180;
    }
  }
    
  
  // 남아 있는 블록이 12개 미만이면 ? 
  
  // 블록큐에서 0-5는 나의 레디블록
  for (int idx=0; idx<[blkQueue count]; idx++) 
  {
    if (idx > 5 || idx >= [blkQueue count]) break; 
    CCSprite *b = [CCSprite spriteWithFile:@"woodenBlock_48x48.png"];
    b.position = CGPointMake(blackBg.position.x, blackBg.position.y - 48*2 - 48/2 + idx*48);
    [self addChild:b z:27];
    
    CCSprite *s = [CCSprite spriteWithFile:[self blockTypeFileName:[[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue] blockColor:[[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue]]];
    s.position = b.position;
    [self addChild:s z:28];
    
    if (myTurn != YES) {
      b.visible = NO;
      s.visible = NO;
    }
    
    NSMutableArray *rBUnit = [NSMutableArray arrayWithObjects:b, [NSNumber numberWithInt:idx], s, nil];
    [readyBlocks addObject:rBUnit];
  }


  // 블록큐에서 마지막 6개(count-7 : count -1) 는 상대의 레디블록 
  int cnt = 0;
  for (int idx=([blkQueue count]-1); idx>([blkQueue count]-7); idx--)
  {
    // 레디블록을 침범 했으면 break? 
    //
    CCSprite *b = [CCSprite spriteWithFile:@"woodenBlock_48x48.png"];

    CCSprite *counterSprite = [[readyBlocks objectAtIndex:cnt] objectAtIndex:0];
    //b.position = ccp((counterSprite.position.x - 48), counterSprite.position.y);
    b.position = ccp(24, counterSprite.position.y);
    [self addChild:b z:27];
    
    // shape
    CCSprite *s = [CCSprite spriteWithFile:[self blockTypeFileName:[[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue] blockColor:[[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue]]];
    s.position = b.position;
    s.rotation = 180; // 뒤집는다 
    [self addChild:s z:28];
    
    if (myTurn != NO) {
      b.visible = NO;
      s.visible = NO;
    }
    
    NSMutableArray *rBUnit = [NSMutableArray arrayWithObjects:b, [NSNumber numberWithInt:idx], s, nil];
    [opponentReadyBlocks addObject:rBUnit];
    cnt++;
  }
  
  // 아무것도 선택하지 않은 상태이니 
  selectedBlock = -1;
}
//

// 이 메소드가 핵심 !!
// x,y 위치에서 dir 방향으로 블록을 놓을 수 있는 지 검사하는 로직 
-(BOOL) possibleTo:(NSString*)dir blockType:(_block_type)tb blockColor:(_block_color)cb x:(int)x y:(int)y
{
  if (map[x][y]!=0) return NO; // 이미 블록이 있으면 여기 못둠 
  
  NSMutableArray *nBlocks = [[NSMutableArray alloc] init];
  
  if (dir == @"North")
  {
    if ((y+1) < 40 && map[x][y+1] == 0) { //NSLog(@"[%d][%d]-%@=빈칸", x, y, dir); 
      return YES; }    // 바로 빈칸이면 둘 수 있음 
    for(int yy=y+1; yy<40; yy++)
    { 
      if (map[x][yy] == 0) break; // 빈칸이 나오면 루프 정지
      NSMutableArray *bu = [blocks objectAtIndex:(map[x][yy]-1)];
      //if ([[bu objectAtIndex:3] intValue] != tb) break; // 중간에 모양이 바뀌면 루프 정지 
      // 중간에 색이 바뀌면?
      // 0:blocktype, 1:blockcolor
      NSMutableArray *type_color = [NSMutableArray arrayWithObjects:[bu objectAtIndex:3], [bu objectAtIndex:4], nil];
      [nBlocks addObject:type_color];
    }
  } else if (dir == @"South")
  {
    if (y-1 >= 0 && map[x][y-1]==0) { //NSLog(@"[%d][%d]-%@=빈칸", x, y, dir); 
      return YES; }
    for(int yy=y-1; yy>=0; yy--)
    {
      if (map[x][yy] == 0) break; 
      NSMutableArray *bu = [blocks objectAtIndex:(map[x][yy]-1)];
      //if ([[bu objectAtIndex:3] intValue] != tb) break;
      NSMutableArray *type_color = [NSMutableArray arrayWithObjects:[bu objectAtIndex:3], [bu objectAtIndex:4], nil];
      [nBlocks addObject:type_color];
    }
  } else if (dir == @"East")
  {
    if (x+1 < 40 && map[x+1][y]==0) { //NSLog(@"[%d][%d]-%@=빈칸", x, y, dir); 
      return YES; }
    for(int xx=x+1; xx<40; xx++)
    {
      if (map[xx][y] == 0) break;
      NSMutableArray *bu = [blocks objectAtIndex:(map[xx][y]-1)];
      NSMutableArray *type_color = [NSMutableArray arrayWithObjects:[bu objectAtIndex:3], [bu objectAtIndex:4], nil];
      [nBlocks addObject:type_color];
    }
  } else if (dir == @"West")
  {
    if (x-1 >= 0 && map[x-1][y]==0) { //NSLog(@"[%d][%d]-%@=빈칸", x, y, dir); 
      return YES; }
    for(int xx=x-1; xx>=0; xx--)
    {
      if (map[xx][y] == 0) break;
      NSMutableArray *bu = [blocks objectAtIndex:(map[xx][y]-1)];
      NSMutableArray *type_color = [NSMutableArray arrayWithObjects:[bu objectAtIndex:3], [bu objectAtIndex:4], nil];
      [nBlocks addObject:type_color];
    }
  }
  
  if ([nBlocks count]==0) { //NSLog(@"[%d][%d]-%@=빈칸2", x, y, dir); 
    return YES; 
  }  

  // 빈칸이 아닌 경우
  if ([[[nBlocks objectAtIndex:0] objectAtIndex:0] intValue] == tb)  // 블록이 모양이 일치하는가? 
  {
    //NSLog(@"[%d][%d]의 %@ 쪽 블록 모양이 일치", x,y,dir);
    for(NSMutableArray *type_color in nBlocks)
    {
      // 이 중에 색이 일치하는게 하나도 없어야 함..
      //NSLog(@"색 비교 %d:%d", [[type_color objectAtIndex:1] intValue], cb);
      if ([[type_color objectAtIndex:1] intValue] == cb) return NO;
      
      // 모양이 바뀌면 안됨
      //NSLog(@"모양비교 %d:%d", [[type_color objectAtIndex:0] intValue], tb);      
      if ([[type_color objectAtIndex:0] intValue] != tb) return NO;
    }
    // 결격사유 없음 
    return YES; 
  } else 
  if ([[[nBlocks objectAtIndex:0] objectAtIndex:1] intValue] == cb)  // 바로 위 블록이 색이 일치 하는가? 
  {
    //NSLog(@"[%d][%d]의 %@ 쪽 블록 색이 일치", x,y,dir);
    for(NSMutableArray *type_color in nBlocks)
    {
      // 이 중에 같은 모양이 하나도 없어야 함 
      //NSLog(@"모양비교 %d:%d", [[type_color objectAtIndex:0] intValue], tb);
      if ([[type_color objectAtIndex:0] intValue] == tb) return NO;
      //근데 색이 바뀌면 안됨 
      //NSLog(@"색 비교 %d:%d", [[type_color objectAtIndex:1] intValue], cb);
      if ([[type_color objectAtIndex:1] intValue] != cb) return NO;
    }
    return YES; 
  }
  
//  NSLog(@"조건을 모두 통과 해서 [%d][%d]의 %@에 둘 수 있음 ", x,y, dir);
  
  return NO;
}

// 위치 x,y에 블록을 상하좌우 방향으로 놓을 수 있는지 검사하는 메소드 
-(BOOL) possibleGuess:(int)idx x:(int)x y:(int)y
{
  // 범위 체크 
  if (x < 0 || y < 0 || x > 39 || y > 39) return NO;
  // 체크 하고 싶은 위치가 오니까 십중팔구 비어 있는 셀임.. 셀이란 용어는 여기서 처음 사용 됨 
  // 큐의 0번 블록을 기준으로 
  _block_type tb = [[[blkQueue objectAtIndex:idx] objectAtIndex:1] intValue];
  _block_color cb = [[[blkQueue objectAtIndex:idx] objectAtIndex:2] intValue];

  if ([self possibleTo:@"North" blockType:tb blockColor:cb x:x y:y] == YES 
      && [self possibleTo:@"South" blockType:tb blockColor:cb x:x y:y] == YES 
      && [self possibleTo:@"East" blockType:tb blockColor:cb x:x y:y] == YES 
      && [self possibleTo:@"West" blockType:tb blockColor:cb x:x y:y] == YES  
      ) { return YES; }

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
  else if (blockType == blk_star)   { blockTypeAsString = @"star"; } 
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

//
-(void) drawScore
{
  if ([self getChildByTag:300] != NULL) [self removeChildByTag:300 cleanup:YES];
  
  NSString *score_text = [NSString stringWithFormat:@"Score %03d : %03d", myScore, oppScore];
  CCLabelTTF *score_label = [CCLabelTTF labelWithString:score_text
                                            dimensions:CGSizeMake(200, 20) // width, height 
                                             alignment:CCTextAlignmentCenter
                                              fontName:@"Helvetica" 
                                              fontSize:18];
  score_label.position = ccp(48+90, 320-14);
  [self addChild:score_label z:150 tag:300];
}
//

// 스테이지 시작 할 때 블록의 6모양 * 6색 * 2벌 = 64개를 정의 하고 섞는 메소드 
-(void) initAndShuffleBlocks
{
  blkQueue = [[NSMutableArray alloc] init];
  
  for (int s = 1; s<=2; s++) // 2set
  {
    for (int shape=0; shape<=5; shape++) // 6모양
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

// TODO: 나중에 광고도 띄워야 함  모달 alert 창 메소드 
-(void) popAlert1
{
  onAlert = YES;
  popMode = 1;
  CCSprite *aWin = [CCSprite spriteWithFile:@"alert_background.png"];
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  
  // 여기다 놓으면 화면 중앙이 아니라 스크롤 되기 전 중앙에 놓이게 될 텐데? 
  aWin.position = ccp( screenSize.width /2 +diffCamera.x, screenSize.height/2 +diffCamera.y); // center 
  if (myTurn == NO) aWin.rotation = 180;
  [self addChild:aWin z:100 tag:250];
  
  CCLabelTTF *lbl_text = [CCLabelTTF labelWithString:@"선택 한 블록은 놓을 수 없습니다." 
                                          dimensions:CGSizeMake(280, 70) // width, height 
                                           alignment:CCTextAlignmentCenter
                                            fontName:@"Helvetica" 
                                            fontSize:18];
  
  lbl_text.position = ccp( [aWin boundingBox].size.width/2, [aWin boundingBox].size.height/2 + 20); // center 
  lbl_text.color = ccc3(255, 255, 255); // white
  [aWin addChild:lbl_text z:101];
  
  CCSprite *ybtn = [CCSprite spriteWithFile:@"yesButton_126*42.png"];
  if (myTurn == NO)
  {
    ybtn.rotation = 180;
    ybtn.position = ccp( aWin.position.x, aWin.position.y + 50 ); 
  } else {
    ybtn.position = ccp( aWin.position.x, aWin.position.y - 50 ); 
  }

  [self addChild:ybtn z:102 tag:251];
}

// YESNO 모드 
-(void) popAlert2
{
  onAlert = YES;
  popMode = 2;
  CCSprite *aWin = [CCSprite spriteWithFile:@"alert_background.png"];
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  aWin.position = ccp( screenSize.width /2 +diffCamera.x, screenSize.height/2 +diffCamera.y); // center 
  if (myTurn == NO) aWin.rotation = 180;
  [self addChild:aWin z:100 tag:250];
  
  CCLabelTTF *lbl_text = [CCLabelTTF labelWithString:@"차례를 넘기겠습니까?" 
                                          dimensions:CGSizeMake(280, 70) // width, height 
                                           alignment:CCTextAlignmentCenter
                                            fontName:@"Helvetica" 
                                            fontSize:18];
  
  lbl_text.position = ccp( [aWin boundingBox].size.width/2, [aWin boundingBox].size.height/2 + 20); // center 
  //lbl_text.anchorPoint = ccp(320-280,10/2);
  lbl_text.color = ccc3(255, 255, 255); // white
  [aWin addChild:lbl_text z:101];
  
  CCSprite *ybtn = [CCSprite spriteWithFile:@"yesButton_126*42.png"];
  CCSprite *nbtn = [CCSprite spriteWithFile:@"noButton_126*42.png"];
  if (myTurn == NO) {
    ybtn.rotation = 180;
    nbtn.rotation = 180;
    ybtn.position = ccp( aWin.position.x + 5 + 126/2 , aWin.position.y + 50);
    nbtn.position = ccp( aWin.position.x - 5 - 126/2 , aWin.position.y + 50);
  } else {
    ybtn.position = ccp( aWin.position.x - 5 - 126/2 , aWin.position.y - 50);
    nbtn.position = ccp( aWin.position.x + 5 + 126/2 , aWin.position.y - 50);
  }

  [self addChild:ybtn z:102 tag:251];
  [self addChild:nbtn z:102 tag:252];
}


// 이건 공통으로 사용 할 수 있는 걸까 
-(void)removeAlert
{
  // alert popup and script 
  [self removeChildByTag:250 cleanup:YES];
  // yes button
  if ([self getChildByTag:251] != NULL) [self removeChildByTag:251 cleanup:YES];
  // no button
  if ([self getChildByTag:252] != NULL) [self removeChildByTag:252 cleanup:YES];
  onAlert = NO;
}

// cocos2d scene 초기화 
-(id) init
{
	if( (self=[super init])) 
  {
    self.isTouchEnabled = YES;
    onAlert = NO;
    animateRBlocks = NO;

    blocks = [[NSMutableArray alloc] init];
    readyBlocks = [[NSMutableArray alloc] init];
    opponentReadyBlocks = [[NSMutableArray alloc] init];
    
    diffCamera = ccp(0,0); // 스크롤로 이동 된 카메라의 위치.. 터치 좌표를 상대좌표로 보정하기 위해 필요 
    
    myScore = 0;
    oppScore = 0;
    
    // z:0 으로 배경 깔기 
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *linenBG = [CCSprite spriteWithFile:@"greenLinen_640x640.jpg"];
    linenBG.position = ccp( screenSize.width /2 , screenSize.height/2 ); // center 
    //[linenBG setScale:3.0f];
    [self addChild:linenBG z:0 tag:100];
    // 40*40 전체에 맞게 확장하면 안그래도 jpg파일 용량이 300k 넘어 가는데, 성능에 문제가 될 수도?
    // 차라리 카메라 이동 할 때 다시 센터로 돌아가면? 
    
    [self initAndShuffleBlocks]; // 1stage 에 사용 될 블록 정의 64개 

    myTurn = YES; // 내 턴 부터 시작 
    // TODO: 나중엔 랜덤으로 하던지 주사위를 굴리던지 해야 함 
    
    [self realignSixBlocksInQueue];
    [self setBlock:0 x:20 y:20];    // 먼저 센터에 기준 블록 하나를 위의 블록큐에서 놓으면 턴이 끝나는거아닌가? 
	}
  
	return self;
}
//

// 대기 블록을 터치 해서 blockQueue의 인덱스를 넘겨주면 해당하는 모양/색의 힌트 블록을 보여주는 메소드 
-(void) showHintBlocks:(int)idx
{
  BOOL poss = NO; // 둘 곳이 1군데라도 있으면 YES
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
          poss = YES;
        } else {
          //NSLog(@"여기다 둘 수 없음 map[%d][%d]", x, y);
        }

      } // of if map_mask[x][y] == 1
    } // of for y
  } // of for x
  if (poss == NO) // 한군데도 없음 
  {
    [self popAlert1];
  }
  // 힌트블록 세팅 완료  
}
//

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
  // 그리고 나서 순식간에 지워 버리면 티 안남 
  NSLog(@"지우고 애니메이션 할 블록인덱스: %d", selectedBlock);
  //만약에 다른걸 선택해서 지운 거면 ? 두가지는 구분 되어야 함 
  /*
  if (selectedBlock != -1 && selectedBlock != 0)
  {
    // TODO: 놓은 블록 인덱스를 알고 있으니 그놈을 지우고 
    // 그것 보다 위에 있는 블록 5번까지에 대해 48픽셀 만큼 아래로 떨어지는 애니메이션(1초정도?)
    // 그리고 쿵 소리 
    NSMutableArray *rBUnit = [readyBlocks objectAtIndex:selectedBlock];
    [self removeChild:[rBUnit objectAtIndex:0] cleanup:YES];
    [self removeChild:[rBUnit objectAtIndex:2] cleanup:YES];

    animateRBlocks = YES;
 
    for (int idx=selectedBlock; idx<5; idx++) 
    {
      id dropMove = [CCMoveBy actionWithDuration:1.0f position:ccp(0,-48)];
      id move_ease_in = [CCEaseIn actionWithAction:[[dropMove copy] autorelease] rate:3.0f];
      [[[readyBlocks objectAtIndex:idx] objectAtIndex:0] runAction:move_ease_in];
      NSLog(@"action!") ;
    }
    // 시퀀스가 모두 끝나야 
    animateBLocks = NO;
  } else {
    */
    for (NSMutableArray *rBUnit in readyBlocks) 
    {
      [self removeChild:[rBUnit objectAtIndex:0] cleanup:YES];
      [self removeChild:[rBUnit objectAtIndex:2] cleanup:YES];
    }
      
    for (NSMutableArray *oRBunit in opponentReadyBlocks)
    {
      [self removeChild:[oRBunit objectAtIndex:0] cleanup:YES];
      [self removeChild:[oRBunit objectAtIndex:2] cleanup:YES];
    }
  
  
 // }
  readyBlocks = [[NSMutableArray alloc] init]; // reset
  opponentReadyBlocks = [[NSMutableArray alloc] init]; // reset
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

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

// 여기 모든 이벤트 처리가 들어있다 
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  UITouch *touch = [touches anyObject];
  
  if (touch)
  {
    CGPoint touchedlocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView:touch.view]];

    // 알림창이 떠 있을때의 처리 //////////////////////
    if (onAlert == YES) 
    {
      NSLog(@"popMode=%d", popMode);
      if (popMode == 1) // 여기에 둘 수 없습니다
      {
        //CCSprite *awin = (CCSprite *)[self getChildByTag:250];// 팝업 자체 
        CCSprite *button = (CCSprite *)[self getChildByTag:251];
        //if (CGRectContainsPoint(button.boundingBox, touchedlocation))
        if ([self collusionWithSprite:button location:touchedlocation])
        { 
          [self removeAlert];
        }
      } else if (popMode == 2) //
      {
        //CCSprite *awin = [self getChildByTag:250];// 팝업 자체 
        CCSprite *yesButton = (CCSprite *)[self getChildByTag:251];
        CCSprite *noButton = (CCSprite *)[self getChildByTag:252];

        if ([self collusionWithSprite:noButton location:touchedlocation])
        { 
          // 아니오 눌렀으니 창 닫고 다시 원위치 
          [self removeAlert];
        } else if ([self collusionWithSprite:yesButton location:touchedlocation])

        {
          // 예 
          // 창 닫고 
          [self removeAlert];
          // 턴 넘기고 
          myTurn = !myTurn;
          // 레디블록 다시 그리고 
          [self realignSixBlocksInQueue];
        }
        
        
        
      }
      return; // 아래쪽은 어떻게든 진행하지 않음 
    }
    //
    
    // 오른쪽 6개 블록 중에서 선택이 되었는가? /////////
    if ([self collusionWithSprite:blackBg location:touchedlocation])
    {
      //NSLog(@"touch on blockQueue");
      if (myTurn == YES)
      {
        for (NSMutableArray *rbUnit in readyBlocks) 
        {
          CCSprite *rb = [rbUnit objectAtIndex:0];
          if ([self collusionWithSprite:rb location:touchedlocation])
          {
            // 선택 !
            selectedBlock = [[rbUnit objectAtIndex:1] intValue];
            //NSLog(@"%d touched", selectedBlock);
            [self removeHintBlocks];
            [self showHintBlocks:selectedBlock];             
            
            return;
          }
        } // of for 
      } else {
        // myTurn == NO
        for (NSMutableArray *rbUnit in opponentReadyBlocks) 
        {
          CCSprite *rb = [rbUnit objectAtIndex:0];
          if ([self collusionWithSprite:rb location:touchedlocation])
          {
            // 선택 !
            selectedBlock = [[rbUnit objectAtIndex:1] intValue];
            //NSLog(@"%d touched", selectedBlock);
            [self removeHintBlocks];
            [self showHintBlocks:selectedBlock];             
            
            return;
          }
        } // of for         
      }
      
    } else if ([self collusionWithSprite:passButton location:touchedlocation])
    {
      //[self popAlert:@"YESNO" msg:@"턴을 넘기겠습니까?"];
      [self popAlert2];
      
    } else {       // 일반 필드에서 선택 

      // 힌트 블록 중에서 터치 되었는가?
      if (selectedBlock == -1) return;
      
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
          //selectedBlock = 0;
          myTurn = !myTurn;
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
  
  if (onAlert == YES) return;
  
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
    
    
    // 
    blackBg.position = ccpAdd(blackBg.position, ccp(-diff.x, -diff.y));
    passButton.position = ccpAdd(passButton.position, ccp(-diff.x, -diff.y)); 
    
    [self getChildByTag:100].position = ccpAdd([self getChildByTag:100].position, ccp(-diff.x, -diff.y));
    for (NSMutableArray *rbUnit in readyBlocks)
    {
      CCSprite *rbBody = [rbUnit objectAtIndex:0];
      CCSprite *rbShape = [rbUnit objectAtIndex:2]; 
      rbBody.position = ccpAdd(rbBody.position, ccp(-diff.x, -diff.y));
      rbShape.position = ccpAdd(rbShape.position, ccp(-diff.x, -diff.y)); 
    }
    
    for (NSMutableArray *rbUnit in opponentReadyBlocks)
    {
      CCSprite *rbBody = [rbUnit objectAtIndex:0];
      CCSprite *rbShape = [rbUnit objectAtIndex:2]; 
      rbBody.position = ccpAdd(rbBody.position, ccp(-diff.x, -diff.y));
      rbShape.position = ccpAdd(rbShape.position, ccp(-diff.x, -diff.y)); 
    }    
    //
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
