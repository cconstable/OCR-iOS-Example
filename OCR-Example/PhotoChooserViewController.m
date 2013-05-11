//
//  ViewController.m
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import "PhotoChooserViewController.h"
#import "ResultsViewController.h"

@interface PhotoChooserViewController ()
@property (nonatomic, strong) UIImage *selectedImage;
@end

@implementation PhotoChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Show process button
    if (self.selectedImage) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Process"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(processWasPressed:)];
        [self.navigationItem setRightBarButtonItem:barButton animated:YES];
        [self.selectedImageView setImage:self.selectedImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processWasPressed:(id)sender
{
    ResultsViewController *resultsVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"Results"];
    
    // Create loading view.
    resultsVC.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    resultsVC.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [resultsVC.view addSubview:resultsVC.loadingView];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
    [resultsVC.loadingView addSubview:activityView];
    activityView.center = resultsVC.loadingView.center;
    [activityView startAnimating];
    
    resultsVC.selectedImage = self.selectedImage;
    [resultsVC.selectedImageView setImage:self.selectedImage];
    
    // Push
    [self.navigationController pushViewController:resultsVC animated:YES];
    
}

- (IBAction)choosePhotoWasTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}

@end
