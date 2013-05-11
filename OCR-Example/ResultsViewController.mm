//
//  ResultsViewController.m
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import "ResultsViewController.h"
#import "Tesseract.h"
#import "ImageProcessing.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Process the image.
    // Ideally, this shouldn't happen everytime the view appears but its a
    // sample.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"/tessdata" language:@"eng"];
        
        // Uncomment to only search for alpha-numeric characters.
        [tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" forKey:@"tessedit_char_whitelist"];
        
        // Shrink the image. Tesseract works better with smaller images than what the iPhone puts out.
        CGSize newSize = CGSizeMake(self.selectedImage.size.width / 3, self.selectedImage.size.height / 3);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [self.selectedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        ImageWrapper *greyScale=Image::createImage(resizedImage, resizedImage.size.width, resizedImage.size.height);        
        ImageWrapper *edges = greyScale.image->autoLocalThreshold();
        
        [tesseract setImage:edges.image->toUIImage()];
        [tesseract recognize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.loadingView.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 self.loadingView.hidden = YES;
                                 [self.resultsTextView setText:[tesseract recognizedText]];
                             }];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
