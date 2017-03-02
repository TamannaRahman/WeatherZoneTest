//
//  ImageDownloader.h
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownloader : NSObject

+ (ImageDownloader*)sharedDownloader;
- (void )downloadImageForUrlString:(NSString*)urlString withCompletion:(void (^)(UIImage *image))completionBlock;

@end
