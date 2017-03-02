//
//  ViewController.h
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleImageViewController.h"

@interface ViewController : UIViewController< UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

