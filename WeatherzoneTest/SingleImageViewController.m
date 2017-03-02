//
//  SingleImageViewController.m
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import "SingleImageViewController.h"

@interface SingleImageViewController ()

@end

@implementation SingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showImageWithDetails];
    
}

-(void)showImageWithDetails{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, self.view.frame.size.height - 180)];
    
    [[ImageDownloader sharedDownloader]downloadImageForUrlString:self.singleImageUrl withCompletion:^(UIImage *image) {
        
        if (image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                
            });
        }
    }];
    
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapInView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInImageView:)];
    [imageView addGestureRecognizer:tapInView];
    
    
    UILabel *imageDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,imageView.frame.origin.y + imageView.frame.size.height + 10 ,self.view.frame.size.width - 20,100)];
    imageDataLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
    imageDataLabel.textColor = [UIColor whiteColor];
    imageDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    imageDataLabel.numberOfLines = 0;
    imageDataLabel.text = self.imageMetaData;
    [self.view addSubview:imageDataLabel];
}

-(void)tapInImageView:(UITapGestureRecognizer *)tap
{
   //show the image in web 
    NSURL *url = [NSURL URLWithString:self.singleImageUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
