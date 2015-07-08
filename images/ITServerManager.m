//
//  ITServerManager.m
//  imagesTest
//
//  Created by Линник Александр on 02.07.15.
//  Copyright (c) 2015 Alex Linnik. All rights reserved.
//


#import "ITServerManager.h"
#import "ITImageItem.h"

@interface ITServerManager () <SOAPEngineDelegate>

@property(strong, nonatomic) SOAPEngine *soap;

@end


@implementation ITServerManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.soap = [[SOAPEngine alloc] init];
        
        self.soap.userAgent = @"SOAPEngine";
        
        self.soap.delegate = self;
        
        self.soap.actionNamespaceSlash = YES;
        
        self.soap.envelope = @"xmlns:tmp=\"http://tempuri.org/\"";
        
        self.soap.version = VERSION_WCF_1_1;

    }
    return self;
}


+(ITServerManager*) sharedManager{
    
    static ITServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
    
            manager = [[ITServerManager alloc]init];
            
        });
    
        return manager;
}


-(void)getImagList{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* requestURL = [defaults stringForKey:@"requestURL"];
    
    if (requestURL) {
      
        [self.soap requestURL:requestURL
                   soapAction:@"http://tempuri.org/IIosService/GetImageList"];
        
    } else {
        
        [self.soap requestURL:@"http://ioswcf.dataxdev.com/Service1.svc"
                   soapAction:@"http://tempuri.org/IIosService/GetImageList"];
        
    }
    
}


-(void)getImageById:(NSInteger)ID{
    
    [self.soap clearValues];

    [self.soap setIntegerValue:ID forKey:@"ImageID"];
    
    [self.soap setIntegerValue:0 forKey:@"offset"];
    
    [self.soap setIntegerValue:100000000 forKey:@"totalbytes"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* requestURL = [defaults stringForKey:@"requestURL"];
    
    if (requestURL) {
        
        [self.soap requestURL:requestURL
                   soapAction:@"http://tempuri.org/IIosService/GetImage"];
        
    } else {
        
        [self.soap requestURL:@"http://ioswcf.dataxdev.com/Service1.svc"
                   soapAction:@"http://tempuri.org/IIosService/GetImage"];
        
    }

}


#pragma mark - SOPAEngine delegates


- (void)soapEngine:(SOAPEngine *)soapEngine didFailWithError:(NSError *)error {
    
    NSString *msg = [NSString stringWithFormat:@"ERROR: %@", error.localizedDescription];
    
    if ([self.delegate respondsToSelector:@selector(errorResponds:)]) {
        
        [self.delegate errorResponds:msg];
    }
    
}


- (void)soapEngine:(SOAPEngine *)soapEngine didFinishLoading:(NSString *)stringXML {
    
    
    if ([soapEngine dictionaryValue].count>0) {
        
        NSDictionary *result = [soapEngine dictionaryValue];
        
        if([[result  allKeys] containsObject:@"int"]){
            
            NSMutableArray* arrayImagesId = [result objectForKey:@"int"];
            
            NSMutableArray* imageItems = [NSMutableArray array];
            
            for (NSString* imageID in arrayImagesId) {
                
                ITImageItem* imageItem = [[ITImageItem alloc]init];
                
                imageItem.imageID = [imageID integerValue];
                
                [imageItems addObject:imageItem];
            }
            
            if ([self.delegate respondsToSelector:@selector(getImagListResponds:)]) {
                
                [self.delegate getImagListResponds:imageItems];
            }
            
            
        }
        
    } else {
        
        NSData* data = [soapEngine dataValue];
        
        NSString* stringData = [NSString stringWithUTF8String:[data bytes]];
        
        NSData* imageData = [self dataFromBase64EncodedString:stringData];
        
        if ([self.delegate respondsToSelector:@selector(getImagResponds:)]) {
            
            [self.delegate getImagResponds:imageData];
        }
        
     }
}


- (BOOL)soapEngine:(SOAPEngine *)soapEngine didReceiveResponseCode:(NSInteger)statusCode {
    
    if (statusCode != 200 && statusCode != 500) {
        
        NSString *msg = [NSString stringWithFormat:@"ERROR: received status code %li", (long)statusCode];
        
        if ([self.delegate respondsToSelector:@selector(errorResponds:)]) {
            
            [self.delegate errorResponds:msg];
        }
        
        return NO;
    }
    
    return YES;
}


- (NSMutableURLRequest*)soapEngine:(SOAPEngine *)soapEngine didBeforeSendingURLRequest:(NSMutableURLRequest *)request {
    
    return request;
}


- (NSString *)soapEngine:(SOAPEngine *)soapEngine didBeforeParsingResponseString:(NSString *)stringXML
{
    return stringXML;
}


- (void)soapEngine:(SOAPEngine *)soapEngine didReceiveDataSize:(NSUInteger)current total:(NSUInteger)total
{
//    NSLog(@"Received %lu bytes of %lu bytes", (unsigned long)current, (unsigned long)total);
}


- (void)soapEngine:(SOAPEngine *)soapEngine didSendDataSize:(NSUInteger)current total:(NSUInteger)total
{
//    NSLog(@"Sended %lu bytes of %lu bytes", (unsigned long)current, (unsigned long)total);
}


#pragma mark - Privet Methods


-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    
    return nil;
}


@end
