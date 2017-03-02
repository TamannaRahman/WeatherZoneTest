//
//  AppDelegate.h
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;


- (BOOL)addSkipBackupAttributeToItemAtPath:(NSURL *) URL;
- (NSString*)savingDirectoryPath;

@end

