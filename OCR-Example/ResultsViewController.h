//
//  ResultsViewController.h
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController

@property (nonatomic, strong) UIView *loadingView;

@property (weak, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;

@end
