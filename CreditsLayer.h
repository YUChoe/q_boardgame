//
//  CreditsLayer.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 2. 8..
//  Copyright 2012년 noizze.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CreditsLayer : CCLayer {
  UITextView *CreditsTextView;
  UIButton *backButton;
}

+(CCScene *) scene;

- (void) displayUI:(id)sender;
- (void) backTouched:(id)sender;

@end