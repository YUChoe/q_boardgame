//
//  menuLayer.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 7..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface menuLayer : CCLayer {
  UIButton *newGameButton;
  //UIButton *continueButton;
  UIButton *optionsButton;
  UIButton *creditsButton;
  
  
}

+(CCScene *) scene;

-(void)displayUI;

-(void) newGameTouched:(id)sender;
-(void) optionsTouched:(id)sender;
-(void) creditsTouched:(id)sender;

@end
