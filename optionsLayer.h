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
  UIButton *backButton;
}

+(CCScene *) scene;

- (void) displayUI:(id)sender;

- (void) backTouched:(id)sender;

@end

#define CONFIG_FILE_NAME "config.xml"
