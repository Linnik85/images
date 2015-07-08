//
//  ITImagePresentViewController.m
//  images
//
//  Created by Линник Александр on 03.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITImagePresentViewController.h"
#import "SVProgressHUD.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"


@interface ITImagePresentViewController ()

@end

@implementation ITImagePresentViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self settingNavigationBar];
    
    [self setTitle:[NSString stringWithFormat: @"Image %ld",(long)self.imageItem.imageID]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    
    [tapRecognizer addTarget:self action:@selector(imageTapped)];
    
    

    
    [self.imageViewOutlet addGestureRecognizer:tapRecognizer];
    
    self.imageViewOutlet.userInteractionEnabled = YES;
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorResponds:)
                                                 name:@"ErrorNotitfication"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImageList:)
                                                 name:@"UpdateImageNotitfication"
                                               object:nil];
    
    if (!self.imageItem.imageData.length>0) {
        
        [SVProgressHUD show];
        
        [self.settings.modelImages getImageByID:self.imageItem.imageID];
        
    } else {
        
        self.imageViewOutlet.image = [UIImage imageWithData:self.imageItem.imageData];
        
    }

    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ErrorNotitfication" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateImageNotitfication" object:nil];


}



#pragma mark - Notification


-(void) updateImageList:(NSNotification*)notification{
    
    [SVProgressHUD dismiss];

    if ([[notification object] isKindOfClass:[NSData class]]) {
        
        self.imageItem.imageData = [notification object];
        
        self.imageViewOutlet.image = [UIImage imageWithData:self.imageItem.imageData];

        CGSize newSize = CGSizeMake(50.0f, 50.0f);

        self.imageItem.imagePreviewData = [self resizeImage:self.imageViewOutlet.image toSize:newSize];
        
        self.imageItem.imageSize = [NSByteCountFormatter stringFromByteCount:self.imageItem.imageData.length countStyle:NSByteCountFormatterCountStyleFile];
        
        [self.settings.modelImages saveToCashe];
        
    }
    
}

-(void) errorResponds:(NSNotification*)notification {
    
    
    if ([[notification object] isKindOfClass:[NSString class]]) {
        
        [SVProgressHUD dismiss];

        [SVProgressHUD showErrorWithStatus:[notification object]];
        
    }
}


#pragma mark - Initialization methods


- (void)settingNavigationBar {
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    backButton.frame = CGRectMake(0.0, 0.0, backButtonImage.size.width, backButtonImage.size.height);
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}


#pragma mark - Privet Methods


- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(NSData*)resizeImage:(UIImage*)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData* newImageData = UIImagePNGRepresentation(newImage);
    
    return newImageData;
}


-(void)imageTapped{

    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = self.imageViewOutlet.image;
    
    imageInfo.referenceRect = self.imageViewOutlet.frame;
    
    imageInfo.referenceView = self.imageViewOutlet.superview;
    
    imageInfo.referenceContentMode = self.imageViewOutlet.contentMode;
    
    imageInfo.referenceCornerRadius = self.imageViewOutlet.layer.cornerRadius;

    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
