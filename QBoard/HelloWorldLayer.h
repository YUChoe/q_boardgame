//
//  HelloWorldLayer.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
  NSMutableArray *blocks; // 바닥에 깔린 블록들 
  NSMutableArray *hintBlocks; // 힌트로 사용 될 블록들 
  
  int map[40][40];        // 바닥에 깔린 블록들의 매트릭스 40x40 블록이 깔리면 1씩 카운트가 올라가서 
                          // blocks 의 objectAtIndex 값에 해당하는 정수가 들어감 시작은 중앙이니까 20,20에서 시작 
  int map_mask[40][40];   // 놓여질 수 있는 위치를 표시하기 위해 사용하는 배열 
  
  CCSprite *mB;           // 내가 붙일려고 하는 블록  
  CCSprite *mBshadow;     // 's shadow 
  CCSprite *warningBlock; // 경고 할 때 빨간 색으로 
  // 위의 것들을 묶어서 하나의 클래스로 만들어야 댐 .. 무늬 포함 

  int gameStatus; // 게임 현재 상태 0 초기화 부터 시작  
  CGPoint diffCamera;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(CGPoint) fromMapToPosition:(int)x y:(int)y; // xy 좌표로 ccp 값을 돌려 받는 메쏘드

-(void)mainGameLoop; // 메인 게임 루프 status 가 변화 될 때 마다 호출 됨  
@end
