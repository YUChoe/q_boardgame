//
//  aBlock.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 25..
//  Copyright (c) 2012년 noizze.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

typedef enum {
  blk_spade,
  blk_heart,
  blk_diamond,
  blk_clover,
  blk_cross,
  blk_circle
} _block_type;

typedef enum {
  blk_color_orange,
  blk_color_yellow,
  blk_color_cyan,
  blk_color_green,
  blk_color_red,
  blk_color_purple
} _block_color;

@interface aBlock : CCSprite {
  _block_type blkType;
  _block_color blkColor;
  
  CCSprite *shape; //타입에 따른 스페이드, 하트, 다이야, 클로버, 엑스, 원 
  CCSprite *shadow;
  
}

@property (nonatomic, retain) CCSprite *shadow;
@property (nonatomic, retain) CCSprite *shape;

-(void) putBlockAtPosition:(id)layer position:(CGPoint)customPosition type:(_block_type)blockType color:(_block_color)blockColor;
//-(void) initShadow:(id)layer;

@end
