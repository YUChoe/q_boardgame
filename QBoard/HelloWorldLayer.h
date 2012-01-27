//
//  HelloWorldLayer.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "aBlock.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
  NSMutableArray *blocks;     // 바닥에 깔린 블록들 
  NSMutableArray *hintBlocks; // 힌트로 사용 될 블록들 
  NSMutableArray *blkQueue;   // 6colours * 6shapes * 2set = 64개 블록이 초기화 되면 목록별로 들어감 
  
  int map[40][40];        // 바닥에 깔린 블록들의 매트릭스 40x40 블록이 깔리면 1씩 카운트가 올라가서 
                          // blocks 의 objectAtIndex 값에 해당하는 정수가 들어감 시작은 중앙이니까 20,20에서 시작 
  int map_mask[40][40];   // 놓여질 수 있는 위치를 표시하기 위해 사용하는 배열 

  int selectedBlock;      // 선택한 블록 
  
  CCSprite *mB;           // 내가 붙일려고 하는 블록  
  CCSprite *mBshadow;     // 's shadow 
  CCSprite *warningBlock; // 경고 할 때 빨간 색으로 
  // 위의 것들을 묶어서 하나의 클래스로 만들어야 댐 .. 무늬 포함
  
  CCSprite *blackBg; // 대기중 블록을 위한 오른쪽 자리 
  NSMutableArray *readyBlocks; // 블록큐 0-5 인데 굳이 필요 할까 ? 화면에 출력하고 애니메이션 하기 위함이긴 한데 
  
  int gameStatus; // 게임 현재 상태 0 초기화 부터 시작  
  CGPoint diffCamera;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)setBlock:(int)idx x:(int)x y:(int)y;
-(CGPoint) fromMapToPosition:(int)x y:(int)y; // xy 좌표로 ccp 값을 돌려 받는 메쏘드
-(BOOL) possibleGuess:(int)idx x:(int)x y:(int)y;
-(NSString *)blockTypeFileName:(_block_type)blockType blockColor:(_block_color)blockColor; // 중복정의 
-(void) realignSixBlocksInQueue;
-(void) removeReadyBlocks;
-(void) removeHintBlocks;
-(void)mainGameLoop; // 메인 게임 루프 status 가 변화 될 때 마다 호출 됨  
@end
