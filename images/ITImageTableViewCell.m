//
//  ITImageTableViewCell.m
//  images
//
//  Created by Линник Александр on 03.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//

#import "ITImageTableViewCell.h"

@implementation ITImageTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}


-(void)prepareForReuse{
    
    self.imageIconOutlet.image = [UIImage imageNamed:@"defaultImage"];
    
    self.sizeLabelOutlet.text = [NSString stringWithFormat:@"Size:--"];
    
    self.idLabelOutlet.text = [NSString stringWithFormat: @"Image Id -"];
}


@end
