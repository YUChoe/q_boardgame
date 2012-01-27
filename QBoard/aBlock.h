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
  blk_heart   = 0, // 
  blk_clover  = 1, //
  blk_cross   = 2, // 
  blk_spade   = 3,
  blk_diamond = 4,
  blk_circle  = 5
} _block_type;

typedef enum {
  blk_color_orange = 0,
  blk_color_yellow = 1,
  blk_color_cyan = 2,
  blk_color_green = 3,
  blk_color_red = 4,
  blk_color_purple = 5
} _block_color;

@interface aBlock : CCSprite {
  _block_type blkType;
  _block_color blkColor;
  
  CCSprite *shape; //타입에 따른 스페이드, 하트, 다이야, 클로버, 엑스, 원 
  CCSprite *shadow;
  
}

@property (nonatomic, retain) CCSprite *shadow;
@property (nonatomic, retain) CCSprite *shape;

@property (readonly) _block_type blkType;
@property (readonly) _block_color blkColor;

-(void) putBlockAtPosition:(id)layer position:(CGPoint)customPosition type:(_block_type)blockType color:(_block_color)blockColor;
-(NSString *)blockTypeFileName:(_block_type)blockType blockColor:(_block_color)blockColor;

//-(void) initShadow:(id)layer;

@end
