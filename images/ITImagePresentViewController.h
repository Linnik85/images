//
//  ITImagePresentViewController.h
//  images
//
//  Created by Линник Александр on 03.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITSettings.h"
#import "ITImageItem.h"

@interface ITImagePresentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOutlet;

@property(strong, nonatomic) ITSettings* settings;

@property(strong, nonatomic) ITImageItem* imageItem;

@end
