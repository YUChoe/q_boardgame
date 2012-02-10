//
//  optionsLayer.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptionsLayer : CCLayer {
  UILabel *op;
  
  UILabel *eflbl;
  UISwitch *effectSoundOnOff;
  
  //UILabel *fliplbl;
  //UISwitch *flipOnOff;
  
  UIButton *backButton;
}

+(CCScene *) scene;

- (void) displayUI;
- (void) backTouched:(id)sender;

@end

#define CONFIG_FILE_NAME @"config.xml"

NSString *GameDataFilePath(NSString *filename);
