//
//  PictureCollectionViewController.m
//  Annotation
//
//  Created by 이삼구 on 10/02/2019.
//  Copyright © 2019 doai.ai. All rights reserved.
//

#import "PictureCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "AnnotationViewController.h"

@interface PictureCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) NSMutableArray *responseOsRawPictures;
@end

@implementation PictureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self performSegueWithIdentifier:@"showIntroduce" sender:self];

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.responseOsRawPictures   = [NSMutableArray array];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    NSString *url = [API_SERVER_PREFIX stringByAppendingString:@"os_raw_pictures.json"];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             self.responseOsRawPictures = responseObject[@"data"];
             [self.collectionView reloadData];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
}

- (IBAction)presentImagePicker:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *addPictureImagePicker = [[UIImagePickerController alloc] init];
        addPictureImagePicker.delegate = self;
        [addPictureImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        addPictureImagePicker.modalPresentationStyle = UIModalPresentationPopover;
        addPictureImagePicker.popoverPresentationController.barButtonItem = sender;
        
        [self presentViewController:addPictureImagePicker animated:YES completion:nil];

    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Permission!"
                                     message:@"Allow Photo Library Permission."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* goSettingButton = [UIAlertAction
                                    actionWithTitle:@"Go Setting"
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action) {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=PHOTOS"] options:@{} completionHandler:nil];
                                    }];
        
        UIAlertAction* closeButton = [UIAlertAction
                                   actionWithTitle:@"Close"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:goSettingButton];
        [alert addAction:closeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showAnnotationViewController"]) {
        AnnotationViewController *annotationViewController = [segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        annotationViewController.responseOsRawPicture = self.responseOsRawPictures[indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showAnnotationViewController" sender:indexPath];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.responseOsRawPictures count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *original_name =self.responseOsRawPictures[indexPath.row][@"OsRawPicture"][@"original_name"];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[API_SERVER_PREFIX stringByAppendingString:original_name]]
                 placeholderImage:[UIImage imageNamed:@"doai_logo.jpg"]];
    cell.backgroundView = imageView;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"performAction");
}

@end
