//
//  AppDelegate.h
//  QBoard
//
//  Created by Choe Yong-uk on 12. 1. 23..
//  Copyright __MyCompanyName__ 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
