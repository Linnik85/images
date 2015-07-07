//
//  UIImage+SCCropImageToCircleWithBorder.m
//  SmartChat
//
//  Created by Alexsandr Linnik on 14.01.15.
//  Copyright (c) 2015 Yuriy Nezhura. All rights reserved.
//

#import "UIImage+SCCropImageToCircleWithBorder.h"

@implementation UIImage (SCCropImageToCircleWithBorder)

-(UIImage*)cropToCircleWithBorderColor:(UIColor*)color lineWidth:(CGFloat)line {
    
    CGRect imgRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContext(imgRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, imgRect);
    CGContextClip(context);
    
    [self drawAtPoint:(CGPointZero)];
    
    CGContextAddEllipseInRect(context, imgRect);
    [color setStroke];
    CGContextSetLineWidth(context, line);
    CGContextStrokePath(context);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRelease(context);
    
    return image;
    
}

@end
