//
//  aBlock.m
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 25..
//  Copyright (c) 2012년 noizze.net. All rights reserved.
//
#import "aBlock.h"

@implementation aBlock

@synthesize shadow;
@synthesize shape;

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
  if( (self=[super initWithTexture:texture rect:rect]))
  {
  }
  return self;
}
-(void) putBlockAtPosition:(id)layer position:(CGPoint)customPosition type:(_block_type)blockType color:(_block_color)blockColor;
{
  [self setPosition:customPosition];
  
  // 인자값으로 들어 온 것을 내부 프로퍼티로 저장 
  blkType = blockType; 
  blkColor = blockColor;
  
  //2. 그림자 - 3디 효과 주기 
  shadow = [CCSprite spriteWithFile:@"woodenBlock_64x64.png"];
  //NSLog(@"(self.position.x+3, self.position.y-3)=(%.0f,%.0f)", self.position.x+3, self.position.y-3);
  shadow.position = CGPointMake(self.position.x+3, self.position.y-3);    
  shadow.color = ccc3(0,0,0);
  shadow.opacity = 128;
  shadow.scaleY = -1.0;
  
  //3. 모양 그리기 
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
    
  NSString *blockTypeFileName = [NSString stringWithFormat:@"blockType_%@_%@.png", blockTypeAsString, blockColorAsString];
  NSLog(@"blockTypeFileName:%@",blockTypeFileName);
  
  shape = [CCSprite spriteWithFile:blockTypeFileName];
  shape.position = self.position;

  [layer addChild:self z:10];
  [layer addChild:shadow z:9];
  [layer addChild:shape z:11];
}

@end
