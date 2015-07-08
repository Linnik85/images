//
//  ITImageTableViewCell.h
//  images
//
//  Created by Линник Александр on 03.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIconOutlet;

@property (weak, nonatomic) IBOutlet UILabel *idLabelOutlet;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabelOutlet;

@end
