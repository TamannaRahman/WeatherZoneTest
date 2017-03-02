//
//  ViewController.m
//  WeatherzoneTest
//
//  Created by CQUGSR on 24/11/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import "ViewController.h"
#import "ImageDownloader.h"

@interface ViewController (){
    
    NSMutableArray *imageUrlArray;
    NSMutableArray *imageNameArray;
    NSMutableArray *imageCaptureDateArray;
    NSMutableArray *userNameArray;
    NSMutableArray *placeArray;
    UILabel *imageNameLabel;
    UILabel *imageCaptureDateLabel;
    NSISO8601DateFormatter *dateFormatter;
    UITextField *searchTextField;
    NSString *searchText;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dateFormatter = [[NSISO8601DateFormatter alloc] init];
    imageUrlArray = [[NSMutableArray alloc] init];
    imageNameArray = [[NSMutableArray alloc] init];
    imageCaptureDateArray = [[NSMutableArray alloc] init];
    userNameArray = [[NSMutableArray alloc] init];
    placeArray = [[NSMutableArray alloc] init];

    self.navigationItem.title = @"Weatherzone Test";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Georgia-Bold" size:18]}];

    
    [self createUICollectionView];
    [self createActivityIndicator];
    [self.activityIndicator startAnimating];
    [self parseImageData:[NSString stringWithFormat: @"https://api.500px.com/v1/photos?tag=weather&image_size=600&consumer_key=EKt3uVPNRFA327wXnGMSxPjGZaTKtM2UY3wUmOdU"]];
    [self createSearchBar];
    
    

}
-(void)createSearchBar{
   
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 60)];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.font = [UIFont fontWithName:@"Marker Felt" size:20];
    searchTextField.placeholder = @"Search Here";
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchTextField.keyboardType = UIKeyboardTypeDefault;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchTextField.delegate = self;
    [self.view endEditing:YES];
    [self.view addSubview:searchTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    searchText = textField.text;
    
    //if user search for specific image catagory, it changes the image fetching url and download data using the updated url
    
    if (searchText) {
        
        //avoid adding with the exieted image data
        [imageUrlArray removeAllObjects];
        [imageNameArray removeAllObjects];
        [imageCaptureDateArray removeAllObjects];
        [userNameArray removeAllObjects];
        [placeArray removeAllObjects];
        
        [self parseImageData:[NSString stringWithFormat: @"https://api.500px.com/v1/photos?tag=%@&image_size=600&consumer_key=EKt3uVPNRFA327wXnGMSxPjGZaTKtM2UY3wUmOdU",searchText]];
    }
    return NO;
}

-(void)createLabel{
    
    imageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,100,160,30)];
    imageNameLabel.font = [UIFont fontWithName:@"Marker Felt" size:18];
    imageNameLabel.textColor = [UIColor whiteColor];
    imageNameLabel.backgroundColor = [UIColor blackColor];
    imageNameLabel.textAlignment = NSTextAlignmentCenter;

    imageCaptureDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,130,160,30)];
    imageCaptureDateLabel.font = [UIFont fontWithName:@"Marker Felt" size:14];
    imageCaptureDateLabel.textColor = [UIColor whiteColor];
    imageCaptureDateLabel.backgroundColor = [UIColor blackColor];
    imageNameLabel.textAlignment = NSTextAlignmentCenter;

}
-(void)createUICollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,60,self.view.frame.size.width,600) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:_collectionView];

}

-(void)parseImageData:(NSString *)urlString{
    
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *images = [json objectForKey:@"photos"];

    for (NSDictionary *imageData in images)
    {
        [imageUrlArray addObject:[NSString stringWithFormat:@"%@",[imageData objectForKey:@"image_url"]]];
        
        [imageNameArray addObject:[NSString stringWithFormat:@"%@", [imageData objectForKey:@"name"]]];
        
        //fetched data formatted in human readable format and also eleminated the timezone part for better UI.
        NSString *imageCaptureDate = [NSString stringWithFormat:@"%@", [imageData objectForKey:@"created_at"]];
        NSDate *date = [dateFormatter dateFromString:imageCaptureDate];
        NSString *dateString = [NSString stringWithFormat:@"%@",date];
        dateString = [dateString substringToIndex: MIN(19, [dateString length])];
        [imageCaptureDateArray addObject:[NSString stringWithFormat:@"%@",dateString]];

        [userNameArray addObject:[NSString stringWithFormat:@"%@",[[imageData objectForKey:@"user"] objectForKey:@"fullname"]]];
        
        [placeArray addObject:[NSString stringWithFormat:@"%@,%@",[[imageData objectForKey:@"user"] objectForKey:@"city"],[[imageData objectForKey:@"user"] objectForKey:@"country"]]];
        
    }
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
  
    //helps to avoid duplication of objects in cell
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

        //image cache done to avoid frequent downloading for better performance and stability
        [[ImageDownloader sharedDownloader]downloadImageForUrlString:[imageUrlArray objectAtIndex:indexPath.row] withCompletion:^(UIImage *image) {
            
            if (image) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                    [self.activityIndicator stopAnimating];
                    
                });
            }
            
        }];

        cell.backgroundColor = [UIColor whiteColor];
        
        [self createLabel];
        
        imageNameLabel.text = [imageNameArray objectAtIndex:indexPath.row];
        imageCaptureDateLabel.text = [imageCaptureDateArray objectAtIndex:indexPath.row];
        
        // avoid duplication of label in cell
        for (UILabel *label in cell.contentView.subviews)
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                [label removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:imageNameLabel];
        [cell.contentView addSubview:imageCaptureDateLabel];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SingleImageViewController *singleImageView = [[SingleImageViewController alloc] init];
    singleImageView.singleImageUrl = [imageUrlArray objectAtIndex:indexPath.row];
    singleImageView.imageMetaData = [NSString stringWithFormat:@"User: %@\nImage Name: %@\nDate Taken: %@\nPlace: %@",[userNameArray objectAtIndex:indexPath.row],[imageNameArray objectAtIndex:indexPath.row], [imageCaptureDateArray objectAtIndex:indexPath.row], [placeArray objectAtIndex:indexPath.row],nil];
   
    [self.navigationController pushViewController:singleImageView animated:NO];


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}


-(void)createActivityIndicator{
    
    UIActivityIndicatorView *actInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    actInd.color=[UIColor whiteColor];
    [actInd setCenter:self.view.center];
    
    self.activityIndicator=actInd;
    [self.view addSubview:self.activityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
