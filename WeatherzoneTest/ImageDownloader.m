//
//  ImageDownloader.m
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.//

#import "ImageDownloader.h"
#import "AppDelegate.h"



#define kAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]


@implementation ImageDownloader


+ (ImageDownloader*)sharedDownloader{

    static ImageDownloader *downloader = nil;

    @synchronized (self) {
        if (!downloader) {
            downloader = [[ImageDownloader alloc]init];
        }
    }
    return downloader;
}


- (void )downloadImageForUrlString:(NSString*)urlString withCompletion:(void (^)(UIImage *image))completionBlock{

    if (urlString) {
    
        
        UIImage *iconImage = [self imageForUrlString:urlString];
        if (iconImage){
            completionBlock(iconImage);
        }
        else{
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
            
            static NSOperationQueue *operationQueue;
            if (!operationQueue) {
                operationQueue = [[NSOperationQueue alloc] init];
            }
            operationQueue.maxConcurrentOperationCount = 2;
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            request.timeoutInterval = 300;
            
            [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *imgData, NSError *connectionError) {
                if (imgData){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self saveImageForUrlString:urlString imageData:imgData];
                        completionBlock([UIImage imageWithData:imgData]);
                        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                        
                    });
                }
                else{
                    NSLog(@"image download error: %@", connectionError.localizedDescription);
                    completionBlock(nil);
                    
                }
            }];
        }
    }
    
}


- (void)saveImageForUrlString:(NSString*)urlString imageData:(NSData*)data{
    
    NSError *writeError = nil;
    NSString *imageFileName = [[kAppDelegate savingDirectoryPath] stringByAppendingPathComponent:[urlString lastPathComponent]];
    
    //NSLog(@"%@", imageFileName);
    
    [data writeToFile:imageFileName atomically:NO];
    
    
    [kAppDelegate addSkipBackupAttributeToItemAtPath:[NSURL fileURLWithPath:imageFileName]];
    
    
    if (writeError) {
        NSLog(@"Error writing file: %@", writeError);
    }
}


- (UIImage*)imageForUrlString:(NSString*)urlString{
    
    NSString *imageFileName = [[kAppDelegate savingDirectoryPath] stringByAppendingPathComponent:[urlString lastPathComponent]];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imageFileName];
    
    //if (img)
    //    NSLog(@"yes image");
    
    return img;
}

@end
